part of dart_jts;

class SegmentIntersectionDetector  implements SegmentIntersectorN  {
  LineIntersector li;
  bool findProper = false;
  bool findAllTypes = false;

  bool hasIntersection = false;
  bool hasProperIntersection = false;
  bool hasNonProperIntersection = false;

  Coordinate? intPt = null;
  List<Coordinate>? intSegments = null;

  SegmentIntersectionDetector()
      : li = RobustLineIntersector();

  SegmentIntersectionDetector.withIntersector(this.li);

  void setFindProper(bool findProper) {
    this.findProper = findProper;
  }

  void setFindAllIntersectionTypes(bool findAllTypes) {
    this.findAllTypes = findAllTypes;
  }

  Coordinate? getIntersection() {
    return intPt;
  }

  List<Coordinate>? getIntersectionSegments() {
    return intSegments;
  }

  void processIntersections(
      SegmentString e0, int segIndex0, SegmentString e1, int segIndex1) {
    if (e0 == e1 && segIndex0 == segIndex1) return;

    Coordinate p00 = e0.getCoordinate(segIndex0);
    Coordinate p01 = e0.getCoordinate(segIndex0 + 1);
    Coordinate p10 = e1.getCoordinate(segIndex1);
    Coordinate p11 = e1.getCoordinate(segIndex1 + 1);

    li.computeIntersection(p00, p01, p10, p11);

    if (li.hasIntersection()) {
      hasIntersection = true;

      bool isProper = li.isProper();
      if (isProper)
        hasProperIntersection = true;
      if (!isProper) hasNonProperIntersection = true;

      bool saveLocation = true;
      if (findProper && !isProper) saveLocation = false;

      if (intPt == null || saveLocation) {
        intPt = li.getIntersection(0);

        intSegments = [p00, p01, p10, p11];
      }
    }
  }

  bool isDone() {
    if (findAllTypes) {
      return hasProperIntersection && hasNonProperIntersection;
    }

    if (findProper) {
      return hasProperIntersection;
    }
    return hasIntersection;
  }
}