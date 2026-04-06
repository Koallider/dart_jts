part of dart_jts;

class InteriorPointPoint {
  Coordinate? centroid;
  double minDistance = double.maxFinite;
  Coordinate? _interiorPoint;

  InteriorPointPoint(Geometry g) {
    centroid = g.getCentroid().getCoordinate();
    _add(g);
  }

  /// Computes an interior point for the puntal components of a Geometry.
  static Coordinate? getInteriorPointForGeom(Geometry geom) {
    var intPt = InteriorPointPoint(geom);
    return intPt.getInteriorPoint();
  }

  /// Tests the point(s) defined by a Geometry for the best inside point.
  /// If a Geometry is not of dimension 0 it is not tested.
  void _add(Geometry geom) {
    if (geom.isEmpty()) return;

    if (geom is Point) {
      _addCoordinate(geom.getCoordinate()!);
    } else if (geom is GeometryCollection) {
      for (int i = 0; i < geom.getNumGeometries(); i++) {
        _add(geom.getGeometryN(i));
      }
    }
  }

  void _addCoordinate(Coordinate point) {
    double dist = point.distance(centroid!);
    if (dist < minDistance) {
      _interiorPoint = Coordinate(point.x, point.y);
      minDistance = dist;
    }
  }

  Coordinate? getInteriorPoint() {
    return _interiorPoint;
  }
}