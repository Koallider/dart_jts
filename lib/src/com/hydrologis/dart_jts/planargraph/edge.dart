part of dart_jts;

class PlanarEdge extends PlanarGraphComponent {
  List<PlanarDirectedEdge>? dirEdge;

  PlanarEdge.empty();

  PlanarEdge(PlanarDirectedEdge? de0, PlanarDirectedEdge? de1) {
    if (de0 != null && de1 != null) {
      setDirectedEdges(de0, de1);
    }
  }

  void setDirectedEdges(PlanarDirectedEdge de0, PlanarDirectedEdge de1) {
    dirEdge = [de0, de1];
    de0.setEdge(this);
    de1.setEdge(this);
    de0.setSym(de1);
    de1.setSym(de0);
    de0.getFromNode().addOutEdge(de0);
    de1.getFromNode().addOutEdge(de1);
  }

  PlanarDirectedEdge getDirEdge(int i) => dirEdge![i];

  PlanarDirectedEdge? getDirEdgeFromNode(PlanarNode fromNode) {
    if (dirEdge![0].getFromNode() == fromNode) return dirEdge![0];
    if (dirEdge![1].getFromNode() == fromNode) return dirEdge![1];
    return null;
  }

  PlanarNode? getOppositeNode(PlanarNode node) {
    if (dirEdge![0].getFromNode() == node) return dirEdge![0].getToNode();
    if (dirEdge![1].getFromNode() == node) return dirEdge![1].getToNode();
    return null;
  }

  void remove() {
    dirEdge = null;
  }

  bool isRemoved() => dirEdge == null;
}