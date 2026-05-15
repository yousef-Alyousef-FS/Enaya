import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/inputs/search_field.dart';

class AppointmentSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback? onClear;
  final String? hintText;

  const AppointmentSearchBar({super.key, required this.onSearch, this.onClear, this.hintText});

  @override
  State<AppointmentSearchBar> createState() => _AppointmentSearchBarState();
}

class _AppointmentSearchBarState extends State<AppointmentSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _clearSearch() {
    _controller.clear();
    if (widget.onClear != null) {
      widget.onClear!.call();
    } else {
      widget.onSearch('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AppSearchField(
        controller: _controller,
        onChanged: widget.onSearch,
        hint: widget.hintText ?? 'search_patient_or_appointment'.tr(),
        onClear: _clearSearch,
        height: 57,
      ),
    );
  }
}
