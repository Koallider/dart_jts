part of dart_jts;

class GeometrySnapper {
  static const double SNAP_PRECISION_FACTOR = 1e-9;

  static double computeOverlaySnapTolerance(Geometry g) {
    double snapTolerance = computeSizeBasedSnapTolerance(g);

    PrecisionModel pm = g.getPrecisionModel();
    if (pm.getType() == PrecisionModel.FIXED) {
      double fixedSnapTol = (1 / pm.getScale()) * 2 / 1.415;
      if (fixedSnapTol > snapTolerance)
        snapTolerance = fixedSnapTol;
    }
    return snapTolerance;
  }

  static double computeSizeBasedSnapTolerance(Geometry g) {
    Envelope env = g.getEnvelopeInternal();
    double minDimension = math.min(env.getHeight(), env.getWidth());
    double snapTol = minDimension * SNAP_PRECISION_FACTOR;
    return snapTol;
  }

  static double computeOverlaySnapTolerance2(Geometry g0, Geometry g1) {
    return math.min(computeOverlaySnapTolerance(g0), computeOverlaySnapTolerance(g1));
  }

  static List<Geometry> snap(Geometry g0, Geometry g1, double snapTolerance) {
    List<Geometry?> snapGeom = List<Geometry?>.filled(2, null);
    GeometrySnapper snapper0 = GeometrySnapper(g0);
    snapGeom[0] = snapper0._snapTo(g1, snapTolerance);

    GeometrySnapper snapper1 = GeometrySnapper(g1);
    snapGeom[1] = snapper1._snapTo(snapGeom[0]!, snapTolerance);

    return [snapGeom[0]!, snapGeom[1]!];
  }

  static Geometry snapToSelf(Geometry geom, double snapTolerance, bool cleanResult) {
    GeometrySnapper snapper0 = GeometrySnapper(geom);
    Geometry snappedGeom = snapper0._snapToSelf(snapTolerance, cleanResult);
    Geometry result = snappedGeom;
    if (cleanResult && result is Polygonal) {
      result = snappedGeom.buffer(0);
    }
    return result;
  }

  Geometry srcGeom;

  GeometrySnapper(this.srcGeom);

  Geometry _snapTo(Geometry snapGeom, double snapTolerance) {
    List<Coordinate> snapPts = extractTargetCoordinates(snapGeom);

    SnapTransformer snapTrans = SnapTransformer(snapTolerance, snapPts);
    return snapTrans.transform(srcGeom);
  }

  Geometry _snapToSelf(double snapTolerance, bool cleanResult) {
    List<Coordinate> snapPts = extractTargetCoordinates(srcGeom);

    SnapTransformer snapTrans = SnapTransformer(snapTolerance, snapPts, isSelfSnap: true);
    Geometry snappedGeom = snapTrans.transform(srcGeom);
    Geometry result = snappedGeom;
    if (cleanResult && result is Polygonal) {
      result = snappedGeom.buffer(0);
    }
    return result;
  }

  List<Coordinate> extractTargetCoordinates(Geometry g) {
    Set<Coordinate> ptSet = Set<Coordinate>();
    List<Coordinate> pts = g.getCoordinates();
    for (int i = 0; i < pts.length; i++) {
      ptSet.add(pts[i]);
    }
    return ptSet.toList();
  }

  double computeSnapTolerance(List<Coordinate> ringPts) {
    double minSegLen = computeMinimumSegmentLength(ringPts);
    double snapTol = minSegLen / 10;
    return snapTol;
  }

  double computeMinimumSegmentLength(List<Coordinate> pts) {
    double minSegLen = double.maxFinite;
    for (int i = 0; i < pts.length - 1; i++) {
      double segLen = pts[i].distance(pts[i + 1]);
      if (segLen < minSegLen)
        minSegLen = segLen;
    }
    return minSegLen;
  }
}