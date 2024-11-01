part of dart_jts;

class SnapOverlayOp {
  List<Geometry> geom;
  double snapTolerance;

  SnapOverlayOp(Geometry g1, Geometry g2) : geom = [g1, g2], snapTolerance = computeSnapTolerance(g1, g2);

  static double computeSnapTolerance(Geometry g1, Geometry g2) {
    return GeometrySnapper.computeOverlaySnapTolerance2(g1, g2);
  }

  Geometry? getResultGeometry(int opCode) {
    List<Geometry> prepGeom = snap(geom);
    Geometry? result = OverlayOp.overlayOp(prepGeom[0], prepGeom[1], opCode);
    if(result == null) {
      return null;
    }
    return prepareResult(result);
  }

  List<Geometry> snap(List<Geometry> geom) {
    //TODO TEST WITHI=OUT CBR
    //List<Geometry> remGeom = removeCommonBits(geom);
    List<Geometry> snapGeom = GeometrySnapper.snap(geom[0], geom[1], snapTolerance);
    return snapGeom;
  }

  Geometry prepareResult(Geometry geom) {
    //cbr.addCommonBits(geom);
    return geom;
  }

/*  CommonBitsRemover cbr;

  List<Geometry> removeCommonBits(List<Geometry> geom) {
    cbr = CommonBitsRemover();
    cbr.add(geom[0]);
    cbr.add(geom[1]);
    List<Geometry> remGeom = List<Geometry>.filled(2, null, growable: false);
    remGeom[0] = cbr.removeCommonBits(geom[0].copy());
    remGeom[1] = cbr.removeCommonBits(geom[1].copy());
    return remGeom;
  }*/

  static Geometry? overlayOp(Geometry g0, Geometry g1, int opCode) {
    SnapOverlayOp op = SnapOverlayOp(g0, g1);
    return op.getResultGeometry(opCode);
  }

  static Geometry? intersection(Geometry g0, Geometry g1) {
    return overlayOp(g0, g1, OverlayOp.INTERSECTION);
  }

  static Geometry? union(Geometry g0, Geometry g1) {
    return overlayOp(g0, g1, OverlayOp.UNION);
  }

  static Geometry? difference(Geometry g0, Geometry g1) {
    return overlayOp(g0, g1, OverlayOp.DIFFERENCE);
  }

  static Geometry? symDifference(Geometry g0, Geometry g1) {
    return overlayOp(g0, g1, OverlayOp.SYMDIFFERENCE);
  }
}