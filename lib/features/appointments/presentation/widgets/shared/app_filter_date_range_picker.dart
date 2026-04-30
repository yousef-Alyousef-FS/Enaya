import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppFilterDateRangePicker extends StatefulWidget {
  final DateTime startDate;
  final DateTime? endDate;
  final Function(DateTimeRange) onRangeSelected;
  final String? label;
  final bool allowManualInput;

  const AppFilterDateRangePicker({
    super.key,
    required this.startDate,
    this.endDate,
    required this.onRangeSelected,
    this.label,
    this.allowManualInput = true,
  });

  @override
  State<AppFilterDateRangePicker> createState() => _AppFilterDateRangePickerState();
}

class _AppFilterDateRangePickerState extends State<AppFilterDateRangePicker> {
  late DateTime _startDate;
  late DateTime? _endDate;
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  // تنسيق الإدخال الرقمي
  final DateFormat _inputFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _updateControllers();
  }

  @override
  void didUpdateWidget(covariant AppFilterDateRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startDate != widget.startDate || oldWidget.endDate != widget.endDate) {
      _startDate = widget.startDate;
      _endDate = widget.endDate;
      _updateControllers();
    }
  }

  void _updateControllers() {
    _startController.text = _inputFormat.format(_startDate);
    if (_endDate != null) {
      _endController.text = _inputFormat.format(_endDate!);
    } else {
      _endController.clear();
    }
  }

  Future<void> _selectDate(bool isStart) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : (_endDate ?? _startDate),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      locale: context.locale,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            useMaterial3: true,
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: Colors.white,
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: theme.colorScheme.primary,
              headerForegroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              dayStyle: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.9)),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
          if (_endDate!.isBefore(_startDate)) {
            _endDate = _startDate;
          }
        }
        _updateControllers();
      });
      _notifyRange();
    }
  }

  void _notifyRange() {
    widget.onRangeSelected(DateTimeRange(
      start: _startDate,
      end: _endDate ?? _startDate,
    ));
  }

  void _onManualInput(String text, bool isStart) {
    if (text.length < 10) return;
    try {
      final parsed = _inputFormat.parseStrict(text);
      setState(() {
        if (isStart) {
          _startDate = parsed;
          if (_endDate != null && _endDate!.isBefore(_startDate)) {
            _endDate = null;
            _endController.clear();
          }
        } else {
          _endDate = parsed;
          if (_endDate!.isBefore(_startDate)) {
            _endDate = _startDate;
            _endController.text = _inputFormat.format(_startDate);
          }
        }
      });
      _notifyRange();
    } catch (_) {
      // تجاهل الإدخال غير الصحيح
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRtl = Directionality.of(context) == TextDirection.RTL;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(120), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDateField(
              controller: _startController,
              label: 'from'.tr(),
              onTap: () => _selectDate(true),
              onChanged: widget.allowManualInput ? (val) => _onManualInput(val, true) : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              isRtl ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
              size: 14,
              color: theme.colorScheme.primary.withAlpha(100),
            ),
          ),
          Expanded(
            child: _buildDateField(
              controller: _endController,
              label: 'to'.tr(),
              onTap: () => _selectDate(false),
              onChanged: widget.allowManualInput ? (val) => _onManualInput(val, false) : null,
              hintText: 'DD/MM/YYYY',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
    ValueChanged<String>? onChanged,
    String? hintText,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(200),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit_calendar_rounded, size: 14, color: theme.colorScheme.primary.withAlpha(180)),
              const SizedBox(width: 6),
              Expanded(
                child: onChanged != null
                    ? TextFormField(
                        controller: controller,
                        onChanged: onChanged,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: 0.3,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintText: hintText ?? 'DD/MM/YYYY',
                          hintStyle: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurfaceVariant.withAlpha(80),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                          LengthLimitingTextInputFormatter(10),
                          _DateInputFormatter(),
                        ],
                      )
                    : Text(
                        controller.text.isEmpty ? (hintText ?? '') : controller.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: controller.text.isEmpty ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // السماح بالحذف الطبيعي دون تدخل
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    final text = newValue.text.replaceAll('/', '');
    String formatted = '';

    if (text.length > 8) return oldValue;

    for (int i = 0; i < text.length; i++) {
      formatted += text[i];
      if ((i == 1 || i == 3) && i != text.length - 1) {
        formatted += '/';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
