import 'dart:math' as math;

import 'package:flutter/foundation.dart';

@immutable
class RandomAppearButtonData {
  final double x, y;
  final int score;
  final bool appear;

  const RandomAppearButtonData(this.score, this.x, this.y, this.appear);

  RandomAppearButtonData updated(double xLimit, double yLimit) {
    final x = (math.Random()).nextDouble() * xLimit;
    final y = (math.Random()).nextDouble() * yLimit;
    // ignore: avoid_print
    print("updated $score : x=$x , y=$y");
    return RandomAppearButtonData(score, x, y, appear);
  }

  static const RandomAppearButtonData defaultPosition =
      RandomAppearButtonData(1000, -1000, -1000, false);
}
