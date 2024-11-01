part of dart_jts;

class PreparedPolygonIntersects  {

  static bool intersects(PreparedPolygon prepPoly, Geometry geom) {
    bool isInPrepGeomArea = isAnyTestComponentInTarget(prepPoly, geom);
    if (isInPrepGeomArea) return true;
    if (geom.getDimension() == 0) return false;

    List<SegmentString> lineSegStr = SegmentStringUtil.extractNodedSegmentStrings(geom);
    if (lineSegStr.length > 0) {
      bool segsIntersect = prepPoly.getIntersectionFinder().intersects(lineSegStr);
      if (segsIntersect) return true;
    }

    if (geom.getDimension() == 2) {
      bool isPrepGeomInArea = isAnyTargetComponentInAreaTest(geom, prepPoly.getRepresentativePoints());
      if (isPrepGeomInArea) return true;
    }

    return false;
  }

  static bool isAnyTestComponentInTarget(PreparedPolygon prepPoly, Geometry testGeom) {
    List<Coordinate> coords = testGeom.getCoordinates();
    for (Coordinate p in coords) {
      int loc = prepPoly.getPointLocator().locate(p);
      if (loc != Location.EXTERIOR)
        return true;
    }
    return false;
  }

  static bool isAnyTargetComponentInAreaTest(Geometry testGeom, List<Coordinate> targetRepPts) {
    PointOnGeometryLocator piaLoc = SimplePointInAreaLocator(testGeom);
    for (Coordinate p in targetRepPts) {
      int loc = piaLoc.locate(p);
      if (loc != Location.EXTERIOR)
        return true;
    }
    return false;
  }

  //todo this one is from Util

}