part of dart_jts;

class UnaryUnionOp {

  static Geometry union(List<Geometry> geoms) {
    UnaryUnionOp op = UnaryUnionOp.fromGeometries(geoms);
    return op.unionInternal()!;//todo can geometry be null?
  }

  static Geometry unionWithGeometryFactory(List<Geometry> geoms, GeometryFactory geomFact) {
    UnaryUnionOp op = UnaryUnionOp.fromGeometriesWithGeometryFactory(geoms, geomFact);
    return op.unionInternal()!;//todo can geometry be null?
  }

  static Geometry unionFromGeometry(Geometry geom) {
    UnaryUnionOp op = UnaryUnionOp.fromGeometry(geom);
    return op.unionInternal()!;//todo can geometry be null?
  }

  GeometryFactory? geomFactory;
  InputExtracter? extracter;
  UnionStrategy unionFunction = CascadedPolygonUnion.CLASSIC_UNION;

  UnaryUnionOp.fromGeometriesWithGeometryFactory(List<Geometry> geoms, GeometryFactory geomFact) {
    this.geomFactory = geomFact;
    extract(geoms);
  }

  UnaryUnionOp.fromGeometries(List<Geometry> geoms) {
    extract(geoms);
  }

  UnaryUnionOp.fromGeometry(Geometry geom) {
    extractFromGeometry(geom);
  }

  void setUnionFunction(UnionStrategy unionFun) {
    this.unionFunction = unionFun;
  }

  void extract(List<Geometry> geoms) {
    extracter = InputExtracter.extract(geoms);
  }

  void extractFromGeometry(Geometry geom) {
    extracter = InputExtracter.extractFromGeometry(geom);
  }

  Geometry? unionInternal() {
    if (geomFactory == null) {
      geomFactory = extracter!.geomFactory;
    }

    if (geomFactory == null) {
      return null;
    }

    if (extracter!.isEmpty) {
      return geomFactory!.createEmpty(extracter!.dimension);
    }

    List<Point> points = extracter!.getExtract(0) as List<Point>;
    List<LineString> lines = extracter!.getExtract(1) as List<LineString>;
    List<Polygon> polygons = extracter!.getExtract(2) as List<Polygon>;

    Geometry? unionPoints;
    if (points.isNotEmpty) {
      Geometry ptGeom = geomFactory!.buildGeometry(points);
      unionPoints = unionNoOpt(ptGeom);
    }

    Geometry? unionLines;
    if (lines.isNotEmpty) {
      Geometry lineGeom = geomFactory!.buildGeometry(lines);
      unionLines = unionNoOpt(lineGeom);
    }

    Geometry? unionPolygons;
    if (polygons.isNotEmpty) {
      unionPolygons = CascadedPolygonUnion.unionWithStrategy(polygons, unionFunction);
    }

    Geometry? unionLA = unionWithNull(unionLines, unionPolygons);
    Geometry? union;
    if (unionPoints == null) {
      union = unionLA;
    } else if (unionLA == null) {
      union = unionPoints;
    } else {
      union = PointGeometryUnion.unionPuntalGeometry(unionPoints as Puntal, unionLA);
    }

    if (union == null) {
      return geomFactory!.createGeometryCollectionEmpty();
    }

    return union;
  }

  Geometry? unionWithNull(Geometry? g0, Geometry? g1) {
    if (g0 == null && g1 == null) {
      return null;
    }

    if (g1 == null) {
      return g0;
    }

    if (g0 == null) {
      return g1;
    }

    return g0.unionGeom(g1);//todo union geom impl
  }

  Geometry? unionNoOpt(Geometry g0) {
    Geometry empty = geomFactory!.createPointEmpty();
    return unionFunction.union(g0, empty);
  }
}