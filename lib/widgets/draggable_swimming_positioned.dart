import 'package:tsuratan/widgets/swimming_positioned.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:tsuratan/pages/trophy_page.dart';

class DraggableSwimmingPositioned extends StatefulWidget {
  final double x;
  final double y;
  final double velocityX;
  final double velocityY;
  final Stream<bool> arrangeStream;

  final Widget child;

  final AnimationController controller;

  final GlobalKey<ScaffoldState>? scaffoldKey;

  DraggableSwimmingPositioned(
      {Key? key,
      required this.child,
      required this.controller,
      this.x = 0,
      this.y = 0,
      this.velocityX = 0,
      this.velocityY = 0,
      required this.arrangeStream,
      this.scaffoldKey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DraggableSwimmingPositionedState();
}

class _DraggableSwimmingPositionedState
    extends State<DraggableSwimmingPositioned> {
  double x = 0, y = 0;
  late PolarCoordinates velocityPolar;
  late Function listener;
  BuildContext? appContext;

  @override
  void initState() {
    super.initState();

    x = widget.x;
    y = widget.y;

    velocityPolar =
        rect2Polar(RectCoordinates(widget.velocityX, widget.velocityY));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget.arrangeStream.listen((shouldArrange) {
      if (shouldArrange) {
        x = widget.x;
        y = widget.y;
        velocityPolar =
            PolarCoordinates(velocityPolar.r * 0.1, velocityPolar.theta);
      }
    });

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
        } else if (velocityPolar.r == 0) {
          velocityPolar.r = 0.01;
        } else if (velocityPolar.r < 0.5) {
          velocityPolar.r *= 1.01;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Draggable(
        feedback: Material(child: widget.child),
        child: Container(padding: EdgeInsets.all(3.0), child: widget.child),
        childWhenDragging: Container(),
        onDragEnd: (DraggableDetails detail) {
          print(
              "offset: ${detail.offset}, velocity: ${detail.velocity.pixelsPerSecond}");
          setState(() {
            x = detail.offset.dx;
            y = detail.offset.dy;
            velocityPolar = rect2Polar(RectCoordinates(
                detail.velocity.pixelsPerSecond.dx / 100,
                detail.velocity.pixelsPerSecond.dy / 100));
          });
          trophy();
        },
      ),
    );
  }

  void trophy() async {
    // TODO: implement
    // if (!(await isAchieved(7))) {
    //   setAchieved(7);

    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text("獲得: ${trophies[7].title}"),
    //   ));
    // }
  }
}
