library responsive_navbar;

import 'package:flutter/material.dart';
import 'package:responsive_navbar/align_type.dart';
import 'package:responsive_navbar/badge_text.dart';

///
/// @author bknig99
///
//##############################################################################
class ResponsiveBar extends StatefulWidget {
  final bool usingBottomBar;
  final bool isForDesktop;
  final bool usingTopBar;
  final bool usingLeftBar;
  final bool usingRightBar;

  ///
  ///sets the roundness of the Bars
  ///################################
  ///default is 25
  ///set this param to 0 if you dont
  ///want to have roundness on the Bars
  final double barCircularity;

  ///
  /// sets the thickness of all Bars
  final double barThickness;

  ///
  /// adds Padding to the Icon
  /// ------------------------
  /// very useful in combination
  /// with the borders
  final EdgeInsets iconPadding;

  ///
  ///Color of the Sidebar itself
  final Color backgroundColor;

  ///
  ///Color of the selected Icons && Bars
  final Color activeItemColor;

  ///
  ///Color of the unselected Icons
  final Color passiveItemColor;

  ///
  ///Scaling for Sidebar
  ///--------------------------
  ///Desktop: width for Sidebar
  ///Mobile: height for Sidebar
  ///-------------------------
  final double scaling;

  ///
  ///Animationmultiplier for Icon Animation
  ///-------------------------
  /// Value > 0; && Value < 0.5
  ///-------------------------
  final double iconScaleAnimationFactor;

  ///
  ///List of the SidebarItems
  ///-> Icon, title etc are hold by them
  final List<ResponsiveBarItem> items;

  ///
  /// sets the navigationbutton layout
  /// false equals "expanding items over whole navbar"
  /// ##############################
  /// default = false
  final bool itemsStaked;

  ///
  ///index of the current Page
  final int currentIndex;

  ///
  ///Size for the Icon
  final double iconSize;

  ///
  ///Animation for Icon
  final Curve iconScaleCurve;

  ///
  /// if true, animation for Icons
  /// can be set with [iconScaleCurve] param
  final bool useIconScaleCurve;

  ///
  ///Animation for all activated Bars
  final Curve barSizeCurve;

  ///
  /// if true, animation for Bars
  /// can be set with [barSizeCurve] param
  final bool useBarAnimation;

  ///
  ///Amount of time all the animations will take
  final Duration transition;

  ///
  ///Callback function for pressing one Item
  final Function(int) onTap;

  ///
  ///Accent color for item
  ///-------------------------
  ///This color finishes the animation
  ///by doing color transition to bars
  ///-------------------------
  final Color barAccentColor;

  ///
  /// default is true,
  /// if you wish no Bars, set this to false
  /// ######################################
  /// otherwise, your prefered Color
  /// can be set with [barAccentColor] param
  final bool useBarAccentColor;

  const ResponsiveBar(
      {Key? key,
      required this.isForDesktop,
      this.scaling = 60,
      this.activeItemColor = const Color(0xFFFFFFFF),
      this.passiveItemColor = const Color(0xAAAAAAAA),
      required this.items,
      this.iconScaleAnimationFactor = 0.2,
      required this.onTap,
      this.currentIndex = 0,
      this.iconSize = 24.0,
      this.backgroundColor = Colors.white,
      this.barSizeCurve = Curves.linear,
      required this.iconScaleCurve,
      this.barAccentColor = const Color(0xFFFFFFFF),
      this.transition = const Duration(milliseconds: 750),
      this.usingTopBar = false,
      this.usingBottomBar = false,
      this.usingLeftBar = false,
      this.usingRightBar = false,
      this.iconPadding = EdgeInsets.zero,
      this.barThickness = 4,
      this.barCircularity = 25,
      this.useBarAnimation = false,
      this.useBarAccentColor = true,
      this.useIconScaleCurve = true,
      this.itemsStaked = false})
      : assert(iconScaleAnimationFactor <= 0.5,
            'Scale factor must be smaller than 0.5'),
        assert(
            iconScaleAnimationFactor > 0, 'Scale factor must be bigger than 0'),
        assert(0 <= currentIndex && currentIndex < items.length),
        super(key: key);

