# Responsive NavBar!

this package delivers you a navigationBar with animation and much customization!

![--picture comming soon--](http://url/to/img.png)

## Usage

```dart
@override
Widget build(BuildContext context) {
  return Container(
      child: ResponsiveBar(
          barCircularity: 0,
          iconPadding: EdgeInsets.only(bottom: 5, top: 5),
          barThickness: 5,
          usingRightBar: true,
          isForDesktop: true,
          currentIndex: currentIndex,
          onTap: _handleIndexChanged(),
          iconSize: 35,
          scaling: 60,
          iconScaleAnimationFactor: 0.3,
          iconScaleCurve: Curves.decelerate,
          barSizeCurve: Curves.decelerate,
          barAccentColor: FlutterFlowTheme.primaryColor,
          backgroundColor: HexColor("#060606"),
          activeItemColor: HexColor("#F1F1F1"),
          passiveItemColor: HexColor("#444444"),
          items: [
            ResponsiveBarItem(
                icon: Icon(Icons.store_outlined),
                selectedIcon: Icon(Icons.store_rounded)),
            ResponsiveBarItem(
                icon: Icon(Icons.badge_outlined),
                selectedIcon: Icon(Icons.badge_rounded)),
            ResponsiveBarItem(
                icon: Icon(Icons.vpn_key_outlined),
                selectedIcon: Icon(Icons.vpn_key_rounded)),
            ResponsiveBarItem(
                icon: Icon(Icons.source_outlined),
                selectedIcon: Icon(Icons.source_rounded)),
            ResponsiveBarItem(
                icon: Icon(Icons.linear_scale_outlined),
                selectedIcon: Icon(Icons.linear_scale_rounded))
          ]
      )
  );
}
```

