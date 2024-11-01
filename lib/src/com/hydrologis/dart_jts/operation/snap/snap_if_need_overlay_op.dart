part of dart_jts;

class SnapIfNeededOverlayOp {
  List<Geometry> geom;

  SnapIfNeededOverlayOp(Geometry g1, Geometry g2) : geom = [g1, g2];

  Geometry? getResultGeometry(int opCode) {
    Geometry? result;
    bool isSuccess = false;
    Object? savedException;
    try {
      result = OverlayOp.overlayOp(geom[0], geom[1], opCode);
      bool isValid = true;
      if (isValid) isSuccess = true;
    } catch (e) {
      savedException = e;
    }
    if (!isSuccess) {
      try {
        result = SnapOverlayOp.overlayOp(geom[0], geom[1], opCode);
      } catch (e) {
        throw savedException ?? "Could not snap overlay";
      }
    }
    return result;
  }

  static Geometry? overlayOp(Geometry g0, Geometry g1, int opCode) {
    SnapIfNeededOverlayOp op = SnapIfNeededOverlayOp(g0, g1);
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