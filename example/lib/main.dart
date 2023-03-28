// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:responsive_navbar/responsive_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DesktopMain(title: 'Flutter Demo Home Page'),
    );
  }
}

class DesktopMain extends StatefulWidget {
  DesktopMain({super.key, required this.title, this.index = 0});

  final String title;

  late int index;

  @override
  State<DesktopMain> createState() => _DesktopMainState();
}

class _DesktopMainState extends State<DesktopMain> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.index);
    _currentIndex.value = widget.index;
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

//##############################################################################

  void _handleIndexChanged(int index) {
    if (_currentIndex.value != index) {
      pageController
          .jumpToPage(_currentIndex.value < index ? index - 1 : index + 1);
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutQuart);
      _currentIndex.value = index;
    }
  }

//##############################################################################

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF131313),
        child: Row(
          children: [
            ValueListenableBuilder(
              valueListenable: _currentIndex,
              builder: (context, dynamic currentIndex, _) => ResponsiveBar(
                useIconScaleCurve: true,
                barCircularity: 0,
                iconPadding: const EdgeInsets.only(bottom: 25, top: 25),
                barThickness: 5,
                isForDesktop: true,
                currentIndex: currentIndex,
                onTap: (index) => _handleIndexChanged(index),
                iconSize: 35,
                scaling: 60,
                iconScaleAnimationFactor: 0.5,
                iconScaleCurve: Curves.decelerate,
                barSizeCurve: Curves.decelerate,
                barAccentColor: Colors.white,
                backgroundColor: Colors.black45,
                activeItemColor: Colors.white,
                passiveItemColor: Colors.white30,

                transition: const Duration(milliseconds: 400),
                itemsStaked: true,
                usingItemDescription: true,
                tooltipStayDuration: const Duration(milliseconds: 500),
                items: [
                  ResponsiveBarItem(
                      description: "test",
                      icon: const Icon(Icons.store_outlined),
                      selectedIcon: const Icon(Icons.store_rounded)),
                  ResponsiveBarItem(
                      description: "test2",
                      icon: const Icon(Icons.badge_outlined),
                      selectedIcon: const Icon(Icons.badge_rounded)),
                  ResponsiveBarItem(
                      description: "test3",
                      icon: const Icon(Icons.vpn_key_outlined),
                      selectedIcon: const Icon(Icons.vpn_key_rounded)),
                  ResponsiveBarItem(
                      description: "test4",
                      icon: const Icon(Icons.source_outlined),
                      selectedIcon: const Icon(Icons.source_rounded)),
                  ResponsiveBarItem(
                      description: "test5",
                      icon: const Icon(Icons.linear_scale_outlined),
                      selectedIcon: const Icon(Icons.linear_scale_rounded))
                ],
              ),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: pageController,
                onPageChanged: (index) => _currentIndex.value = index,
                children: const <Widget>[
                  Placeholder(),
                  Placeholder(),
                  Placeholder(),
                  Placeholder(),
                  Placeholder(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MobileMain extends StatefulWidget {
  MobileMain({super.key, required this.title, this.index = 0});

  final String title;
  int index = 0;

  @override
  State<MobileMain> createState() => _MobileMainState();
}

class _MobileMainState extends State<MobileMain> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.index);
    _currentIndex.value = widget.index;
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

//##############################################################################

  void _handleIndexChanged(int index) {
    if (_currentIndex.value != index) {
      pageController
          .jumpToPage(_currentIndex.value < index ? index - 1 : index + 1);
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutQuart);
      _currentIndex.value = index;
    }
  }

//##############################################################################

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: const Color(0xFF131313),
      child: Column(
        children: [
          Expanded(
            //################################################################
            //PageView
            //################################################################
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: pageController,
              onPageChanged: (index) => _currentIndex.value = index,
              children: const <Widget>[
                Placeholder(),
                Placeholder(),
                Placeholder(),
                Placeholder(),
                Placeholder(),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _currentIndex,
            builder: (context, dynamic currentIndex, _) => ResponsiveBar(
              useBarAnimation: true,
              iconPadding: const EdgeInsets.all(13),
              usingTopBar: true,
              isForDesktop: false,
              currentIndex: currentIndex,
              onTap: _handleIndexChanged,
              iconSize: 30,
              scaling: 60,
              transition: const Duration(milliseconds: 500),
              iconScaleAnimationFactor: 0.5,
              iconScaleCurve: Curves.easeOutSine,
              barSizeCurve: Curves.decelerate,
              barAccentColor: Colors.white,
              backgroundColor: Colors.black38,
              activeItemColor: Colors.white,
              passiveItemColor: Colors.white38,
              items: [
                //######################################################
                //BarItems
                //######################################################
                ResponsiveBarItem(
                    icon: const Icon(Icons.store_outlined),
                    selectedIcon: const Icon(Icons.store_rounded)),
                ResponsiveBarItem(
                    icon: const Icon(Icons.badge_outlined),
                    selectedIcon: const Icon(Icons.badge_rounded)),
                ResponsiveBarItem(
                    icon: const Icon(Icons.vpn_key_outlined),
                    selectedIcon: const Icon(Icons.vpn_key_rounded)),
                ResponsiveBarItem(
                    icon: const Icon(Icons.source_outlined),
                    selectedIcon: const Icon(Icons.source_rounded)),
                ResponsiveBarItem(
                    icon: const Icon(Icons.linear_scale_outlined),
                    selectedIcon: const Icon(Icons.linear_scale_rounded))
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