  @override
  ResponsiveBarState createState() => ResponsiveBarState();
}

//##############################################################################
//_SideBarState
//##############################################################################
class ResponsiveBarState extends State<ResponsiveBar>
    with TickerProviderStateMixin {
  final ValueNotifier<List<double>> _sizes = ValueNotifier([]);
  late AnimationController _scaleIconController;
  late List<Color> _barColorList;
  late List<BarsOfItem> _barsOfItemList;

  @override
  void initState() {
    super.initState();

    _barsOfItemList = List<BarsOfItem>.generate(widget.items.length, (index) {
      return BarsOfItem(Bar(0, 0), Bar(0, 0), Bar(0, 0), Bar(0, 0));
    });
    _sizes.value = List<double>.generate(widget.items.length, (index) {
      return 0;
    });
    _barColorList = List<Color>.generate(widget.items.length, (index) {
      return widget.activeItemColor;
    });

    //initial animation
    _animateBarWidth(widget.currentIndex, widget.scaling * 0.65);
    _animateBarHeight(widget.currentIndex, 3.5);
    _animateBarColor(widget.currentIndex, widget.barAccentColor);
    _animateIconScale(widget.currentIndex);
  }

  @override
  void dispose() {
    _scaleIconController.dispose();
    super.dispose();
  }

  //############################################################################

  @override
  Widget build(BuildContext context) {
    final scaling = widget.scaling;

    return Material(
      color: widget.backgroundColor,
      child: widget.isForDesktop
          ? desktopContainer(scaling)
          : mobileContainer(scaling),
    );
  }

  Widget desktopContainer(scaling) {
    return SizedBox(
      width: scaling,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: widget.itemsStaked
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: <Widget>[
          for (var i = 0; i < widget.items.length; i++)
            widget.itemsStaked
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.onTap(i);
                    },
                    child: Column(
                      mainAxisAlignment: widget.itemsStaked
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildNavigationItem(i),
                      ],
                    ))
                : Expanded(
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          widget.onTap(i);
                        },
                        child: Column(
                          mainAxisAlignment: widget.itemsStaked
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildNavigationItem(i),
                          ],
                        )),
                  ),
        ],
      ),
    );
  }

  Widget mobileContainer(scaling) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: scaling,
      child: Row(
        crossAxisAlignment: widget.itemsStaked
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: <Widget>[
          for (var i = 0; i < widget.items.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  widget.onTap(i);
                },
                child: Row(
                  mainAxisAlignment: widget.itemsStaked
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildNavigationItem(i),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(int index) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //topBorder
          widget.usingTopBar ? _resolveTopBorder(index) : Container(),

          //leftBorder - Icon - rightBorder
          _buildIcon(index),

          //bottomBorder
          widget.usingBottomBar ? _resolveBottomBorder(index) : Container()
        ]);
  }

  //############################################################################
  //StaticBorder
  //############################################################################

  Widget _resolveStaticBorder(int index, AlignType alignType) {
    return Container(
      height: _barsOfItemList[index].getHeight(alignType),
      width: _barsOfItemList[index].getWidth(alignType),
      decoration: BoxDecoration(
          color: _barColorList[index],
          borderRadius:
              BorderRadius.all(Radius.circular(widget.barCircularity))),
    );
  }

  //############################################################################
  //TopBorder
  //############################################################################
  Widget _resolveTopBorder(int index) {
    return widget.useBarAnimation
        ? AnimatedContainer(
            height: _barsOfItemList[index].getHeight(AlignType.TOP),
            width: _barsOfItemList[index].getWidth(AlignType.TOP),
            duration: widget.transition,
            curve: widget.barSizeCurve,
            decoration: BoxDecoration(
                color: _barColorList[index],
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.barCircularity))),
          )
        : _resolveStaticBorder(index, AlignType.TOP);
  }

  //############################################################################
  //Icon
  //############################################################################
  Widget _buildIcon(int index) {
    return Container(
      padding: EdgeInsets.only(
          top: widget.iconPadding.top, bottom: widget.iconPadding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.usingLeftBar ? _resolveLeftBorder(index) : Container(),
          SizedBox(
            height: widget.iconSize,
            width: widget.iconSize,
            child: CustomPaint(
              child: _CustomNavigationBarTile(
                iconSize: widget.iconSize,
                scale: _sizes.value[index],
                selected: index == widget.currentIndex,
                item: widget.items[index],
                selectedColor: widget.activeItemColor,
                unSelectedColor: widget.passiveItemColor,
              ),
            ),
          ),
          widget.usingRightBar ? _resolveRightBorder(index) : Container()
        ],
      ),
    );
  }

  //############################################################################
  //BottomBorder
  //############################################################################
  Widget _resolveBottomBorder(int index) {
    return widget.useBarAnimation
        ? AnimatedContainer(
            height: _barsOfItemList[index].getHeight(AlignType.BOTTOM),
            width: _barsOfItemList[index].getWidth(AlignType.BOTTOM),
            duration: widget.transition,
            curve: widget.barSizeCurve,
            decoration: BoxDecoration(
                color: _barColorList[index],
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.barCircularity))),
          )
        : _resolveStaticBorder(index, AlignType.BOTTOM);
  }

  //############################################################################
  //LeftBorder
  //############################################################################

  Widget _resolveLeftBorder(int index) {
    return widget.useBarAnimation
        ? AnimatedContainer(
            height: _barsOfItemList[index].getHeight(AlignType.LEFT),
            width: _barsOfItemList[index].getWidth(AlignType.LEFT),
            duration: widget.transition,
            curve: widget.barSizeCurve,
            decoration: BoxDecoration(
                color: _barColorList[index],
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.barCircularity))),
          )
        : Container(
            height: _barsOfItemList[index].getHeight(AlignType.LEFT),
            width: _barsOfItemList[index].getWidth(AlignType.LEFT),
            decoration: BoxDecoration(
                color: _barColorList[index],
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.barCircularity))),
          );
  }

  //############################################################################
  //RightBorder
  //############################################################################

  Widget _resolveRightBorder(int index) {
    return widget.useBarAnimation
        ? AnimatedContainer(
            height: _barsOfItemList[index].getHeight(AlignType.RIGHT),
            width: _barsOfItemList[index].getWidth(AlignType.RIGHT),
            duration: widget.transition,
            curve: widget.barSizeCurve,
            decoration: BoxDecoration(
                color: _barColorList[index],
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.barCircularity))),
          )
        : Container(
            height: _barsOfItemList[index].getHeight(AlignType.RIGHT),
            width: _barsOfItemList[index].getWidth(AlignType.RIGHT),
            decoration: BoxDecoration(
                color: _barColorList[index],
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.barCircularity))),
          );
  }

  //############################################################################
  // start and define all animations
  //############################################################################
  @override
  void didUpdateWidget(ResponsiveBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _animateBarWidth(widget.currentIndex,
          widget.scaling * (widget.isForDesktop ? 0.75 : 0.6));
      _animateBarWidth(oldWidget.currentIndex, 0);
      _animateBarHeight(widget.currentIndex, widget.barThickness);
      _animateBarHeight(oldWidget.currentIndex, 0);
      if (widget.useBarAccentColor) {
        _animateBarColor(widget.currentIndex, widget.barAccentColor);
        _animateBarColor(oldWidget.currentIndex, widget.activeItemColor);
      }
      _animateIconScale(widget.currentIndex);
    }
  }

  //######################################

  _animateBarWidth(int index, double length) {
    _barsOfItemList[index].setAllWidths(length);
  }

  //######################################

  _animateBarHeight(int index, double length) {
    _barsOfItemList[index].setAllHeights(length);
  }

  //######################################

  void _animateBarColor(int index, Color color) {
    _barColorList[index] = color;
  }

  //######################################

  void _animateIconScale(int index) {
    if (widget.useIconScaleCurve) {
      _scaleIconController = AnimationController(
          vsync: this,
          duration:
              Duration(milliseconds: widget.transition.inMilliseconds ~/ 2))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _scaleIconController.reverse();
          }
        });

      CurvedAnimation scaleAnimation = CurvedAnimation(
        parent: _scaleIconController,
        curve: widget.iconScaleCurve,
        reverseCurve: widget.iconScaleCurve.flipped,
      );

      Tween<double>(begin: 0.0, end: 1.0)
          .animate(scaleAnimation)
          .addListener(() {
        _sizes.value[index] =
            scaleAnimation.value * widget.iconScaleAnimationFactor;
      });
      if (widget.currentIndex == widget.currentIndex) {
        _scaleIconController.forward();
      }
    }
  }
}

