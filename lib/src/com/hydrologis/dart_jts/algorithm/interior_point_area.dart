part of dart_jts;

class InteriorPointArea {
  Coordinate? interiorPoint;
  double maxWidth = -1;

  InteriorPointArea(Geometry g) {
    _process(g);
  }

  Coordinate? getInteriorPoint() {
    return interiorPoint;
  }

  static Coordinate? getInteriorPointForGeom(Geometry geom) {
    var intPt = InteriorPointArea(geom);
    return intPt.getInteriorPoint();
  }

  void _process(Geometry geom) {
    if (geom.isEmpty()) return;

    if (geom is Polygon) {
      _processPolygon(geom);
    } else if (geom is GeometryCollection) {
      for (int i = 0; i < geom.getNumGeometries(); i++) {
        _process(geom.getGeometryN(i));
      }
    }
  }

  void _processPolygon(Polygon polygon) {
    var intPtPoly = _InteriorPointPolygon(polygon);
    intPtPoly.process();
    double width = intPtPoly.getWidth();
    if (width > maxWidth) {
      maxWidth = width;
      interiorPoint = intPtPoly.getInteriorPoint();
    }
  }
}

class _InteriorPointPolygon {
  final Polygon polygon;
  final double interiorPointY;
  double interiorSectionWidth = 0.0;
  Coordinate? interiorPoint;

  _InteriorPointPolygon(this.polygon)
      : interiorPointY = _ScanLineYOrdinateFinder.getScanLineY(polygon);

  Coordinate? getInteriorPoint() {
    return interiorPoint;
  }

  double getWidth() {
    return interiorSectionWidth;
  }

  void process() {
    if (polygon.isEmpty()) return;

    interiorPoint = Coordinate(polygon.getCoordinate()!.x, polygon.getCoordinate()!.y);

    List<double> crossings = [];
    _scanRing(polygon.getExteriorRing(), crossings);
    for (int i = 0; i < polygon.getNumInteriorRing(); i++) {
      _scanRing(polygon.getInteriorRingN(i), crossings);
    }
    _findBestMidpoint(crossings);
  }

  void _scanRing(LinearRing ring, List<double> crossings) {
    if (!_intersectsHorizontalLine(ring.getEnvelopeInternal(), interiorPointY)) return;

    var seq = ring.getCoordinateSequence();
    for (int i = 1; i < seq.size(); i++) {
      var ptPrev = seq.getCoordinate(i - 1);
      var pt = seq.getCoordinate(i);
      _addEdgeCrossing(ptPrev, pt, interiorPointY, crossings);
    }
  }

  void _addEdgeCrossing(Coordinate p0, Coordinate p1, double scanY, List<double> crossings) {
    if (!_intersectsHorizontalLineSegment(p0, p1, scanY)) return;
    if (!_isEdgeCrossingCounted(p0, p1, scanY)) return;

    double xInt = _intersection(p0, p1, scanY);
    crossings.add(xInt);
  }

  void _findBestMidpoint(List<double> crossings) {
    if (crossings.isEmpty) return;

    crossings.sort();
    for (int i = 0; i < crossings.length; i += 2) {
      double x1 = crossings[i];
      double x2 = crossings[i + 1];

      double width = x2 - x1;
      if (width > interiorSectionWidth) {
        interiorSectionWidth = width;
        double interiorPointX = (x1 + x2) / 2.0;
        interiorPoint = Coordinate(interiorPointX, interiorPointY);
      }
    }
  }

  bool _isEdgeCrossingCounted(Coordinate p0, Coordinate p1, double scanY) {
    double y0 = p0.y;
    double y1 = p1.y;

    if (y0 == y1) return false;
    if (y0 == scanY && y1 < scanY) return false;
    if (y1 == scanY && y0 < scanY) return false;
    return true;
  }

  double _intersection(Coordinate p0, Coordinate p1, double scanY) {
    double x0 = p0.x;
    double x1 = p1.x;

    if (x0 == x1) return x0;

    double segDX = x1 - x0;
    double segDY = p1.y - p0.y;
    double m = segDY / segDX;
    return x0 + ((scanY - p0.y) / m);
  }

  bool _intersectsHorizontalLine(Envelope env, double y) {
    return y >= env.getMinY() && y <= env.getMaxY();
  }

  bool _intersectsHorizontalLineSegment(Coordinate p0, Coordinate p1, double y) {
    return !(p0.y > y && p1.y > y) && !(p0.y < y && p1.y < y);
  }
}

class _ScanLineYOrdinateFinder {
  static double getScanLineY(Polygon poly) {
    var finder = _ScanLineYOrdinateFinder._(poly);
    return finder._getScanLineY();
  }

  final Polygon poly;
  final double centreY;
  double hiY = double.maxFinite;
  double loY = -double.maxFinite;

  _ScanLineYOrdinateFinder._(this.poly)
      : centreY = (poly.getEnvelopeInternal().getMinY() + poly.getEnvelopeInternal().getMaxY()) / 2.0;

  double _getScanLineY() {
    _process(poly.getExteriorRing());
    for (int i = 0; i < poly.getNumInteriorRing(); i++) {
      _process(poly.getInteriorRingN(i));
    }
    return (hiY + loY) / 2.0;
  }

  void _process(LineString line) {
    var seq = line.getCoordinateSequence();
    for (int i = 0; i < seq.size(); i++) {
      _updateInterval(seq.getY(i));
    }
  }

  void _updateInterval(double y) {
    if (y <= centreY) {
      if (y > loY) loY = y;
    } else if (y > centreY) {
      if (y < hiY) hiY = y;
    }
  }
}