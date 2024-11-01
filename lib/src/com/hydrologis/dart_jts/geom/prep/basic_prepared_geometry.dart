part of dart_jts;

class BasicPreparedGeometry {
  Geometry baseGeom;
  List<Coordinate> representativePts;

  BasicPreparedGeometry(this.baseGeom)
      : representativePts = baseGeom.getCoordinates();

  Geometry getGeometry() {
    return baseGeom;
  }

  List<Coordinate> getRepresentativePoints() {
    return representativePts;
  }

  bool isAnyTargetComponentInTest(Geometry testGeom) {
    PointLocator locator = new PointLocator();
    for (var p in representativePts) {
      if (locator.intersects(p, testGeom)) {
        return true;
      }
    }
    return false;
  }

  bool envelopesIntersect(Geometry g) {
    if (!baseGeom.getEnvelopeInternal().intersectsEnvelope(g.getEnvelopeInternal())) {
      return false;
    }
    return true;
  }

  bool envelopeCovers(Geometry g) {
    if (!baseGeom.getEnvelopeInternal().intersectsEnvelope(g.getEnvelopeInternal())) {
      return false;
    }
    return true;
  }

  bool contains(Geometry g) {
    return baseGeom.contains(g);
  }

  bool containsProperly(Geometry g) {
    if (!baseGeom.getEnvelopeInternal().intersectsEnvelope(g.getEnvelopeInternal())) {
      return false;
    }
    return baseGeom.relateWithPattern(g, "T**FF*FF*");
  }

  bool coveredBy(Geometry g) {
    return baseGeom.coveredBy(g);
  }

  bool covers(Geometry g) {
    return baseGeom.covers(g);
  }

  bool crosses(Geometry g) {
    return baseGeom.crosses(g);
  }

  bool disjoint(Geometry g) {
    return !intersects(g);
  }

  bool intersects(Geometry g) {
    return baseGeom.intersects(g);
  }

  bool overlaps(Geometry g) {
    return baseGeom.overlaps(g);
  }

  bool touches(Geometry g) {
    return baseGeom.touches(g);
  }

  bool within(Geometry g) {
    return baseGeom.within(g);
  }

  @override
  String toString() {
    return baseGeom.toString();
  }
}
