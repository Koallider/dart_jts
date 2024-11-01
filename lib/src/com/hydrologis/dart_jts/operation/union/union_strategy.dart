part of dart_jts;

class UnionStrategy {
  Geometry? Function (Geometry g0, Geometry g1) union;

  bool Function() isFloatingPrecision;

  UnionStrategy({required this.union, required this.isFloatingPrecision});
}