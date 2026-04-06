part of dart_jts;

class InteriorPoint {
  /// Computes a location of an interior point in a [Geometry].
  /// Handles all geometry types.
  static Coordinate? getInteriorPoint(Geometry geom) {
    if (geom.isEmpty()) return null;

    Coordinate? interiorPt;
    int dim = _dimensionNonEmpty(geom);

    // This should not happen, but just in case...
    if (dim < 0) {
      return null;
    }
    if (dim == 0) {
      interiorPt = InteriorPointPoint.getInteriorPointForGeom(geom);
    } else if (dim == 1) {
      interiorPt = InteriorPointLine.getInteriorPointForGeom(geom);
    } else {
      interiorPt = InteriorPointArea.getInteriorPointForGeom(geom);
    }
    return interiorPt;
  }

  /// Determines the dimension of the non-empty elements in the geometry.
  static int _dimensionNonEmpty(Geometry geom) {
    var dimFilter = _DimensionNonEmptyFilter();
    geom.applyGF(dimFilter);
    return dimFilter.getDimension();
  }
}

class _DimensionNonEmptyFilter implements GeometryFilter {
  int _dim = -1;

  int getDimension() => _dim;

  @override
  void filter(Geometry elem) {
    if (elem is GeometryCollection) return;
    if (!elem.isEmpty()) {
      int elemDim = elem.getDimension();
      if (elemDim > _dim) _dim = elemDim;
    }
  }
}