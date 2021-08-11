library responsive_bar;

import 'package:flutter/material.dart';

///
/// @author Sebastian.König
///
//##############################################################################
class BadgeText extends StatelessWidget {
  //############################################################################
  // counter showed in notification badge
  // set to 0 will hide notification badge
  //############################################################################

  final int count;

  final double right;

  final bool show;

  const BadgeText({
    Key? key,
    required this.count,
    required this.right,
    required this.show,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right,
      top: 0,
      child: show
          ? Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                count > 10 ? '10+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 6,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : Container(),
    );
  }
}
