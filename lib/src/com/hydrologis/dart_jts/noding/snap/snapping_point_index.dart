part of dart_jts;

class SnappingPointIndex {
  double snapTolerance;
  KdTree snapPointIndex;

  SnappingPointIndex(this.snapTolerance) :
    snapPointIndex = KdTree(snapTolerance);

  Coordinate? snap(Coordinate p) {
    KdNode node = snapPointIndex.insertCoordinate(p);
    return node.getCoordinate();
  }

  double get tolerance => snapTolerance;

  int depth() {
    return snapPointIndex.depth();
  }
}