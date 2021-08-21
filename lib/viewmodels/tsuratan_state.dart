import 'package:tsuratan/widgets/falling_credit.dart';
import 'package:tsuratan/widgets/floating_tsuratan.dart';

class TsuratanState {
  bool startVisible = true;
  int score;
  int tanni;
  int oneClicked;
  int tenClicked;
  int hunClicked;
  int thoClicked;

  List<FloatingTsuratan> tsuratanium = [];
  List<FallingCredit> rakutanium = [];
}
