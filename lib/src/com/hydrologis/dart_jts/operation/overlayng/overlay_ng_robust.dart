part of dart_jts;

class OverlayNGRobust {
  static const int NUM_SNAP_TRIES = 5;
  static const double SNAP_TOL_FACTOR = 1e12;

  static Geometry union(Geometry geom) {
    UnaryUnionOp op = UnaryUnionOp.fromGeometry(geom);
    op.setUnionFunction(OVERLAY_UNION);
    return op.unionInternal()!;//todo null
  }

  static Geometry unionFromCollection(List<Geometry> geoms) {
    UnaryUnionOp op = UnaryUnionOp.fromGeometries(geoms);
    op.setUnionFunction(OVERLAY_UNION);
    return op.unionInternal()!;//todo null
  }

  static Geometry unionFromCollectionWithGeometryFactory(List<Geometry> geoms, GeometryFactory geomFact) {
    UnaryUnionOp op = UnaryUnionOp.fromGeometriesWithGeometryFactory(geoms, geomFact);
    op.setUnionFunction(OVERLAY_UNION);
    return op.unionInternal()!;//todo null
  }

  static UnionStrategy OVERLAY_UNION = UnionStrategy(
    union: (Geometry g0, Geometry g1) {
      return overlay(g0, g1, OverlayNG.UNION);
    },
    isFloatingPrecision: () {
      return true;
    },
  );

  static Geometry? overlay(Geometry geom0, Geometry geom1, int opCode) {
    Geometry? result;
    Object exOriginal;

    try {
      result = OverlayNG.overlay(geom0, geom1, opCode);
      return result;
    } catch (ex) {
      exOriginal = ex;
    }

    result = overlaySnapTries(geom0, geom1, opCode);//todo
    if (result != null) return result;

    result = overlaySR(geom0, geom1, opCode);
    if (result != null) return result;

    throw exOriginal;
  }

  static Geometry? overlaySnapTries(Geometry geom0, Geometry geom1, int opCode) {
    Geometry? result;
    double snapTol = snapTolerance(geom0, geom1);

    for (int i = 0; i < NUM_SNAP_TRIES; i++) {
      result = overlaySnapping(geom0, geom1, opCode, snapTol);
      if (result != null) return result;

      result = overlaySnapBoth(geom0, geom1, opCode, snapTol);
      if (result != null) return result;

      snapTol = snapTol * 10;
    }

    return null;
  }

  static Geometry? overlaySnapping(Geometry geom0, Geometry geom1, int opCode, double snapTol) {
    try {
      return overlaySnapTol(geom0, geom1, opCode, snapTol);
    } catch (ex) {
      return null;
    }
  }

  static Geometry? overlaySnapBoth(Geometry geom0, Geometry geom1, int opCode, double snapTol) {
    try {
      Geometry? snap0 = snapSelf(geom0, snapTol);
      Geometry? snap1 = snapSelf(geom1, snapTol);
      if(snap0 == null || snap1 == null) return null;
      return overlaySnapTol(snap0, snap1, opCode, snapTol);
    } catch (ex) {
      return null;
    }
  }

  static Geometry? snapSelf(Geometry geom, double snapTol) {
    OverlayNG ov = OverlayNG.fromSingle(geom, geom.geomFactory._precisionModel);
    SnappingNoder snapNoder = SnappingNoder(snapTol);
    ov.setNoder(snapNoder);
    ov.setStrictMode(true);
    return ov.getResult();
  }

  static Geometry? overlaySnapTol(Geometry geom0, Geometry geom1, int opCode, double snapTol) {
    SnappingNoder snapNoder = SnappingNoder(snapTol);
    return OverlayNG.overlayWithPMAndNoder(geom0, geom1, opCode, snapNoder);
  }

  static double snapTolerance(Geometry geom0, Geometry geom1) {
    double tol0 = snapToleranceSingle(geom0);
    double tol1 = snapToleranceSingle(geom1);
    double snapTol = math.max(tol0, tol1);
    return snapTol;
  }

  static double snapToleranceSingle(Geometry geom) {
    double magnitude = ordinateMagnitude(geom);
    return magnitude / SNAP_TOL_FACTOR;
  }

  static double ordinateMagnitude(Geometry geom) {
    if (geom == null || geom.isEmpty()) return 0;
    Envelope env = geom.getEnvelopeInternal();
    double magMax = math.max(
        env.getMaxX().abs(), env.getMaxY().abs());
    double magMin = math.max(
        env.getMinX().abs(), env.getMinY().abs());
    return math.max(magMax, magMin);
  }

  static Geometry? overlaySR(Geometry geom0, Geometry geom1, int opCode) {
    try {
      double scaleSafe = safeScaleGeometries(geom0, geom1);
      PrecisionModel pmSafe = PrecisionModel.fixedPrecision(scaleSafe);
      return OverlayNG.overlayWithPM(geom0, geom1, opCode, pmSafe);
    } catch (ex) {
    return null;
    }
  }

  static double safeScaleGeometries(Geometry a, Geometry? b) {
    double maxBnd = maxBoundMagnitude( a.getEnvelopeInternal());
    if (b != null) {
      double maxBndB = maxBoundMagnitude( b.getEnvelopeInternal());
      maxBnd = math.max(maxBnd,  maxBndB);
    }
    double scale = safeScale(maxBnd);
    return scale;
  }

  static double maxBoundMagnitude(Envelope env) {
    return math.max(
        math.max(env.getMaxX().abs(), env.getMaxY().abs()),
        math.max(env.getMinX().abs(), env.getMinY().abs()),
    );
  }

  //todo move to util
  static int MAX_ROBUST_DP_DIGITS = 14;


  static double safeScale(double value)
  {
    return precisionScale(value, MAX_ROBUST_DP_DIGITS);
  }

  static double precisionScale(
      double value, int precisionDigits)
  {
    // the smallest power of 10 greater than the value
    int magnitude = (math.log(value) / math.log(10) + 1.0).toInt();
    int precDigits = precisionDigits - magnitude;

    double scaleFactor = math.pow(10.0, precDigits).toDouble();
    return scaleFactor;
  }

}