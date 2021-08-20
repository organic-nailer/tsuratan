import 'dart:math' as math;

class RandomAppearButtonData {
  double x,y;
  final int score;
  bool appear;

  RandomAppearButtonData(this.score, this.x, this.y, this.appear);

  void update(double xLimit, double yLimit) {
    x = (new math.Random()).nextDouble() * xLimit;
    y = (new math.Random()).nextDouble() * yLimit;

    print("updated $score : x=$x , y=$y");
  }
}