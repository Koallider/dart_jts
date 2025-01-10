part of dart_jts;

class PlanarNode extends PlanarGraphComponent {
  Coordinate? pt;
  PlanarDirectedEdgeStar deStar;

  PlanarNode(this.pt, PlanarDirectedEdgeStar? deStar)
      : this.deStar = deStar ?? PlanarDirectedEdgeStar();

  Coordinate? getCoordinate() => pt;

  void addOutEdge(PlanarDirectedEdge de) {
    deStar.add(de);
  }

  PlanarDirectedEdgeStar getOutEdges() => deStar;

  int getDegree() => deStar.getDegree();

  int getIndex(PlanarEdge edge) => deStar.getIndex(edge);

  void removeEdge(PlanarDirectedEdge de) {
    deStar.remove(de);
  }

  void remove() {
    pt = null;
  }

  bool isRemoved() => pt == null;

  static Iterable getEdgesBetween(PlanarNode node0, PlanarNode node1) {
    List edges0 = PlanarDirectedEdge.toEdges(node0.getOutEdges().getEdges());
    Set commonEdges = Set.from(edges0);
    List edges1 = PlanarDirectedEdge.toEdges(node1.getOutEdges().getEdges());
    commonEdges.retainAll(edges1);
    return commonEdges;
  }
}
