import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../../core/constants/layout_breakpoints.dart';
import '../constants/dashboard_constants.dart';
import '../models/dashboard_nav_item.dart';

class DashboardShell extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final List<DashboardNavItem> navigationItems;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool autoCenterBottomNav;
  final Duration bottomNavAnimationDuration;
  final Curve bottomNavAnimationCurve;

  const DashboardShell({
    super.key,
    this.appBar,
    required this.body,
    required this.navigationItems,
    required this.selectedIndex,
    required this.onItemSelected,
    this.autoCenterBottomNav = true,
    this.bottomNavAnimationDuration = DashboardConstants.bottomNavAnimationDuration,
    this.bottomNavAnimationCurve = DashboardConstants.bottomNavAnimationCurve,
  });

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  late final ScrollController _bottomNavController;
  late List<GlobalKey> _tileKeys;

  @override
  void initState() {
    super.initState();
    _bottomNavController = ScrollController();
    _initTileKeys();
  }

  void _initTileKeys() {
    _tileKeys = List.generate(widget.navigationItems.length, (_) => GlobalKey());
  }

  @override
  void didUpdateWidget(covariant DashboardShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navigationItems.length != widget.navigationItems.length) {
      _initTileKeys();
    }
  }

  @override
  void dispose() {
    _bottomNavController.dispose();
    super.dispose();
  }

  void _handleSelect(BuildContext context, int index) {
    final item = widget.navigationItems[index];

    if (!item.isEnabled) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text('${'feature_coming_soon'.tr()}: ${item.labelKey.tr()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    widget.onItemSelected(index);

    // center the tapped tile in the scroll view if feature enabled
    if (widget.autoCenterBottomNav && index >= 0 && index < _tileKeys.length) {
      final key = _tileKeys[index];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final tileContext = key.currentContext;
        if (tileContext == null) return;
        final scrollableState = Scrollable.maybeOf(tileContext);
        if (scrollableState == null) return;

        Scrollable.ensureVisible(
          tileContext,
          duration: widget.bottomNavAnimationDuration,
          curve: widget.bottomNavAnimationCurve,
          alignment: 0.5,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final orientation = media.orientation;

    final isMobile = width < LayoutBreakpoints.mobileMaxWidth;
    final isTablet =
        width >= LayoutBreakpoints.mobileMaxWidth && width < LayoutBreakpoints.desktopMinWidth;

    final isCompactLandscape =
        orientation == Orientation.landscape &&
        width < LayoutBreakpoints.compactLandscapeMaxWidth &&
        height < LayoutBreakpoints.compactLandscapeMaxHeight;

    final isPortraitTablet = isTablet && orientation == Orientation.portrait;

    final useBottomNav = isMobile || isPortraitTablet || isCompactLandscape;

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: widget.appBar,
      bottomNavigationBar: useBottomNav
          ? _buildBottomNavigationBar(context, isCompactLandscape)
          : null,
      body: useBottomNav
          ? widget.body
          : Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DesktopNavigationRail(
                  items: widget.navigationItems,
                  selectedIndex: widget.selectedIndex,
                  onSelect: (i) => _handleSelect(context, i),
                ),
                Expanded(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 16, bottom: 16),
                      child: widget.body,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, bool compact) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: DashboardConstants.bottomNavOuterPaddingEdgeInsets,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DashboardConstants.bottomNavBorderRadius),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(DashboardConstants.bottomNavBorderRadius),
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [color.surface, color.surfaceContainerLowest],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: DashboardConstants.bottomNavShadowOpacity),
                  blurRadius: DashboardConstants.bottomNavShadowBlurRadius,
                  offset: const Offset(0, DashboardConstants.bottomNavShadowOffsetY),
                ),
              ],
              border: Border.all(
                color: color.outlineVariant.withValues(
                  alpha: DashboardConstants.outlineVariantBorderOpacity,
                ),
              ),
            ),
            child: SingleChildScrollView(
              controller: _bottomNavController,
              scrollDirection: Axis.horizontal,
              physics: DashboardConstants.bottomNavScrollPhysics,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: DashboardConstants.bottomNavHorizontalPadding,
                vertical: DashboardConstants.bottomNavVerticalPadding,
              ),
              child: Row(
                children: [
                  for (int i = 0; i < widget.navigationItems.length; i++) ...[
                    Container(
                      key: _tileKeys[i],
                      child: _BottomNavigationTile(
                        item: widget.navigationItems[i],
                        selected: i == widget.selectedIndex,
                        onTap: () => _handleSelect(context, i),
                        compact: compact,
                      ),
                    ),
                    if (i != widget.navigationItems.length - 1)
                      const SizedBox(width: DashboardConstants.bottomNavTileSpacing),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= SIDEBAR =================

class _DesktopNavigationRail extends StatelessWidget {
  final List<DashboardNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _DesktopNavigationRail({
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  static const double minWidth = DashboardConstants.railMinWidth;
  static const double maxWidth = DashboardConstants.railMaxWidth;

  double _calculateWidth(BuildContext context) {
    final theme = Theme.of(context);

    double maxText = 0;

    for (final item in items) {
      final painter = TextPainter(
        text: TextSpan(text: item.labelKey.tr(), style: theme.textTheme.titleSmall),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();

      if (painter.width > maxText) {
        maxText = painter.width;
      }
    }

    final calculated = maxText + 36 + 12 + 16 + 16 + 20;

    final screenWidth = MediaQuery.of(context).size.width;

    return calculated.clamp(minWidth, screenWidth * 0.28).clamp(minWidth, maxWidth);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final width = _calculateWidth(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      child: Material(
        color: color.surface,
        child: SizedBox.expand(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: DashboardConstants.railScrollPhysics,
                  padding: DashboardConstants.railNavigationPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < items.length; i++) ...[
                        _RailNavigationTile(
                          item: items[i],
                          selected: i == selectedIndex,
                          onTap: () => onSelect(i),
                        ),
                        if (items[i].showDividerAfter && i != items.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: DashboardConstants.railDividerVerticalSpace,
                            ),
                            child: Divider(
                              color: color.outlineVariant.withValues(
                                alpha: DashboardConstants.outlineVariantBorderOpacity,
                              ),
                            ),
                          ),
                        if (i != items.length - 1 && !items[i].showDividerAfter)
                          const SizedBox(height: DashboardConstants.railTileSpacing),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= RAIL TILE =================

class _RailNavigationTile extends StatefulWidget {
  final DashboardNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _RailNavigationTile({required this.item, required this.selected, required this.onTap});

  @override
  State<_RailNavigationTile> createState() => _RailNavigationTileState();
}

class _RailNavigationTileState extends State<_RailNavigationTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    final enabled = widget.item.isEnabled;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? DashboardConstants.railTileHoverScale : 1.0,
        duration: DashboardConstants.railTileHoverDuration,
        curve: DashboardConstants.railTileAnimationCurve,
        child: AnimatedContainer(
          duration: DashboardConstants.railTileAnimationDuration,
          curve: DashboardConstants.railTileAnimationCurve,
          margin: const EdgeInsets.symmetric(vertical: DashboardConstants.railTileVerticalMargin),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DashboardConstants.railTileBorderRadius),
            boxShadow: _hover || widget.selected
                ? [
                    BoxShadow(
                      color: color.primary.withValues(
                        alpha: DashboardConstants.railTileShadowOpacity,
                      ),
                      blurRadius: DashboardConstants.railTileShadowBlurRadius,
                      offset: const Offset(0, DashboardConstants.railTileShadowOffsetY),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled ? widget.onTap : null,
              borderRadius: BorderRadius.circular(DashboardConstants.railTileBorderRadius),
              splashColor: color.primary.withValues(
                alpha: DashboardConstants.railTileSelectedBackgroundOpacity,
              ),
              highlightColor: Colors.transparent,
              child: Stack(
                children: [
                  AnimatedPositionedDirectional(
                    duration: DashboardConstants.railTileSelectionIndicatorDuration,
                    curve: DashboardConstants.railTileAnimationCurve,
                    start: widget.selected ? 0 : -6,
                    top: 6,
                    bottom: 6,
                    child: AnimatedOpacity(
                      duration: DashboardConstants.railTileAnimationDuration,
                      opacity: widget.selected ? 1 : 0,
                      child: Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: color.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: DashboardConstants.railTileAnimationDuration,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: widget.selected
                          ? color.primary.withValues(
                              alpha: DashboardConstants.railTileSelectedBackgroundOpacity,
                            )
                          : _hover
                          ? color.primary.withValues(
                              alpha: DashboardConstants.railTileHoverBackgroundOpacity,
                            )
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(DashboardConstants.railTileBorderRadius),
                      border: Border.all(
                        color: widget.selected
                            ? color.primary.withValues(
                                alpha: DashboardConstants.railTileSelectedBorderOpacity,
                              )
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: DashboardConstants.railTileAnimationDuration,
                          width: DashboardConstants.railIconContainerSize,
                          height: DashboardConstants.railIconContainerSize,
                          decoration: BoxDecoration(
                            color: widget.selected
                                ? color.primary
                                : color.surfaceContainerHighest.withValues(
                                    alpha: DashboardConstants.railIconContainerBackgroundOpacity,
                                  ),
                            borderRadius: BorderRadius.circular(
                              DashboardConstants.railTileIconBorderRadius,
                            ),
                          ),
                          child: AnimatedSwitcher(
                            duration: DashboardConstants.railTileAnimationDuration,
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                            child: Icon(
                              widget.selected ? widget.item.selectedIcon : widget.item.icon,
                              key: ValueKey(widget.selected),
                              size: DashboardConstants.railIconInnerSize,
                              color: widget.selected ? color.onPrimary : color.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AnimatedDefaultTextStyle(
                            duration: DashboardConstants.railTileAnimationDuration,
                            style: theme.textTheme.titleSmall!.copyWith(
                              color: widget.selected ? color.primary : color.onSurface,
                              fontWeight: widget.selected ? FontWeight.w800 : FontWeight.w500,
                            ),
                            child: Text(
                              widget.item.labelKey.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        if (!widget.item.isEnabled)
                          Icon(
                            Icons.lock_outline,
                            size: 16,
                            color: color.onSurfaceVariant.withValues(
                              alpha: DashboardConstants.disabledIconOpacity,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= BOTTOM NAV =================

class _BottomNavigationTile extends StatelessWidget {
  final DashboardNavItem item;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  const _BottomNavigationTile({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DashboardConstants.bottomNavTileBorderRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DashboardConstants.bottomNavTilePaddingHorizontal,
          vertical: DashboardConstants.bottomNavTilePaddingVertical,
        ),
        child: AnimatedContainer(
          duration: DashboardConstants.bottomTileAnimationDuration,
          curve: DashboardConstants.railTileAnimationCurve,
          padding: EdgeInsets.symmetric(
            horizontal: selected ? 18 : 12,
            vertical: selected ? 12 : 10,
          ),
          decoration: BoxDecoration(
            color: selected
                ? color.primary.withValues(
                    alpha: DashboardConstants.bottomNavTileSelectedBackgroundOpacity,
                  )
                : Colors.transparent,
            borderRadius: BorderRadius.circular(DashboardConstants.bottomNavTileBorderRadius),
            border: Border.all(
              color: selected
                  ? color.primary.withValues(
                      alpha: DashboardConstants.bottomNavTileSelectedBorderOpacity,
                    )
                  : Colors.transparent,
            ),
          ),
          child: AnimatedScale(
            scale: selected ? DashboardConstants.bottomTileSelectedScale : 1.0,
            duration: DashboardConstants.bottomTileScaleDuration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      selected ? item.selectedIcon : item.icon,
                      color: selected ? color.primary : color.onSurfaceVariant,
                      size: selected
                          ? DashboardConstants.bottomNavIconSizeSelected
                          : DashboardConstants.bottomNavIconSize,
                    ),
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: selected
                            ? DashboardConstants.bottomNavTileTextMaxWidthSelected
                            : DashboardConstants.bottomNavTileTextMaxWidthUnselected,
                      ),
                      child: Text(
                        item.labelKey.tr(),
                        style: TextStyle(
                          color: selected ? color.primary : color.onSurfaceVariant,
                          fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: DashboardConstants.railTileAnimationDuration,
                  height: DashboardConstants.bottomNavIndicatorHeight,
                  width: selected ? DashboardConstants.bottomNavIndicatorSelectedWidth : 0,
                  decoration: BoxDecoration(
                    color: color.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
