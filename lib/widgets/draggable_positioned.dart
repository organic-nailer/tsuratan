import 'package:flutter/material.dart';

class DraggablePositioned extends StatefulWidget {
  final double? left;
  final double? top;
  final Widget child;

  const DraggablePositioned(
      {Key? key, this.left, this.top, required this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DraggablePositionedState();
}

class _DraggablePositionedState extends State<DraggablePositioned> {
  double left = 0;
  double top = 0;

  @override
  void initState() {
    super.initState();

    left = widget.left ?? 0;
    top = widget.top ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Draggable(
        feedback: Material(child: widget.child),
        child: widget.child,
        childWhenDragging: Container(),
        onDragEnd: (DraggableDetails detail) {
          setState(() {
            left = detail.offset.dx;
            top = detail.offset.dy;
          });
        },
      ),
    );
  }
}
