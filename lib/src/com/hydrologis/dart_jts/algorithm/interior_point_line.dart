part of dart_jts;

class InteriorPointLine {
  Coordinate? centroid;
  double minDistance = double.maxFinite;
  Coordinate? interiorPoint;

  InteriorPointLine(Geometry g) {
    centroid = g.getCentroid().getCoordinate();
    _addInterior(g);
    if (interiorPoint == null) {
      _addEndpoints(g);
    }
  }

  Coordinate? getInteriorPoint() {
    return interiorPoint;
  }

  static Coordinate? getInteriorPointForGeom(Geometry geom) {
    var intPt = InteriorPointLine(geom);
    return intPt.getInteriorPoint();
  }

  /// Tests the interior vertices (if any) defined by a linear Geometry for the best inside point.
  /// If a Geometry is not of dimension 1, it is not tested.
  void _addInterior(Geometry geom) {
    if (geom.isEmpty()) return;

    if (geom is LineString) {
      _addInteriorCoordinates(geom.getCoordinates());
    } else if (geom is GeometryCollection) {
      for (int i = 0; i < geom.getNumGeometries(); i++) {
        _addInterior(geom.getGeometryN(i));
      }
    }
  }

  void _addInteriorCoordinates(List<Coordinate> pts) {
    for (int i = 1; i < pts.length - 1; i++) {
      _add(pts[i]);
    }
  }

  /// Tests the endpoint vertices defined by a linear Geometry for the best inside point.
  /// If a Geometry is not of dimension 1, it is not tested.
  void _addEndpoints(Geometry geom) {
    if (geom.isEmpty()) return;

    if (geom is LineString) {
      _addEndpointCoordinates(geom.getCoordinates());
    } else if (geom is GeometryCollection) {
      for (int i = 0; i < geom.getNumGeometries(); i++) {
        _addEndpoints(geom.getGeometryN(i));
      }
    }
  }

  void _addEndpointCoordinates(List<Coordinate> pts) {
    _add(pts[0]);
    _add(pts[pts.length - 1]);
  }

  void _add(Coordinate point) {
    double dist = point.distance(centroid!);
    if (dist < minDistance) {
      interiorPoint = Coordinate(point.x, point.y);
      minDistance = dist;
    }
  }
}