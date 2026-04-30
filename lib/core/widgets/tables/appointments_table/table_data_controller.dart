class TableDataController<T> {
  List<T> sort({
    required List<T> data,
    required Comparable Function(T item) selector,
    required bool ascending,
  }) {
    final sorted = [...data];

    sorted.sort((a, b) {
      final av = selector(a);
      final bv = selector(b);

      return ascending
          ? Comparable.compare(av, bv)
          : Comparable.compare(bv, av);
    });

    return sorted;
  }
}