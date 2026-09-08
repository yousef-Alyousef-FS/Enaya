import 'package:flutter/material.dart';

// [ARCH_FLAG]: High-performance responsive table. 
// Optimized to fill full available width on Desktop/Web and show slim cards only on Mobile (< 500px).

class TableColumn<T> {
  final String label;
  final Widget Function(T item) cell;
  final double? width;
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

class GenericTableShell<T> extends StatefulWidget {
  final List<T> data;
  final List<TableColumn<T>> columns;
  final bool isLoading;
  final bool isPageLoading;
  final VoidCallback? onLoadMore;
  final void Function(T item)? onRowTap;
  final void Function(T item)? onRowLongPress;

  const GenericTableShell({
    super.key,
    required this.data,
    required this.columns,
    required this.isLoading,
    this.isPageLoading = false,
    this.onLoadMore,
    this.onRowTap,
    this.onRowLongPress,
  });

  @override
  State<GenericTableShell<T>> createState() => _GenericTableShellState<T>();
}

class _GenericTableShellState<T> extends State<GenericTableShell<T>> {
  late List<T> _displayData;
  int? sortColumnIndex;
  bool ascending = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _displayData = [...widget.data];
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (widget.onLoadMore == null || widget.isLoading || widget.isPageLoading) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      widget.onLoadMore?.call();
    }
  }

  @override
  void didUpdateWidget(covariant GenericTableShell<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _displayData = [...widget.data];
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // [UX_REFINE]: Breakpoint reduced to 500px to ensure tablets/laptops see the table view.
        if (constraints.maxWidth < 500) {
          return _AppMobileCompactList<T>(
            data: _displayData,
            columns: widget.columns,
            onRowTap: widget.onRowTap,
            onRowLongPress: widget.onRowLongPress,
            scrollController: _scrollController,
            isPageLoading: widget.isPageLoading,
          );
        }
        
        return _AppDesktopTable<T>(
          data: _displayData,
          columns: widget.columns,
          onRowTap: widget.onRowTap,
          onRowLongPress: widget.onRowLongPress,
          onSort: _sort,
          sortColumnIndex: sortColumnIndex,
          ascending: ascending,
          scrollController: _scrollController,
          isPageLoading: widget.isPageLoading,
          maxWidth: constraints.maxWidth, // Pass available width
        );
      },
    );
  }

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
  }
}

// --- DESKTOP VIEW ---
class _AppDesktopTable<T> extends StatelessWidget {
  final List<T> data;
  final List<TableColumn<T>> columns;
  final void Function(T item)? onRowTap;
  final void Function(T item)? onRowLongPress;
  final Function(int, bool, TableColumn<T>) onSort;
  final int? sortColumnIndex;
  final bool ascending;
  final ScrollController scrollController;
  final bool isPageLoading;
  final double maxWidth;

  const _AppDesktopTable({
    required this.data,
    required this.columns,
    required this.onRowTap,
    this.onRowLongPress,
    required this.onSort,
    required this.sortColumnIndex,
    required this.ascending,
    required this.scrollController,
    required this.isPageLoading,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          width: double.infinity, // Ensure container takes full width
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal, // Enable horizontal scroll for overflow
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: maxWidth - 2), // [FIX]: Force table to fill container
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(theme.colorScheme.primary.withValues(alpha: 0.04)),
                dataRowMaxHeight: 60,
                dataRowMinHeight: 52,
                columnSpacing: 20, // Reduced base spacing, flex handles the rest
                showCheckboxColumn: false,
                sortColumnIndex: sortColumnIndex,
                sortAscending: ascending,
                columns: columns.map((col) => DataColumn(
                  label: Text(col.label, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                  onSort: col.sortable ? (i, asc) => onSort(i, asc, col) : null,
                )).toList(),
                rows: data.map((item) => DataRow(
                  onLongPress: onRowLongPress != null ? () => onRowLongPress!(item) : null,
                  onSelectChanged: (_) => onRowTap?.call(item),
                  cells: columns.map((col) => DataCell(col.cell(item))).toList(),
                )).toList(),
              ),
            ),
          ),
        ),
        if (isPageLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

// --- MOBILE COMPACT VIEW ---
class _AppMobileCompactList<T> extends StatelessWidget {
  final List<T> data;
  final List<TableColumn<T>> columns;
  final void Function(T item)? onRowTap;
  final void Function(T item)? onRowLongPress;
  final ScrollController scrollController;
  final bool isPageLoading;

  const _AppMobileCompactList({
    required this.data,
    required this.columns,
    required this.onRowTap,
    this.onRowLongPress,
    required this.scrollController,
    required this.isPageLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mainCols = columns.where((c) => !c.hideOnMobile).toList();
    final actionCol = columns.last;

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: data.length + (isPageLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == data.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final item = data[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
          ),
          child: InkWell(
            onTap: () => onRowTap?.call(item),
            onLongPress: () => onRowLongPress?.call(item),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         mainCols[0].cell(item),
                         const SizedBox(height: 4),
                         mainCols[1].cell(item),
                      ],
                    ),
                  ),
                  if (mainCols.length > 2)
                    Expanded(
                      flex: 2,
                      child: Center(child: mainCols[2].cell(item)),
                    ),
                  actionCol.cell(item),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
