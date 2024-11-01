part of dart_jts;

class SnapTransformer extends GeometryTransformer {
  double snapTolerance;
  List<Coordinate> snapPts;
  bool isSelfSnap = false;

  SnapTransformer(this.snapTolerance, this.snapPts, {this.isSelfSnap = false});

  CoordinateSequence transformCoordinates(CoordinateSequence coords, Geometry parent) {
    List<Coordinate> srcPts = coords.toCoordinateArray();
    List<Coordinate> newPts = snapLine(srcPts, snapPts);
    return factory._coordinateSequenceFactory.create(newPts);
  }

  List<Coordinate> snapLine(List<Coordinate> srcPts, List<Coordinate> snapPts) {
    LineStringSnapper snapper = LineStringSnapper(srcPts, snapTolerance);
    snapper.allowSnappingToSourceVertices = isSelfSnap;
    return snapper.snapTo(snapPts);
  }
}