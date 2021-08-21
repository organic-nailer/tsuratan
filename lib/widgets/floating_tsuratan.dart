import 'package:flutter/material.dart';
import 'package:tsuratan/data/tsuratan_i18n.dart';
import 'package:tsuratan/widgets/axis_animated_positioned.dart';

class FloatingTsuratan extends StatefulWidget {
  final double? startY;
  final double? endY;
  final double? startX;
  final double fontSize;

  FloatingTsuratan(
      {Key? key, this.startX, this.startY, this.endY, this.fontSize = 40.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FloatingTsuratanState();
}

class _FloatingTsuratanState extends State<FloatingTsuratan>
    with TickerProviderStateMixin {
  late AnimationController _animationControllerX;
  late AnimationController _animationControllerY;
  late AnimationController _animationControllerRot;

  late AxisAnimatedPositioned _childPositioned;

  @override
  void initState() {
    super.initState();

    _animationControllerX = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000) //横振れの周期
        );

    _animationControllerY = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 10000) //縦移動の時間
        );

    _animationControllerRot = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000) //回転の周期
        );

    _animationControllerX.repeat();
    _animationControllerY.forward();
    _animationControllerRot.repeat();

    _animationControllerY.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        print("completed");
        _animationControllerX.stop();
        _animationControllerY.stop();
        _animationControllerRot.stop();

        _childPositioned.toInvisible();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _childPositioned = AxisAnimatedPositioned(
        axis: new AxisPair(
            x: _animationControllerX
                .drive(CurveTween(curve: SinCurve()))
                //.drive(AbsolutePositionTween(begin: 10.0, end: 20.0)),
                .drive(AbsolutePositionTween(
                    begin: widget.startX ?? 10.0,
                    end: widget.startX != null ? widget.startX! + 10 : 20.0)),
            y: _animationControllerY
                .drive(CurveTween(curve: Curves.linear))
                .drive(AbsolutePositionTween(
                    begin: widget.startY ?? 500.0, end: widget.endY ?? 100.0))),
        child: RotationTransition(
            alignment: Alignment.center,
            turns: _animationControllerRot
                .drive(CurveTween(curve: SinCurve()))
                .drive(Tween<double>(begin: 0, end: 0.02)),
            child: Text(
              randomTsuratanVSTsuratan(),
              style:
                  TextStyle(fontSize: widget.fontSize, color: Colors.black12),
            )));

    return _childPositioned;
  }

  @override
  void dispose() {
    _animationControllerX.dispose();
    _animationControllerY.dispose();
    _animationControllerRot.dispose();
    super.dispose();
  }
}
