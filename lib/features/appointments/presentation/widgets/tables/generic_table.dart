import 'package:flutter/material.dart';

// --- Table Column Model ---

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

// --- Table Layout Config ---

enum TableDeviceType { mobile, tablet, desktop }

class TableLayoutConfig {
  final TableDeviceType type;
  final double spacing;
  final bool isMobile;
  final bool isTablet;

  const TableLayoutConfig({
    required this.type,
    required this.spacing,
    required this.isMobile,
    required this.isTablet,
  });

  factory TableLayoutConfig.fromWidth(double width) {
    if (width < 600) {
      return TableLayoutConfig(
        type: TableDeviceType.mobile,
        spacing: width * 0.04,
        isMobile: true,
        isTablet: false,
      );
    } else if (width < 1100) {
      return TableLayoutConfig(
        type: TableDeviceType.tablet,
        spacing: width * 0.03,
        isMobile: false,
        isTablet: true,
      );
    } else {
      return TableLayoutConfig(
        type: TableDeviceType.desktop,
        spacing: width * 0.02,
        isMobile: false,
        isTablet: false,
      );
    }
  }
}

// --- Generic Table Shell ---

/// Generic responsive table shell.
///
/// Renders DataTable on wide screens and card-based rows on mobile.
class GenericTableShell<T> extends StatefulWidget {
  final List<T> data;
  final List<TableColumn<T>> columns;
  final bool isLoading;
  final VoidCallback? onLoadMore;

  const GenericTableShell({
    super.key,
    required this.data,
    required this.columns,
    required this.isLoading,
    this.onLoadMore,
  });

  @override
  State<GenericTableShell<T>> createState() => _GenericTableShellState<T>();
}

class _GenericTableShellState<T> extends State<GenericTableShell<T>> {
  late List<T> _displayData;

  int? sortColumnIndex;
  bool ascending = true;
  bool _hasRequestedLoadMore = false;

  final ScrollController _verticalScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _displayData = [...widget.data];
    _verticalScroll.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (widget.onLoadMore == null) return;
    if (widget.isLoading) return;
    if (_hasRequestedLoadMore) return;
    if (!_verticalScroll.hasClients) return;

    final pos = _verticalScroll.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _hasRequestedLoadMore = true;
      widget.onLoadMore!.call();
    }
  }

  @override
  void didUpdateWidget(covariant GenericTableShell<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data != widget.data || oldWidget.data.length != widget.data.length) {
      _displayData = [...widget.data];
      sortColumnIndex = null;
    }

    if (oldWidget.isLoading && !widget.isLoading) {
      _hasRequestedLoadMore = false;
    }

    if (widget.data.length > oldWidget.data.length) {
      _hasRequestedLoadMore = false;
    }
  }

  @override
  void dispose() {
    _verticalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final config = TableLayoutConfig.fromWidth(constraints.maxWidth);

        // Hide mobile-optional columns when card layout is active.
        final visibleColumns = widget.columns.where((c) {
          if (!config.isMobile) return true;
          return !c.hideOnMobile;
        }).toList();

        if (config.isMobile) {
          return _buildCards(visibleColumns);
        }

        return _buildTable(visibleColumns, constraints.maxWidth, config.spacing);
      },
    );
  }

  /// Builds desktop/tablet DataTable with horizontal scrolling support.
  Widget _buildTable(List<TableColumn<T>> cols, double maxWidth, double spacing) {
    final theme = Theme.of(context);
    final compactColumnWidth = maxWidth < 900 ? 140.0 : 160.0;
    final rowHeight = maxWidth < 900 ? 52.0 : 48.0;

    final totalWidth = cols.fold<double>(0, (sum, c) => sum + (c.width ?? compactColumnWidth));

    final table = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: maxWidth > totalWidth ? maxWidth : totalWidth),
        child: DataTable(
          columnSpacing: spacing,
          dividerThickness: 0.2,
          headingRowHeight: rowHeight,
          dataRowMinHeight: rowHeight,
          dataRowMaxHeight: rowHeight + 8,
          headingRowColor: WidgetStateProperty.all(
            theme.colorScheme.primary.withValues(alpha: 0.12),
          ),
          sortColumnIndex: sortColumnIndex,
          sortAscending: ascending,
          columns: cols.asMap().entries.map((entry) {
            final col = entry.value;

            final colWidth = col.width ?? compactColumnWidth;

            return DataColumn(
              label: SizedBox(
                width: colWidth,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      col.label,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              onSort: col.sortable ? (i, asc) => _sort(i, asc, col) : null,
            );
          }).toList(),
          rows: _displayData.map((item) {
            return DataRow(
              cells: cols.map((col) {
                final colWidth = col.width ?? 150;

                return DataCell(
                  SizedBox(
                    width: colWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Align(alignment: Alignment.centerLeft, child: col.cell(item)),
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: theme.copyWith(dividerColor: theme.colorScheme.primary.withValues(alpha: 0.15)),
        child: widget.onLoadMore == null
            ? table
            : SingleChildScrollView(
                controller: _verticalScroll,
                scrollDirection: Axis.vertical,
                child: table,
              ),
      ),
    );
  }

  /// Builds mobile card rows where the last column is treated as action area.
  Widget _buildCards(List<TableColumn<T>> cols) {
    final theme = Theme.of(context);

    if (_displayData.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No data available',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        const double cardHorizontalPadding = 16.0;
        const double cardVerticalMargin = 6.0;

        // Separate columns: main data (all but last) vs actions (last column).
        final mainCols = cols.length > 1 ? cols.sublist(0, cols.length - 1) : cols;
        final actionCol = cols.isNotEmpty ? cols.last : null;

        return Column(
          children: _displayData.map((item) {
            return Container(
              width: availableWidth,
              margin: const EdgeInsets.symmetric(vertical: cardVerticalMargin),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: cardHorizontalPadding,
                  vertical: 14,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Main Data (Name, Time, Status, etc.)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: mainCols.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final col = entry.value;
                          final isLast = idx == mainCols.length - 1;

                          return Padding(
                            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                            child: DefaultTextStyle(
                              style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
                              child: col.cell(item),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // Flexible Space
                    const SizedBox(width: 16),
                    // Right Column: Actions (Vertical)
                    if (actionCol != null)
                      DefaultTextStyle(
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        child: actionCol.cell(item),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  /// Applies in-place sorting for the active column.
  void _sort(int index, bool asc, TableColumn<T> col) {
    if (col.sortValue == null) return;

    setState(() {
      sortColumnIndex = index;
      ascending = asc;

      _displayData.sort((a, b) {
        final v1 = col.sortValue!(a);
        final v2 = col.sortValue!(b);

        return asc ? Comparable.compare(v1, v2) : Comparable.compare(v2, v1);
      });
    });

    // End sort mutation for current table data.
  }
}
