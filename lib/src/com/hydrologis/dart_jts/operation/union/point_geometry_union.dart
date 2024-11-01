part of dart_jts;

class PointGeometryUnion {
  Geometry pointGeom;
  Geometry otherGeom;
  GeometryFactory geomFact;

  PointGeometryUnion(Puntal pointGeom, this.otherGeom) :
        this.pointGeom = pointGeom as Geometry,
        this.geomFact = otherGeom.getFactory();

  Geometry? union() {
    PointLocator locater = PointLocator();
    // use a set to eliminate duplicates, as required for union
    SplayTreeSet<Coordinate> exteriorCoords = SplayTreeSet<Coordinate>();

    for (int i = 0; i < pointGeom.getNumGeometries(); i++) {
      Point point = pointGeom.getGeometryN(i) as Point;
      Coordinate? coord = point.getCoordinate();
      if(coord != null) {
        int loc = locater.locate(coord, otherGeom);
        if (loc == Location.EXTERIOR) exteriorCoords.add(coord);
      }
    }

    // if no points are in exterior, return the other geom
    if (exteriorCoords.length == 0) return otherGeom;

    // make a puntal geometry of appropriate size
    Geometry ptComp;
    List<Coordinate> coords = exteriorCoords.toList();
    if (coords.length == 1) {
      ptComp = geomFact.createPoint(coords[0]);
    } else {
      ptComp = geomFact.createMultiPointFromCoords(coords);
    }

    // add point component to the other geometry
    return GeometryCombiner.combine2(ptComp, otherGeom);
  }

  static Geometry? unionPuntalGeometry(Puntal pointGeom, Geometry otherGeom) {
    PointGeometryUnion unioner = PointGeometryUnion(pointGeom, otherGeom);
    return unioner.union();
  }
}