import 'package:flutter/cupertino.dart';

class TableColumn<T> {
  final String label;
  final Widget Function(T item) cell;

  final double? width; // Logical column width in pixels.
  final bool sortable;
  final Comparable Function(T item)? sortValue;
  final bool hideOnMobile;

  const TableColumn({
    required this.label,
    required this.cell,
    this.width,
    this.sortable = false,
    this.sortValue,
    this.hideOnMobile = false,
  });
}
