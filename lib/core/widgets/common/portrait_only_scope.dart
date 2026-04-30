import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PortraitOnlyScope extends StatefulWidget {
  final Widget child;

  const PortraitOnlyScope({super.key, required this.child});

  @override
  State<PortraitOnlyScope> createState() => _PortraitOnlyScopeState();
}

class _PortraitOnlyScopeState extends State<PortraitOnlyScope> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
