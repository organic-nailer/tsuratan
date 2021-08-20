import 'dart:math' as math;
import 'package:flutter/material.dart';

class AxisAnimatedPositioned extends AnimatedWidget {
  AxisAnimatedPositioned({
    Key key,
    @required this.axis,
    @required this.child,
  })  : assert(axis != null),
        assert(child != null),
        super(key: key, listenable: axis.getListenable());

  final AxisPair axis;
  final Widget child;

  bool visible = true;

  void toInvisible() {
    visible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Visibility(
        child: child,
        visible: visible,
      ),
      top: axis.y.value,
      left: axis.x.value,
    );
  }
}

class AxisPair {
  Animation<double> x;
  Animation<double> y;

  AxisPair({@required this.x, @required this.y});

  Listenable getListenable() {
    return Listenable.merge([x, y]);
  }
}

class AbsolutePositionTween extends Tween<double> {
  AbsolutePositionTween({double begin, double end})
      : super(begin: begin, end: end);
}

class SinCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(t * math.pi * 2);
  }
}
