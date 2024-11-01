part of dart_jts;

class MCIndexSegmentSetMutualIntersector {
  STRtree index = STRtree();
  double overlapTolerance = 0.0;
  Envelope? envelope;

  MCIndexSegmentSetMutualIntersector(List<SegmentString> baseSegStrings) {
    _initBaseSegments(baseSegStrings);
  }

  MCIndexSegmentSetMutualIntersector.withEnvelope(List<SegmentString> baseSegStrings, Envelope env) {
    this.envelope = env;
    _initBaseSegments(baseSegStrings);
  }

  MCIndexSegmentSetMutualIntersector.withTolerance(List<SegmentString> baseSegStrings, double overlapTolerance) {
    this.overlapTolerance = overlapTolerance;
    _initBaseSegments(baseSegStrings);
  }

  SpatialIndex getIndex() {
    return index;
  }

  void _initBaseSegments(List<SegmentString> segStrings) {
    for (SegmentString ss in segStrings) {
      if (ss.size() == 0) continue;
      _addToIndex(ss);
    }
    index.build();
  }

  void _addToIndex(SegmentString segStr) {
    List<MonotoneChainI> segChains = MonotoneChainBuilder.getChainsWithContext(segStr.getCoordinates(), segStr);
    for (MonotoneChainI mc in segChains) {
      if (envelope == null || envelope!.intersectsEnvelope(mc.getEnvelope())) {
        index.insert(mc.getEnvelopeWithTolerance(overlapTolerance), mc);
      }
    }
  }

  @override
  void process(List<SegmentString> segStrings, SegmentIntersectorN segInt) {
    List<MonotoneChainI> monoChains = [];
    for (SegmentString segStr in segStrings) {
      _addToMonoChains(segStr, monoChains);
    }
    _intersectChains(monoChains, segInt);
  }

  void _addToMonoChains(SegmentString segStr, List<MonotoneChainI> monoChains) {
    if (segStr.size() == 0) return;
    List<MonotoneChainI> segChains = MonotoneChainBuilder.getChainsWithContext(segStr.getCoordinates(), segStr);
    for (MonotoneChainI mc in segChains) {
      if (envelope == null || envelope!.intersectsEnvelope(mc.getEnvelope())) {
        monoChains.add(mc);
      }
    }
  }

  void _intersectChains(List<MonotoneChainI> monoChains, SegmentIntersectorN segInt) {
    SegmentOverlapAction overlapAction = SegmentOverlapAction(segInt);

    for (MonotoneChainI queryChain in monoChains) {
      Envelope queryEnv = queryChain.getEnvelopeWithTolerance(overlapTolerance);
      List<MonotoneChainI> overlapChains = index.query(queryEnv).map((e) => e as MonotoneChainI,).toList();
      for (MonotoneChainI testChain in overlapChains) {
        queryChain.computeOverlaps6(queryChain.start, queryChain.end, testChain, testChain.start, testChain.end, overlapAction);
        if (segInt.isDone()) return;
      }
    }
  }
}