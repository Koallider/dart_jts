part of dart_jts;

class EdgeString {
  GeometryFactory factory;
  List<LineMergeDirectedEdge> directedEdges = [];
  List<Coordinate>? coordinates;

  EdgeString(this.factory);

  void add(LineMergeDirectedEdge directedEdge) {
    directedEdges.add(directedEdge);
  }

  List<Coordinate> getCoordinates() {
    if (coordinates == null) {
      int forwardDirectedEdges = 0;
      int reverseDirectedEdges = 0;
      CoordinateList coordinateList = CoordinateList();
      for (var directedEdge in directedEdges) {
        if (directedEdge.edgeDirection) {
          forwardDirectedEdges++;
        } else {
          reverseDirectedEdges++;
        }
        coordinateList.add3(
            (directedEdge.getEdge() as LineMergeEdge).line.getCoordinates(),
            false,
            directedEdge.edgeDirection);
      }
      coordinates = coordinateList.toCoordinateArray(true);
      if (reverseDirectedEdges > forwardDirectedEdges) {
        coordinates = coordinates!.reversed.toList();
      }
    }
    return coordinates!;
  }

  LineString toLineString() {
    return factory.createLineString(getCoordinates());
  }
}