/// Entry point for the dart_jts library.
library dart_jts;

import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:collection/collection.dart' show ListEquality;

part 'src/com/hydrologis/dart_jts/io/io.dart';
part 'src/com/hydrologis/dart_jts/io/hex.dart';
part 'src/com/hydrologis/dart_jts/io/wkb.dart';
part 'src/com/hydrologis/dart_jts/geom/coordinate.dart';
part 'src/com/hydrologis/dart_jts/geom/envelope.dart';
part 'src/com/hydrologis/dart_jts/geom/geom.dart';
part 'src/com/hydrologis/dart_jts/geom/util.dart';
part 'src/com/hydrologis/dart_jts/geom/prep/prepared_polygon.dart';
part 'src/com/hydrologis/dart_jts/geom/prep/basic_prepared_geometry.dart';
part 'src/com/hydrologis/dart_jts/geom/prep/prepared_polygon_intersects.dart';
part 'src/com/hydrologis/dart_jts/algorithm/distance.dart';
part 'src/com/hydrologis/dart_jts/algorithm/convexthull.dart';
part 'src/com/hydrologis/dart_jts/algorithm/algorithm.dart';
part 'src/com/hydrologis/dart_jts/algorithm/locate.dart';
part 'src/com/hydrologis/dart_jts/algorithm/construct.dart';
part 'src/com/hydrologis/dart_jts/operation/operation.dart';
part 'src/com/hydrologis/dart_jts/operation/valid.dart';
part 'src/com/hydrologis/dart_jts/operation/relate.dart';
part 'src/com/hydrologis/dart_jts/operation/overlay.dart';
part 'src/com/hydrologis/dart_jts/operation/predicate.dart';
part 'src/com/hydrologis/dart_jts/operation/buffer.dart';
part 'src/com/hydrologis/dart_jts/operation/buffer_validate.dart';
part 'src/com/hydrologis/dart_jts/operation/union/unary_union_op.dart';
part 'src/com/hydrologis/dart_jts/operation/union/cascaded_polygon_union.dart';
part 'src/com/hydrologis/dart_jts/operation/union/union_strategy.dart';
part 'src/com/hydrologis/dart_jts/operation/union/input_extracter.dart';
part 'src/com/hydrologis/dart_jts/operation/union/point_geometry_union.dart';
part 'src/com/hydrologis/dart_jts/operation/snap/snap_if_need_overlay_op.dart';
part 'src/com/hydrologis/dart_jts/operation/snap/snap_overlay_op.dart';
part 'src/com/hydrologis/dart_jts/operation/snap/geometry_snapper.dart';
part 'src/com/hydrologis/dart_jts/operation/snap/snap_transformer.dart';
part 'src/com/hydrologis/dart_jts/operation/snap/line_string_snapper.dart';
part 'src/com/hydrologis/dart_jts/edgegraph/half_edge.dart';
part 'src/com/hydrologis/dart_jts/edgegraph/edge_graph.dart';
part 'src/com/hydrologis/dart_jts/edgegraph/edge_graph_builder.dart';
part 'src/com/hydrologis/dart_jts/edgegraph/mark_half_edge.dart';
part 'src/com/hydrologis/dart_jts/operation/linemerge/line_merge_graph.dart';
part 'src/com/hydrologis/dart_jts/operation/linemerge/edge_string.dart';
part 'src/com/hydrologis/dart_jts/operation/linemerge/line_merge_directed_edge.dart';
part 'src/com/hydrologis/dart_jts/operation/linemerge/line_merger.dart';
part 'src/com/hydrologis/dart_jts/operation/linemerge/line_merge_edge.dart';
part 'src/com/hydrologis/dart_jts/planargraph/directed_edge.dart';
part 'src/com/hydrologis/dart_jts/planargraph/edge.dart';
part 'src/com/hydrologis/dart_jts/planargraph/graph_component.dart';
part 'src/com/hydrologis/dart_jts/planargraph/node.dart';
part 'src/com/hydrologis/dart_jts/planargraph/directerd_edge_star.dart';
part 'src/com/hydrologis/dart_jts/planargraph/planar_graph.dart';
part 'src/com/hydrologis/dart_jts/planargraph/node_map.dart';
part 'src/com/hydrologis/dart_jts/noding/noding.dart';
part 'src/com/hydrologis/dart_jts/noding/fast_noding_validator.dart';
part 'src/com/hydrologis/dart_jts/noding/noding_intersection_finder.dart';
part 'src/com/hydrologis/dart_jts/noding/snap_round.dart';
part 'src/com/hydrologis/dart_jts/noding/segment_intersector_detector.dart';
part 'src/com/hydrologis/dart_jts/noding/fast_segment_set_intersection_finder.dart';
part 'src/com/hydrologis/dart_jts/noding/mc_index_segement_set_mutual_intersector.dart';
part 'src/com/hydrologis/dart_jts/noding/snap/snapping_noder.dart';
part 'src/com/hydrologis/dart_jts/noding/snap/snapping_point_index.dart';
part 'src/com/hydrologis/dart_jts/noding/snap/snapping_intersection_adder.dart';
part 'src/com/hydrologis/dart_jts/math/math.dart';
part 'src/com/hydrologis/dart_jts/geomgraph/geomgraph.dart';
part 'src/com/hydrologis/dart_jts/geomgraph/index.dart';
part 'src/com/hydrologis/dart_jts/util.dart';
part 'src/com/hydrologis/dart_jts/geom/geometry.dart';
part 'src/com/hydrologis/dart_jts/geom/point.dart';
part 'src/com/hydrologis/dart_jts/geom/geometry_collection.dart';
part 'src/com/hydrologis/dart_jts/geom/multipoint.dart';
part 'src/com/hydrologis/dart_jts/geom/linestring.dart';
part 'src/com/hydrologis/dart_jts/geom/multilinestring.dart';
part 'src/com/hydrologis/dart_jts/geom/polygon.dart';
part 'src/com/hydrologis/dart_jts/geom/multipolygon.dart';
part 'src/com/hydrologis/dart_jts/util/geom_impl.dart';
part 'src/com/hydrologis/dart_jts/util/util.dart';
part 'src/com/hydrologis/dart_jts/index/index.dart';
part 'src/com/hydrologis/dart_jts/index/chain.dart';
part 'src/com/hydrologis/dart_jts/index/strtree.dart';
part 'src/com/hydrologis/dart_jts/index/quadtree.dart';
part 'src/com/hydrologis/dart_jts/index/kdtree.dart';
part 'src/com/hydrologis/dart_jts/util/avltree.dart';
part 'src/com/hydrologis/dart_jts/extra.dart';
part 'src/com/hydrologis/dart_jts/addons/geodesy.dart';
part 'src/com/hydrologis/dart_jts/geom/affinetransformation.dart';
part 'src/com/hydrologis/dart_jts/linearref/lengthindexedline.dart';
part 'src/com/hydrologis/dart_jts/linearref/linearlocation.dart';
part 'src/com/hydrologis/dart_jts/linearref/lengthlocationmap.dart';
part 'src/com/hydrologis/dart_jts/linearref/lineariterator.dart';
part 'src/com/hydrologis/dart_jts/linearref/extractlinebylocation.dart';
part 'src/com/hydrologis/dart_jts/linearref/lineargeometrybuilder.dart';
part 'src/com/hydrologis/dart_jts/linearref/lengthindexofpoint.dart';
part 'src/com/hydrologis/dart_jts/linearref/locationindexofline.dart';
part 'src/com/hydrologis/dart_jts/linearref/locationindexofpoint.dart';
part 'src/com/hydrologis/dart_jts/linearref/locationindexedline.dart';
part 'src/com/hydrologis/dart_jts/simplify/douglas_peucker_simplifier.dart';
part 'src/com/hydrologis/dart_jts/simplify/douglas_peucker_line_simplifier.dart';
part 'src/com/hydrologis/dart_jts/simplify/topology_preserving_simplifier.dart';
part 'src/com/hydrologis/dart_jts/simplify/tagged_line_string.dart';
part 'src/com/hydrologis/dart_jts/simplify/tagged_line_segment.dart';
part 'src/com/hydrologis/dart_jts/simplify/tagged_lines_simplifier.dart';
part 'src/com/hydrologis/dart_jts/simplify/line_segment_index.dart';
part 'src/com/hydrologis/dart_jts/simplify/tagged_line_string_simplifier.dart';
part 'src/com/hydrologis/dart_jts/simplify/vw_simplifier.dart';
part 'src/com/hydrologis/dart_jts/simplify/vw_line_simplifier.dart';
part 'src/com/hydrologis/dart_jts/precision/geometry_precision_reducer.dart';
part 'src/com/hydrologis/dart_jts/precision/pointwise_precision_reducer_transformer.dart';
part 'src/com/hydrologis/dart_jts/precision/precision_reducer_transformer.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/overlay_ng.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/overlay_ng_robust.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/intersection_point_builder.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/overlay_edge_ring.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/overlay_edge.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/overlay_mixed_points.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/indexed_point_on_line_locator.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/input_geometry.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/overlay_util.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/elevation_model.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/overlay_label.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/overlay_graph.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/overlay_points.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/line_builder_ng.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/edge_noding_builder.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/ring_clipper.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/line_limiter.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/edge_source_info.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/edge_merger.dart';
part 'src/com/hydrologis/dart_jts/operation/overlayng/maximal_edge_ring_ng.dart';