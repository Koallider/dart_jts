part of dart_jts;

abstract class PlanarPlanarGraph {
  Set<PlanarEdge> edges = {};
  Set<PlanarDirectedEdge> dirEdges = {};
  PlanarNodeMap nodeMap = PlanarNodeMap();

  PlanarPlanarGraph();

  PlanarNode? findNode(Coordinate pt) {
    return nodeMap.find(pt);
  }

  void add(PlanarNode node) {
    nodeMap.add(node);
  }

  void addEdge(PlanarEdge edge) {
    edges.add(edge);
    addDirectedEdge(edge.getDirEdge(0));
    addDirectedEdge(edge.getDirEdge(1));
  }

  void addDirectedEdge(PlanarDirectedEdge dirEdge) {
    dirEdges.add(dirEdge);
  }

  Iterator<PlanarNode> nodeIterator() {
    return nodeMap.iterator();
  }

  bool containsEdge(PlanarEdge e) {
    return edges.contains(e);
  }

  bool containsDirectedEdge(PlanarDirectedEdge de) {
    return dirEdges.contains(de);
  }

  Iterable<PlanarNode> getNodes() {
    return nodeMap.values();
  }

  Iterator<PlanarDirectedEdge> dirEdgeIterator() {
    return dirEdges.iterator;
  }

  Iterator<PlanarEdge> edgeIterator() {
    return edges.iterator;
  }

  Iterable<PlanarEdge> getEdges() {
    return edges;
  }

  void removeEdge(PlanarEdge edge) {
    removeDirectedEdge(edge.getDirEdge(0));
    removeDirectedEdge(edge.getDirEdge(1));
    edges.remove(edge);
    edge.remove();
  }

  void removeDirectedEdge(PlanarDirectedEdge de) {
    PlanarDirectedEdge? sym = de.getSym();
    if (sym != null) sym.setSym(null);

    de.getFromNode().removeEdge(de);
    de.remove();
    dirEdges.remove(de);
  }

  void removeNode(PlanarNode node) {
    List<PlanarDirectedEdge> outEdges = node.getOutEdges().getEdges();
    for (var de in outEdges) {
      PlanarDirectedEdge? sym = de.getSym();
      if (sym != null) removeDirectedEdge(sym);
      dirEdges.remove(de);

      PlanarEdge? edge = de.getEdge();
      if (edge != null) {
        edges.remove(edge);
      }
    }
    if(node.getCoordinate() != null) {
      nodeMap.remove(node.getCoordinate()!);
    }
    node.remove();
  }

  List<PlanarNode> findNodesOfDegree(int degree) {
    List<PlanarNode> nodesFound = [];
    for (var node in getNodes()) {
      if (node.getDegree() == degree) {
        nodesFound.add(node);
      }
    }
    return nodesFound;
  }
}