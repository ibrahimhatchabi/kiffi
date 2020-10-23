import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:kiffi/teaser_items.dart';

class ItemFadeOut extends StatelessWidget {

  final double revealPercent;
  final SlideDirection slideDirection;
  final Widget child;

  ItemFadeOut({
    this.revealPercent,
    this.child,
    this.slideDirection,
  });

  @override
  Widget build(BuildContext context) {
    /*return new ClipOval(
      clipper: new CircleRevealClipper(revealPercent),
      child: child,
    );*/

    return new Transform(
      transform: slideDirection == SlideDirection.rightToLeft
          ? new Matrix4.translationValues(
          -400.0 * (revealPercent),
          50.0 * (revealPercent),
          0.0
      )
          : new Matrix4.translationValues(
          400.0 * (revealPercent),
          50.0 * (revealPercent),
          0.0
      ),
      child: child,
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect>{

  final double revealPercent;

  CircleRevealClipper(
      this.revealPercent,
      );

  @override
  Rect getClip(Size size) {
    final epicenter = new Offset(size.width / 2, size.height * 0.9);

    // Calculate the distance from the epicenter to the top left corner to make sure we fill the screen
    double theta = atan(epicenter.dy / epicenter.dx);
    final distanceToCorner = epicenter.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;
    final diameter = 2* radius;

    return new Rect.fromLTWH(epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
