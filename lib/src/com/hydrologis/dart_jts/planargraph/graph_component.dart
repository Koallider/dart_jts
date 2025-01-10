part of dart_jts;

abstract class PlanarGraphComponent {
  bool isMarked = false;
  bool isVisited = false;
  Object? data;

  PlanarGraphComponent();

  void setContext(Object data) {
    this.data = data;
  }

  Object? getContext() => data;

  void setData(Object data) {
    this.data = data;
  }

  Object? getData() => data;

  bool isRemoved();

  static void setVisitedForIterator(Iterator<PlanarGraphComponent> i, bool visited) {
    while (i.moveNext()) {
      PlanarGraphComponent comp = i.current;
      comp.isVisited = visited;
    }
  }

  static void setMarkedForIterator(Iterator<PlanarGraphComponent> i, bool marked) {
    while (i.moveNext()) {
      PlanarGraphComponent comp = i.current;
      comp.isMarked = marked;
    }
  }

  static PlanarGraphComponent? getComponentWithVisitedState(Iterator<PlanarGraphComponent> i, bool visitedState) {
    while (i.moveNext()) {
      PlanarGraphComponent comp = i.current;
      if (comp.isVisited == visitedState) {
        return comp;
      }
    }
    return null;
  }
}