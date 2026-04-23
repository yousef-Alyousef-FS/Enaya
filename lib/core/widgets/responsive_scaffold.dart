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
    final theme = Theme.of(context);
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
  //final isDesktop = context.isDesktop;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
        title: Text(title),
        elevation: 0,
      )
          : null,

      drawer: isMobile
          ? Drawer(
        child: SafeArea(
          child: sideMenu ?? const Center(child: Text("Side Menu")),
        ),
      )
          : null,

      body: SafeArea(
        child: Row(
          children: [
            // -----------------------------------------------------------------
            // 🧭 SIDE MENU (Tablet + Desktop)
            // -----------------------------------------------------------------
            if (!isMobile)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isTablet ? 220 : 260,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    right: BorderSide(
                      color: theme.dividerColor.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                ),
                child: sideMenu ?? const Center(child: Text("Side Menu")),
              ),

            // -----------------------------------------------------------------
            // 📄 MAIN CONTENT
            // -----------------------------------------------------------------
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: body,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
