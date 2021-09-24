import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsuratan/widgets/axis_animated_positioned.dart';

class FallingCredit extends StatefulWidget {
  final double? startY;
  final double? endY;
  final double? startX;
  final double? fontSize;

  const FallingCredit({Key? key, this.startX, this.startY, this.endY, this.fontSize})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FallingCreditState();
}

class _FallingCreditState extends State<FallingCredit>
    with TickerProviderStateMixin {
  late AnimationController _animationControllerX;
  late AnimationController _animationControllerY;

  late AxisAnimatedPositioned _childPositioned;

  @override
  void initState() {
    super.initState();

    _animationControllerX = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animationControllerY = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    _animationControllerX.repeat();
    _animationControllerY.forward();

    _animationControllerY.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationControllerX.stop();
        _animationControllerY.stop();

        _childPositioned.toInvisible();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _childPositioned = AxisAnimatedPositioned(
      axis: AxisPair(
          x: _animationControllerX.drive(CurveTween(curve: SinCurve())).drive(
              AbsolutePositionTween(
                  begin: widget.startX, end: widget.startX! + 10)),
          y: _animationControllerY
              .drive(CurveTween(curve: Curves.linear))
              .drive(AbsolutePositionTween(
                  begin: widget.startY, end: widget.endY))),
      child: Text(
        "単位" "\n 💩 ",
        style: TextStyle(fontSize: widget.fontSize, color: const Color(0x80FFC107)),
      ),
    );
    return _childPositioned;
  }

  @override
  void dispose() {
    _animationControllerX.dispose();
    _animationControllerY.dispose();
    super.dispose();
  }
}
