part of dart_jts;

class SnappingNoder implements Noder {

  SnappingPointIndex snapIndex;
  double snapTolerance;
  List<NodedSegmentString>? nodedResult;

  SnappingNoder(double snapTolerance):
    this.snapTolerance = snapTolerance,
    snapIndex = SnappingPointIndex(snapTolerance);

  @override
  List<NodedSegmentString> getNodedSubstrings() {
    return nodedResult!;//todo null
  }

  @override
  void computeNodes(List segStrings) {
    List<NodedSegmentString> snappedSS = snapVertices(segStrings);
    nodedResult = snapIntersections(snappedSS);
  }

  List<NodedSegmentString> snapVertices(List segStrings) {
    seedSnapIndex(segStrings);

    List<NodedSegmentString> nodedStrings = [];
    for (SegmentString ss in segStrings) {
      nodedStrings.add(snapVerticesSegmentString(ss));
    }
    return nodedStrings;
  }

  void seedSnapIndex(List segStrings) {
    final int SEED_SIZE_FACTOR = 100;

    for (SegmentString ss in segStrings) {
      List<Coordinate> pts = ss.getCoordinates();
      int numPtsToLoad = (pts.length / SEED_SIZE_FACTOR).floor();
      double rand = 0.0;
      for (int i = 0; i < numPtsToLoad; i++) {
        rand = quasirandom(rand);
        int index = (pts.length * rand).floor();
        snapIndex.snap(pts[index]);
      }
    }
  }

  //todo move to math.util
  static final double PHI_INV = (math.sqrt(5) - 1.0) / 2.0;

  static double quasirandom( double curr) {
    return quasirandomWithAlpha(curr, PHI_INV);
  }

  static double quasirandomWithAlpha( double curr, double alpha) {
    double next = curr + alpha;
    if (next < 1) return next;
    return next - next.floor();
  }


  NodedSegmentString snapVerticesSegmentString(SegmentString ss) {
    List<Coordinate> snapCoords = snap(ss.getCoordinates());
    return NodedSegmentString(snapCoords, ss.getData());
  }

  List<Coordinate> snap(List<Coordinate> coords) {
    CoordinateList snapCoords = CoordinateList();
    for (int i = 0; i < coords.length; i++) {
      Coordinate pt = snapIndex.snap(coords[i])!;//todo null
      snapCoords.addCoord(pt, false);
    }
    return snapCoords.toCoordinateArray(false);
  }

  List<NodedSegmentString> snapIntersections(List<NodedSegmentString> inputSS) {
    SnappingIntersectionAdder intAdder = SnappingIntersectionAdder(snapTolerance, snapIndex);
    MCIndexNoder noder = MCIndexNoder.withTolerance(intAdder, 2 * snapTolerance);
    noder.computeNodes(inputSS);
    return noder.getNodedSubstrings().map((e) => e as NodedSegmentString).toList();
  }
}