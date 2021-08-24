import 'dart:math' as math;

import 'package:flutter/foundation.dart';

@immutable
class RandomAppearButtonData {
  final double x, y;
  final int score;
  final bool appear;

  const RandomAppearButtonData(this.score, this.x, this.y, this.appear);

  RandomAppearButtonData updated(double xLimit, double yLimit) {
    final x = (new math.Random()).nextDouble() * xLimit;
    final y = (new math.Random()).nextDouble() * yLimit;
    print("updated $score : x=$x , y=$y");
    return RandomAppearButtonData(this.score, x, y, this.appear);
  }

  static const RandomAppearButtonData defaultPosition =
      RandomAppearButtonData(1000, -1000, -1000, false);
}
