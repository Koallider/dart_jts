part of dart_jts;

class FastSegmentSetIntersectionFinder{
  MCIndexSegmentSetMutualIntersector segSetMutInt; //todo interface

  FastSegmentSetIntersectionFinder(List<SegmentString> baseSegStrings)
      : segSetMutInt = MCIndexSegmentSetMutualIntersector(baseSegStrings);

  MCIndexSegmentSetMutualIntersector getSegmentSetIntersector() {
    return segSetMutInt;
  }

  bool intersects(List<SegmentString> segStrings) {
    SegmentIntersectionDetector intFinder = SegmentIntersectionDetector();
    return intersectsDetector(segStrings, intFinder);
  }

  bool intersectsDetector(List<SegmentString> segStrings,
      SegmentIntersectionDetector intDetector) {
    segSetMutInt.process(segStrings, intDetector);
    return intDetector.hasIntersection;
  }
}