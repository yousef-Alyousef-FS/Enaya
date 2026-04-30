import 'package:flutter/material.dart';
import 'table_layout_config.dart';
import 'table_column_model.dart';

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
  int? sortColumnIndex;
  bool ascending = true;
  bool _hasRequestedLoadMore = false;

  final ScrollController _verticalScroll = ScrollController();

  @override
  void initState() {
    super.initState();

    _verticalScroll.addListener(() {
      if (widget.onLoadMore == null) return;
      if (widget.isLoading) return;
      if (_hasRequestedLoadMore) return;
      if (!_verticalScroll.hasClients) return;

      final pos = _verticalScroll.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        _hasRequestedLoadMore = true;
        widget.onLoadMore!.call();
      }
    });
  }

  @override
  void didUpdateWidget(covariant GenericTableShell<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

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

  // ---------------------------------------------------------------------------
  // DESKTOP / TABLET TABLE
  // ---------------------------------------------------------------------------

  Widget _buildTable(List<TableColumn<T>> cols, double maxWidth, double spacing) {
    final theme = Theme.of(context);

    final totalWidth = cols.fold<double>(0, (sum, c) => sum + (c.width ?? 150));

    final table = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: maxWidth > totalWidth ? maxWidth : totalWidth),
        child: DataTable(
          columnSpacing: spacing,
          dividerThickness: 0.2,
          headingRowHeight: 56,
          dataRowMinHeight: 48,
          sortColumnIndex: sortColumnIndex,
          sortAscending: ascending,
          headingRowColor: WidgetStateProperty.all(theme.colorScheme.primary.withOpacity(0.12)),
          columns: cols.asMap().entries.map((entry) {
            final index = entry.key;
            final col = entry.value;

            final colWidth = col.width ?? 100;

            return DataColumn(
              label: SizedBox(
                width: colWidth,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        col.label,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (col.sortable)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            ascending ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              onSort: col.sortable ? (i, asc) => _sort(i, asc, col) : null,
            );
          }).toList(),
          rows: widget.data.map((item) {
            return DataRow(
              cells: cols.map((col) {
                final colWidth = col.width ?? 150;

                return DataCell(
                  SizedBox(
                    width: colWidth,
                    child: Align(alignment: Alignment.center, child: col.cell(item)),
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
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: theme.copyWith(dividerColor: theme.colorScheme.primary.withOpacity(0.15)),
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

  // ---------------------------------------------------------------------------
  // MOBILE CARDS
  // ---------------------------------------------------------------------------

  Widget _buildCards(List<TableColumn<T>> cols) {
    final theme = Theme.of(context);

    if (widget.data.isEmpty) {
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
        final double cardHorizontalPadding = 16.0;
        final double cardVerticalMargin = 6.0;

        // Separate columns: main data (all but last) vs actions (last column)
        final mainCols = cols.length > 1 ? cols.sublist(0, cols.length - 1) : cols;
        final actionCol = cols.isNotEmpty ? cols.last : null;

        return Column(
          children: widget.data.map((item) {
            return Container(
              width: availableWidth,
              margin: EdgeInsets.symmetric(vertical: cardVerticalMargin),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
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
                            padding: EdgeInsets.only(
                              bottom: isLast ? 0 : 12,
                            ),
                            child: DefaultTextStyle(
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 14,
                              ),
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
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
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

  // ---------------------------------------------------------------------------
  // SORTING
  // ---------------------------------------------------------------------------

  void _sort(int index, bool asc, TableColumn<T> col) {
    if (col.sortValue == null) return;

    setState(() {
      sortColumnIndex = index;
      ascending = asc;

      widget.data.sort((a, b) {
        final v1 = col.sortValue!(a);
        final v2 = col.sortValue!(b);

        return asc ? Comparable.compare(v1, v2) : Comparable.compare(v2, v1);
      });
    });
  }
}
