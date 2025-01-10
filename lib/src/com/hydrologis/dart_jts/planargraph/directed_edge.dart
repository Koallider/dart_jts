part of dart_jts;

class PlanarDirectedEdge extends PlanarGraphComponent implements Comparable {
  PlanarEdge? parentEdge;
  PlanarNode from;
  PlanarNode to;
  Coordinate? p0;
  Coordinate p1;
  PlanarDirectedEdge? sym;
  bool edgeDirection;
  late int quadrant;
  late double angle;

  PlanarDirectedEdge(this.from, this.to, Coordinate directionPt, this.edgeDirection) : p1 = directionPt {
    p0 = from.getCoordinate();
    double dx = p1.x - p0!.x;//todo p0 null check
    double dy = p1.y - p0!.y;//todo p0 null check
    quadrant = Quadrant.quadrant(dx, dy);
    angle = math.atan2(dy, dx);
  }

  PlanarEdge? getEdge() => parentEdge;

  void setEdge(PlanarEdge parentEdge) {
    this.parentEdge = parentEdge;
  }

  int getQuadrant() => quadrant;

  Coordinate getDirectionPt() => p1;

  bool getEdgeDirection() => edgeDirection;

  PlanarNode getFromNode() => from;

  PlanarNode getToNode() => to;

  Coordinate? getCoordinate() => from.getCoordinate();

  double getAngle() => angle;

  PlanarDirectedEdge? getSym() => sym;

  void setSym(PlanarDirectedEdge? sym) {
    this.sym = sym;
  }

  void remove() {
    this.sym = null;
    this.parentEdge = null;
  }

  bool isRemoved() => parentEdge == null;

  @override
  int compareTo(dynamic obj) {
    PlanarDirectedEdge de = obj as PlanarDirectedEdge;
    return compareDirection(de);
  }

  int compareDirection(PlanarDirectedEdge e) {
    if (quadrant > e.quadrant) return 1;
    if (quadrant < e.quadrant) return -1;
    return Orientation.index(e.p0!, e.p1, p1);//todo p0 null check
  }

  void printDetails() {
    String className = runtimeType.toString();
    print("  $className: $p0 - $p1 $quadrant:$angle");
  }

  static List<PlanarEdge?> toEdges(Iterable<PlanarDirectedEdge> dirEdges) {
    List<PlanarEdge?> edges = [];
    for (var directedEdge in dirEdges) {
      edges.add(directedEdge.parentEdge);
    }
    return edges;
  }
}