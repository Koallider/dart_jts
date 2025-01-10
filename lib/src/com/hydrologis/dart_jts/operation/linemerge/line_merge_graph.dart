part of dart_jts;

class LineMergeGraph extends PlanarPlanarGraph {
  /// Adds an PlanarEdge, DirectedEdges, and Nodes for the given LineString representation
  /// of an edge.
  /// Empty lines or lines with all coordinates equal are not added.
  ///
  /// @param lineString the linestring to add to the graph
  void addEdgeFromLine(LineString lineString) {
    if (lineString.isEmpty()) {
      return;
    }

    List<Coordinate> coordinates = CoordinateArrays.removeRepeatedPoints(lineString.getCoordinates());

    // don't add lines with all coordinates equal
    if (coordinates.length <= 1) return;

    Coordinate startCoordinate = coordinates[0];
    Coordinate endCoordinate = coordinates[coordinates.length - 1];
    PlanarNode startNode = getNode(startCoordinate);
    PlanarNode endNode = getNode(endCoordinate);
    PlanarDirectedEdge directedEdge0 = LineMergeDirectedEdge(startNode, endNode, coordinates[1], true);
    PlanarDirectedEdge directedEdge1 = LineMergeDirectedEdge(endNode, startNode, coordinates[coordinates.length - 2], false);
    PlanarEdge edge = LineMergeEdge(lineString);
    edge.setDirectedEdges(directedEdge0, directedEdge1);
    addEdge(edge);
  }

  PlanarNode getNode(Coordinate coordinate) {
    PlanarNode? node = findNode(coordinate);
    if (node == null) {
      node = PlanarNode(coordinate, null);
      add(node);
    }

    return node;
  }
}