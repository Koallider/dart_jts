part of dart_jts;

//todo basic prepared geom
class PreparedPolygon extends BasicPreparedGeometry {
  late bool isRectangle;
  PointOnGeometryLocator? pia;
  FastSegmentSetIntersectionFinder? segIntFinder = null;

  PreparedPolygon(Geometry geometry) : super(geometry) {
    isRectangle = baseGeom.isRectangle();

  }

  FastSegmentSetIntersectionFinder getIntersectionFinder()
  {
    if (segIntFinder == null)
      segIntFinder = FastSegmentSetIntersectionFinder(SegmentStringUtil.extractNodedSegmentStrings(getGeometry()));
    return segIntFinder!;
  }

  PointOnGeometryLocator getPointLocator() {
    if (pia == null)
      pia = IndexedPointInAreaLocator(baseGeom);
    return pia!;
  }

  bool intersects(Geometry g) {
    if (!envelopesIntersect(g)) return false;
    if (isRectangle) {
      return RectangleIntersects.intersectsStatic(baseGeom as Polygon, g);
    }
    return PreparedPolygonIntersects.intersects(this, g);
  }

/*  bool contains(Geometry g) {
    if (!envelopeCovers(g)) return false;
    if (isRectangle) {
      return RectangleContains.containsStatic(baseGeom as Polygon, g);
    }
    return PreparedPolygonContains.contains(this, g);
  }

  bool containsProperly(Geometry g) {
    if (!envelopeCovers(g)) return false;
    return PreparedPolygonContainsProperly.containsProperly(this, g);
  }

  bool covers(Geometry g) {
    if (!envelopeCovers(g)) return false;
    if (isRectangle) {
      return true;
    }
    return PreparedPolygonCovers.covers(this, g);
  }*/
}