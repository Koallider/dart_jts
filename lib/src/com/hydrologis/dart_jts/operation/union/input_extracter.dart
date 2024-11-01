part of dart_jts;

class InputExtracter implements GeometryFilter {
  GeometryFactory? geomFactory;
  List<Polygon> polygons = [];
  List<LineString> lines = [];
  List<Point> points = [];

  int dimension = -1; // Equivalent to Dimension.FALSE in Java

  InputExtracter();

  bool get isEmpty => polygons.isEmpty && lines.isEmpty && points.isEmpty;

  int get getDimension => dimension;

  GeometryFactory? get getFactory => geomFactory;

  static InputExtracter extract(List<Geometry> geoms) {
    InputExtracter extracter = InputExtracter();
    extracter.add(geoms);
    return extracter;
  }

  static InputExtracter extractFromGeometry(Geometry geom) {
    InputExtracter extracter = InputExtracter();
    extracter.addGeometry(geom);
    return extracter;
  }

  List<Geometry> getExtract(int dim) {
    switch (dim) {
      case 0:
        return points;
      case 1:
        return lines;
      case 2:
        return polygons;
      default:
        throw Exception('Invalid dimension: $dim');
    }
  }

  void add(List<Geometry> geoms) {
    for (Geometry geom in geoms) {
      addGeometry(geom);
    }
  }

  void addGeometry(Geometry geom) {
    if (geomFactory == null) geomFactory = geom.geomFactory;

    geom.applyGF(this);
  }

  @override
  void filter(Geometry geom) {
    recordDimension(geom.getDimension());

    if (geom is GeometryCollection) {
      return;
    }

    if (geom.isEmpty()) return;

    if (geom is Polygon) {
      polygons.add(geom);
    } else if (geom is LineString) {
      lines.add(geom);
    } else if (geom is Point) {
      points.add(geom);
    } else {
      throw Exception('Unhandled geometry type: ${geom.getGeometryType()}');
    }
  }

  void recordDimension(int dim) {
    if (dim > dimension) dimension = dim;
  }
}