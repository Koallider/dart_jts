part of dart_jts;

class LineStringSnapper {
  double snapTolerance = 0.0;
  List<Coordinate> srcPts;
  LineSegment seg = LineSegment.empty(); // for reuse during snapping
  bool allowSnappingToSourceVertices = false;
  bool isClosed = false;

  LineStringSnapper(this.srcPts, this.snapTolerance) : isClosed = _isClosed(srcPts);

  void setAllowSnappingToSourceVertices(bool allowSnappingToSourceVertices) {
    this.allowSnappingToSourceVertices = allowSnappingToSourceVertices;
  }

  static bool _isClosed(List<Coordinate> pts) {
    if (pts.length <= 1) return false;
    return pts[0] == pts[pts.length - 1];
  }

  List<Coordinate> snapTo(List<Coordinate> snapPts) {
    List<Coordinate> coordList = List.from(srcPts);

    _snapVertices(coordList, snapPts);
    _snapSegments(coordList, snapPts);

    return coordList;
  }

  void _snapVertices(List<Coordinate> srcCoords, List<Coordinate> snapPts) {
    int end = isClosed ? srcCoords.length - 1 : srcCoords.length;
    for (int i = 0; i < end; i++) {
      Coordinate srcPt = srcCoords[i];
      Coordinate? snapVert = _findSnapForVertex(srcPt, snapPts);
      if (snapVert != null) {
        srcCoords[i] = snapVert;
        if (i == 0 && isClosed)
          srcCoords[srcCoords.length - 1] = snapVert;
      }
    }
  }

  Coordinate? _findSnapForVertex(Coordinate pt, List<Coordinate> snapPts) {
    for (int i = 0; i < snapPts.length; i++) {
      if (pt == snapPts[i])
        return null;
      if (pt.distance(snapPts[i]) < snapTolerance)
        return snapPts[i];
    }
    return null;
  }

  void _snapSegments(List<Coordinate> srcCoords, List<Coordinate> snapPts) {
    if (snapPts.isEmpty) return;

    int distinctPtCount = snapPts.length;

    if (snapPts[0] == snapPts[snapPts.length - 1])
      distinctPtCount = snapPts.length - 1;

    for (int i = 0; i < distinctPtCount; i++) {
      Coordinate snapPt = snapPts[i];
      int index = _findSegmentIndexToSnap(snapPt, srcCoords);
      if (index >= 0) {
        srcCoords.insert(index + 1, snapPt);
      }
    }
  }

  int _findSegmentIndexToSnap(Coordinate snapPt, List<Coordinate> srcCoords) {
    double minDist = double.maxFinite;
    int snapIndex = -1;
    for (int i = 0; i < srcCoords.length - 1; i++) {
      seg.p0 = srcCoords[i];
      seg.p1 = srcCoords[i + 1];

      if (seg.p0 == snapPt || seg.p1 == snapPt) {
        if (allowSnappingToSourceVertices)
          continue;
        else
          return -1;
      }

      double dist = seg.distanceCoord(snapPt);
      if (dist < snapTolerance && dist < minDist) {
        minDist = dist;
        snapIndex = i;
      }
    }
    return snapIndex;
  }
}