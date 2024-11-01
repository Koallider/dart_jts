part of dart_jts;

class CascadedPolygonUnion {
  static final UnionStrategy CLASSIC_UNION = UnionStrategy(
    union: (Geometry g0, Geometry g1) {
      try {
        return SnapIfNeededOverlayOp.union(g0, g1);
      } catch (e) {
        return OverlayNGRobust.overlay(g0, g1, OverlayNG.UNION);
      }
    },
    isFloatingPrecision: () => true,
  );

  List<Polygon>? inputPolys;
  GeometryFactory? geomFactory;
  UnionStrategy unionFun;

  int countRemainder = 0;
  int countInput = 0;

  static final int STRTREE_NODE_CAPACITY = 4;

  CascadedPolygonUnion(List<Polygon> polys, {UnionStrategy? unionFun})
      : inputPolys = polys,
        unionFun = unionFun ?? CLASSIC_UNION {
    countInput = inputPolys!.length;
    countRemainder = countInput;
  }

  Geometry? _union() {
    if (inputPolys == null) return null;
    if (inputPolys!.isEmpty) return null;
    geomFactory = inputPolys!.first.geomFactory;


    STRtree tree = STRtree.withCapacity(STRTREE_NODE_CAPACITY);
    inputPolys!.forEach((element) => tree.insert(element.getEnvelopeInternal(), element),);

    // To avoiding holding memory remove references to the input geometries,
    inputPolys = null;

    List itemTree = tree.itemsTree();

    Geometry? unionAll = unionTree(itemTree);
    return unionAll;
  }

  static Geometry? union(List<Geometry> polys) {
    CascadedPolygonUnion op = CascadedPolygonUnion(polys.map((e) => e as Polygon).toList());
    return op._union();
  }

  static Geometry? unionWithStrategy(List<Geometry> polys, UnionStrategy unionFun) {
    CascadedPolygonUnion op = CascadedPolygonUnion(polys.map((e) => e as Polygon).toList(), unionFun: unionFun);
    return op._union();
  }

  Geometry? unionTree(List geomTree) {
    List geoms = reduceToGeometries(geomTree);
    Geometry? union = binaryUnion(geoms);
    return union;
  }

  List reduceToGeometries(List geomTree) {
    List<Geometry> geoms = [];
    for (var o in geomTree) {
      Geometry? geom;
      if (o is List) {
        geom = unionTree(o);
      } else if (o is Geometry) {
        geom = o;
      }
      if(geom != null){
      geoms.add(geom);
      }
    }
    return geoms;
  }

  Geometry? binaryUnion(List geoms) {
    return binaryUnionRange(geoms, 0, geoms.length);
  }

  Geometry? binaryUnionRange(List geoms, int start, int end) {
    if (end - start <= 1) {
      Geometry? g0 = getGeometry(geoms, start);
      return unionSafe(g0, null);
    } else if (end - start == 2) {
      return unionSafe(getGeometry(geoms, start), getGeometry(geoms, start + 1));
    } else {
      int mid = (end + start) ~/ 2;
      Geometry? g0 = binaryUnionRange(geoms, start, mid);
      Geometry? g1 = binaryUnionRange(geoms, mid, end);
      return unionSafe(g0, g1);
    }
  }

  static Geometry? getGeometry(List list, int index) {
    if (index >= list.length) return null;
    return list[index];
  }

  Geometry? unionSafe(Geometry? g0, Geometry? g1) {
    if (g0 == null && g1 == null) return null;
    if (g0 == null) return g1!.copy();
    if (g1 == null) return g0.copy();

    countRemainder--;
    Geometry union = unionActual(g0, g1);
    return union;
  }

  Geometry unionActual(Geometry g0, Geometry g1) {
    Geometry union = unionFun.union(g0, g1)!;//TODO NULL GEOMETRY RETURNS CHECK ON ALL STACK
    Geometry unionPoly = restrictToPolygons(union);
    return unionPoly;
  }

  static Geometry restrictToPolygons(Geometry g) {
    if (g is Polygonal) {
      return g;
    }
    List<Polygon>? polygons = PolygonExtracter.getPolygons(g);
    if (polygons.length == 1) return polygons[0];
    return g.geomFactory.createMultiPolygon(polygons);
  }
}