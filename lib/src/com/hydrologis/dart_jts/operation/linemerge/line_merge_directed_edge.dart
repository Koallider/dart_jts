part of dart_jts;

class LineMergeDirectedEdge extends PlanarDirectedEdge {
  LineMergeDirectedEdge(PlanarNode from, PlanarNode to, Coordinate directionPt, bool edgeDirection)
      : super(from, to, directionPt, edgeDirection);

  LineMergeDirectedEdge? get next {
    if (getToNode().getDegree() != 2) {
      return null;
    }
    if (getToNode().getOutEdges().getEdges()[0] == sym) {
      return getToNode().getOutEdges().getEdges()[1] as LineMergeDirectedEdge;
    }
    Assert.isTrue(getToNode().getOutEdges().getEdges()[1] == sym);
    return getToNode().getOutEdges().getEdges()[0] as LineMergeDirectedEdge;
  }
}