//##############################################################################
//_CustomNavigationBarTile
//##############################################################################
class _CustomNavigationBarTile extends StatelessWidget {
  final bool selected;
  final ResponsiveBarItem item;
  final Color selectedColor;
  final Color unSelectedColor;
  final double scale;
  final double iconSize;

  //############################################################################

  const _CustomNavigationBarTile(
      {Key? key,
      required this.selected,
      required this.item,
      required this.selectedColor,
      required this.unSelectedColor,
      required this.scale,
      required this.iconSize})
      : super(key: key);

  //############################################################################

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.0 + scale,
      child: Stack(
        children: [
          IconTheme(
            data: IconThemeData(
              color: selected ? selectedColor : unSelectedColor,
              size: iconSize,
            ),
            child: selected ? item.selectedIcon : item.icon,
          ),
          BadgeText(
            show: item.showBadge,
            count: item.badgeCount,
            right: 0.0,
          )
        ],
      ),
    );
  }
}

//##############################################################################
//BarsOfItem (== 4 Bars for 1 Item in ResponsiveBar)
//##############################################################################
class BarsOfItem {
  Bar top;
  Bar bottom;
  Bar left;
  Bar right;

  BarsOfItem(this.top, this.bottom, this.left, this.right);

  // ignore: missing_return
  double getWidth(AlignType alignType) {
    switch (alignType) {
      case AlignType.TOP:
        return top.width;
      case AlignType.BOTTOM:
        return bottom.width;
      case AlignType.LEFT:
        return left.height;
      case AlignType.RIGHT:
        return right.height;
    }
  }

