import 'package:flutter/material.dart';
import '../helpers/responsive_helper.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final Widget? sideMenu;
  final String title;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.sideMenu,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isMobile ? AppBar(title: Text(title)) : null,
      drawer: context.isMobile ? Drawer(child: sideMenu) : null,
      body: Row(
        children: [
          if (context.isTablet || context.isDesktop)
            Container(
              width: 250,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: sideMenu ?? const Center(child: Text("Side Menu")),
            ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
