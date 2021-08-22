import 'package:meta/meta.dart';

@immutable
class TrophyEntity {
  final String title;
  final String description;

  const TrophyEntity(this.title, this.description);
}

@immutable
class TrophyWithAchieved {
  final TrophyEntity trophy;
  final int index;
  final bool isAchieved;

  TrophyWithAchieved(this.trophy, this.index, this.isAchieved);
}
