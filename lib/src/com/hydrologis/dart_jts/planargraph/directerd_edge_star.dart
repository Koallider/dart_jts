part of dart_jts;

class PlanarDirectedEdgeStar {
  List<PlanarDirectedEdge> outEdges = [];
  bool sorted = false;

  PlanarDirectedEdgeStar();

  void add(PlanarDirectedEdge de) {
    outEdges.add(de);
    sorted = false;
  }

  void remove(PlanarDirectedEdge de) {
    outEdges.remove(de);
  }

  Iterator<PlanarDirectedEdge> iterator() {
    sortEdges();
    return outEdges.iterator;
  }

  int getDegree() => outEdges.length;

  Coordinate? getCoordinate() {
    Iterator<PlanarDirectedEdge> it = iterator();
    if (!it.moveNext()) return null;
    PlanarDirectedEdge e = it.current;
    return e.getCoordinate();
  }

  List<PlanarDirectedEdge> getEdges() {
    sortEdges();
    return outEdges;
  }

  void sortEdges() {
    if (!sorted) {
      outEdges.sort();
      sorted = true;
    }
  }

  int getIndex(PlanarEdge edge) {
    sortEdges();
    for (int i = 0; i < outEdges.length; i++) {
      PlanarDirectedEdge de = outEdges[i];
      if (de.getEdge() == edge) return i;
    }
    return -1;
  }

  int getIndexForDirectedEdge(PlanarDirectedEdge dirEdge) {
    sortEdges();
    for (int i = 0; i < outEdges.length; i++) {
      PlanarDirectedEdge de = outEdges[i];
      if (de == dirEdge) return i;
    }
    return -1;
  }

  int getIndexByValue(int i) {
    int modi = i % outEdges.length;
    if (modi < 0) modi += outEdges.length;
    return modi;
  }

  PlanarDirectedEdge getNextEdge(PlanarDirectedEdge dirEdge) {
    int i = getIndexForDirectedEdge(dirEdge);
    return outEdges[getIndexByValue(i + 1)];
  }

  PlanarDirectedEdge getNextCWEdge(PlanarDirectedEdge dirEdge) {
    int i = getIndexForDirectedEdge(dirEdge);
    return outEdges[getIndexByValue(i - 1)];
  }
}