part of dart_jts;

class LineMergeEdge extends PlanarEdge {
  LineString line;

  /// Constructs a LineMergeEdge with vertices given by the specified LineString.
  LineMergeEdge(this.line) : super.empty();

  /// Returns the LineString specifying the vertices of this edge.
  LineString getLine() {
    return line;
  }
}