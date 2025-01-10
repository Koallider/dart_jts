part of dart_jts;

class PlanarNodeMap {
  final SplayTreeMap<Coordinate, PlanarNode> nodeMap = SplayTreeMap();

  PlanarNodeMap();

  /// Adds a node to the map, replacing any that is already at that location.
  /// @return the added node
  PlanarNode add(PlanarNode n) {
    nodeMap[n.getCoordinate()!] = n;//todo null safety?
    return n;
  }

  /// Removes the Node at the given location, and returns it (or null if no Node was there).
  PlanarNode? remove(Coordinate pt) {
    return nodeMap.remove(pt);
  }

  /// Returns the Node at the given location, or null if no Node was there.
  PlanarNode? find(Coordinate coord) {
    return nodeMap[coord];
  }

  /// Returns an Iterator over the Nodes in this PlanarNodeMap, sorted in ascending order
  /// by angle with the positive x-axis.
  Iterator<PlanarNode> iterator() {
    return nodeMap.values.iterator;
  }

  /// Returns the Nodes in this PlanarNodeMap, sorted in ascending order
  /// by angle with the positive x-axis.
  Iterable<PlanarNode> values() {
    return nodeMap.values;
  }
}