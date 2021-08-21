import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:tsuratan/widgets/draggable_swimming_positioned.dart';

class SwimmingStack extends StatefulWidget {
  final List<Widget> children;
  final Stream<bool> arrangeStream;
  final GlobalKey<ScaffoldState> scaffoldkey;

  SwimmingStack(
      {Key? key,
      required this.children,
      required this.arrangeStream,
      required this.scaffoldkey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SwimmingStackState();
}

class _SwimmingStackState extends State<SwimmingStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  List<DraggableSwimmingPositioned> children = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var placeX = 40.0;
    return Stack(
      children: widget.children.map((w) {
        placeX += 15.0;
        return DraggableSwimmingPositioned(
          child: w,
          controller: _animationController,
          arrangeStream: widget.arrangeStream,
          scaffoldKey: widget.scaffoldkey,
          x: placeX,
          y: 200.0,
          velocityX: (new math.Random()).nextDouble() * 0.1 - 0.05,
          velocityY: (new math.Random()).nextDouble() * 0.1 - 0.05,
        );
      }).toList(),
    );
  }
}

class SwimmingPositioned extends StatefulWidget {
  final double x;
  final double y;
  final double velocityX;
  final double velocityY;
  double? limitX;
  double? limitY;

  Widget child;

  AnimationController controller;

  SwimmingPositioned(
      {Key? key,
      required this.child,
      required this.controller,
      this.x = 0,
      this.y = 0,
      this.velocityX = 0,
      this.velocityY = 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SwimmingPositionState();
}

class SwimmingPositionState extends State<SwimmingPositioned> {
  double x = 0, y = 0;
  late PolarCoordinates velocityPolar;
  @override
  void initState() {
    super.initState();

    x = widget.x;
    y = widget.y;

    velocityPolar =
        rect2Polar(RectCoordinates(widget.velocityX, widget.velocityY));

    widget.controller.addListener(() {
      var limitX = MediaQuery.of(context).size.width;
      var limitY = MediaQuery.of(context).size.height;

      setState(() {
        final rect = polar2Rect(velocityPolar);
        x += rect.x;
        y += rect.y;

        if (x > limitX) {
          x = 2 * limitX - x;
          velocityPolar.theta = math.pi - velocityPolar.theta; //X軸で向きを反転
        } else if (x < 0) {
          x = -x;
          velocityPolar.theta = math.pi - velocityPolar.theta; //X軸で向きを反転
        }

        if (y > limitY) {
          y = 2 * limitY - y;
          velocityPolar.theta = 2 * math.pi - velocityPolar.theta; //Y軸で向きを反転
        } else if (y < 0) {
          y = -y;
          velocityPolar.theta = 2 * math.pi - velocityPolar.theta; //Y軸で向きを反転
        }

        if (velocityPolar.r > 0.5) {
          velocityPolar.r *= 0.99;
        } else if (velocityPolar.r < 0.5) {
          velocityPolar.r = 0.5;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: widget.child,
    );
  }
}

class PolarCoordinates {
  double r, theta;

  PolarCoordinates(this.r, this.theta) : assert(r >= 0);
}

@immutable
class RectCoordinates {
  final double x, y;
  RectCoordinates(this.x, this.y);
}

PolarCoordinates rect2Polar(RectCoordinates rect) {
  double r = math.sqrt(math.pow(rect.x, 2) + math.pow(rect.y, 2));
  double theta = 0;
  if (rect.x == 0) {
    if (rect.y > 0) {
      theta = 2 / math.pi;
    } else if (rect.y == 0) {
      theta = 0;
    } else {
      theta = -2 / math.pi;
    }
  } else if (rect.x > 0) {
    theta = math.atan(rect.y / rect.x);
  } else {
    theta = math.pi + math.atan(rect.y / rect.x);
  }

  return PolarCoordinates(r, theta);
}

RectCoordinates polar2Rect(PolarCoordinates polar) {
  return RectCoordinates(
      polar.r * math.cos(polar.theta), polar.r * math.sin(polar.theta));
}
