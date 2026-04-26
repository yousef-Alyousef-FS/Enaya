import 'package:flutter/material.dart';

/// A reusable data table wrapper with a consistent appearance for the app.
///
/// This widget provides a standard `DataTable` style across the project,
/// including heading and row colors, spacing, and a built-in empty state.
class CustomDataTable extends StatelessWidget {
  /// Table columns to render.
  final List<DataColumn> columns;

  /// Table rows to render.
  final List<DataRow> rows;

  /// Message shown when the table has no rows.
  final String emptyMessage;

  /// Horizontal spacing between columns.
  final double columnSpacing;

  /// Horizontal margin around the table contents.
  final double horizontalMargin;

  /// Divider thickness between rows.
  final double dividerThickness;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyMessage = 'لا توجد بيانات',
    this.columnSpacing = 32,
    this.horizontalMargin = 24,
    this.dividerThickness = 0.8,
  });

  /// Creates a data table from plain text data.
  ///
  /// Use this constructor when the table content is simple and does not require
  /// custom widgets inside rows.
  factory CustomDataTable.fromTextRows({
    required List<String> columns,
    required List<List<String>> rows,
    String emptyMessage = 'لا توجد بيانات',
  }) {
    return CustomDataTable(
   
      columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
      rows: rows.isEmpty
          ? []
          : rows.map((row) =>
          DataRow(cells: row.map((cell) =>
          DataCell(Text(cell))).toList())).toList(),
      emptyMessage: emptyMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dataRows = rows.isEmpty
        ? [
            DataRow(
              cells: [
                DataCell(
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      emptyMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ...List.generate(columns.length - 1, (_) => const DataCell(Text(''))),
              ],
            ),
          ]
        : rows;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? theme.colorScheme.outline.withOpacity(0.3) : theme.dividerColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(theme.colorScheme.primary.withOpacity(0.08)),
            dataRowColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.hovered)
                  ? theme.colorScheme.primary.withOpacity(0.05)
                  : null,
            ),
            headingTextStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            dataTextStyle: theme.textTheme.bodyMedium,
            columnSpacing: columnSpacing,
            horizontalMargin: horizontalMargin,
            dividerThickness: dividerThickness,
            columns: columns,
            rows: dataRows,
          ),
        ),
      ),
    );
  }
}
