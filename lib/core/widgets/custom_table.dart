import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;

  const CustomDataTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? theme.colorScheme.outline.withValues(alpha: 0.3) : theme.dividerColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              theme.colorScheme.primary.withValues(alpha: 0.08),
            ),
            dataRowColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.hovered)
                  ? theme.colorScheme.primary.withValues(alpha: 0.05)
                  : null,
            ),
            headingTextStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            dataTextStyle: theme.textTheme.bodyMedium,
            columnSpacing: 32,
            horizontalMargin: 24,
            dividerThickness: 0.8,
            columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
            rows: rows.isEmpty
                ? [
                    DataRow(
                      cells: [
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "لا توجد بيانات",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ...List.generate(columns.length - 1, (_) => const DataCell(Text(""))),
                      ],
                    ),
                  ]
                : rows
                      .map(
                        (row) => DataRow(cells: row.map((cell) => DataCell(Text(cell))).toList()),
                      )
                      .toList(),
          ),
        ),
      ),
    );
  }
}
