part of dart_jts;

class SnappingIntersectionAdder implements SegmentIntersectorN {

  LineIntersector li = RobustLineIntersector();
  double snapTolerance;
  SnappingPointIndex snapPointIndex;

  SnappingIntersectionAdder(this.snapTolerance, this.snapPointIndex);

  @override
  void processIntersections(SegmentString seg0, int segIndex0, SegmentString seg1, int segIndex1) {
    if (seg0 == seg1 && segIndex0 == segIndex1) return;

    Coordinate p00 = seg0.getCoordinate(segIndex0);
    Coordinate p01 = seg0.getCoordinate(segIndex0 + 1);
    Coordinate p10 = seg1.getCoordinate(segIndex1);
    Coordinate p11 = seg1.getCoordinate(segIndex1 + 1);

    if (!isAdjacent(seg0, segIndex0, seg1, segIndex1)) {
      li.computeIntersection(p00, p01, p10, p11);

      if (li.hasIntersection() && li.getIntersectionNum() == 1) {
        Coordinate intPt = li.getIntersection(0);
        Coordinate snapPt = snapPointIndex.snap(intPt)!;//todo null

        (seg0 as NodedSegmentString).addIntersection(snapPt, segIndex0);
        (seg1 as NodedSegmentString).addIntersection(snapPt, segIndex1);
      }
    }

    processNearVertex(seg0, segIndex0, p00, seg1, segIndex1, p10, p11);
    processNearVertex(seg0, segIndex0, p01, seg1, segIndex1, p10, p11);
    processNearVertex(seg1, segIndex1, p10, seg0, segIndex0, p00, p01);
    processNearVertex(seg1, segIndex1, p11, seg0, segIndex0, p00, p01);
  }

  void processNearVertex(SegmentString srcSS, int srcIndex, Coordinate p, SegmentString ss, int segIndex, Coordinate p0, Coordinate p1) {
    if (p.distance(p0) < snapTolerance) return;
    if (p.distance(p1) < snapTolerance) return;

    double distSeg = Distance.pointToSegment(p, p0, p1);
    if (distSeg < snapTolerance) {
      (ss as NodedSegmentString).addIntersection(p, segIndex);
      (srcSS as NodedSegmentString).addIntersection(p, srcIndex);
    }
  }

  static bool isAdjacent(SegmentString ss0, int segIndex0, SegmentString ss1, int segIndex1) {
    if (ss0 != ss1) return false;

    bool isAdjacent = (segIndex0 - segIndex1).abs() == 1;
    if (isAdjacent)
      return true;
    if (ss0.isClosed()) {
      int maxSegIndex = ss0.size() - 1;
      if ((segIndex0 == 0 && segIndex1 == maxSegIndex) || (segIndex1 == 0 && segIndex0 == maxSegIndex)) {
        return true;
      }
    }
    return false;
  }

  @override
  bool isDone() {
    return false;
  }
}