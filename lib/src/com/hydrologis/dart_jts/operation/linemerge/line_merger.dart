part of dart_jts;

class LineMerger {
  LineMergeGraph graph = LineMergeGraph();
  List<LineString>? mergedLineStrings;
  GeometryFactory? factory;

  LineMerger();

  void add(Geometry geometry) {

    if(geometry is LineString){
      addLineString(geometry);
    }
  }

  void addAll(List<Geometry> geometries) {
    mergedLineStrings = null;
    for (var geometry in geometries) {
      add(geometry);
    }
  }

  void addLineString(LineString lineString) {
    if (factory == null) {
      factory = lineString.getFactory();
    }
    graph.addEdgeFromLine(lineString);
  }

  List<EdgeString>? edgeStrings;

  void merge() {
    if (mergedLineStrings != null) return;

    PlanarGraphComponent.setMarkedForIterator(graph.nodeIterator(), false);
    PlanarGraphComponent.setMarkedForIterator(graph.edgeIterator(), false);

    edgeStrings = [];
    buildEdgeStringsForObviousStartNodes();
    buildEdgeStringsForIsolatedLoops();
    mergedLineStrings = [];
    for (var edgeString in edgeStrings!) {
      mergedLineStrings!.add(edgeString.toLineString());
    }
  }

  void buildEdgeStringsForObviousStartNodes() {
    buildEdgeStringsForNonDegree2Nodes();
  }

  void buildEdgeStringsForIsolatedLoops() {
    buildEdgeStringsForUnprocessedNodes();
  }

  void buildEdgeStringsForUnprocessedNodes() {
    for (var node in graph.getNodes()) {
      if (!node.isMarked) {
        Assert.isTrue(node.getDegree() == 2);
        buildEdgeStringsStartingAt(node);
        node.isMarked = true;
      }
    }
  }

  void buildEdgeStringsForNonDegree2Nodes() {
    for (var node in graph.getNodes()) {
      if (node.getDegree() != 2) {
        buildEdgeStringsStartingAt(node);
        node.isMarked = true;
      }
    }
  }

  void buildEdgeStringsStartingAt(PlanarNode node) {
    for (var directedEdge in node.getOutEdges().outEdges) {
      if (directedEdge.getEdge()!.isMarked) continue; //todo null safe
      edgeStrings!.add(buildEdgeStringStartingWith(directedEdge as LineMergeDirectedEdge)); //todo null safe
    }
  }

  EdgeString buildEdgeStringStartingWith(LineMergeDirectedEdge start) {
    var edgeString = EdgeString(factory!);
    LineMergeDirectedEdge? current = start;
    do {
      edgeString.add(current!);
      current.getEdge()!.isMarked = true; //todo null safe
      current = current.next;
    } while (current != null && current != start);
    return edgeString;
  }

  List<LineString> getMergedLineStrings() {
    merge();
    return mergedLineStrings ?? [];
  }
}