  double getHeight(AlignType alignType) {
    switch (alignType) {
      case AlignType.TOP:
        return top.height;
      case AlignType.BOTTOM:
        return bottom.height;
      case AlignType.LEFT:
        return left.width;
      case AlignType.RIGHT:
        return right.width;
    }
  }

  setAllWidths(double value) {
    top = Bar(value, top.height);
    bottom = Bar(value, bottom.height);
    left = Bar(value, left.width);
    right = Bar(value, right.width);
  }

  setAllHeights(double value) {
    top = Bar(top.width, value);
    bottom = Bar(bottom.width, value);
    left = Bar(left.width, value);
    right = Bar(right.width, value);
  }
}

//##############################################################################
//Bar
//##############################################################################
class Bar {
  double width;
  double height;

  Bar(this.width, this.height);
}

//##############################################################################
//ResponsiveBarItem
//##############################################################################
class ResponsiveBarItem {
  ///
  /// The icon of the item
  /// Typically the icon is of type [Icon]
  ///
  final Widget icon;

  /// An alternative icon displayed when this bottom navigation item is
  /// selected.
  /// ------------------------------------
  /// If this icon is not provided, the bottom navigation bar will display
  /// [icon] in either state.
  final Widget selectedIcon;

  /// Notification badge count
  final int badgeCount;

  /// hide or show badge
  final bool showBadge;

  /// Create a Custom Navigationbar Item
  ///
  /// the [selectedIcon] must not be null
  /// the [icon] must not be null
  ResponsiveBarItem(
      {required this.icon,
      required this.selectedIcon,
      this.badgeCount = 0,
      this.showBadge = false});
}
