import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IAuthRepository {
  Future<bool> loginGuest();
}

class AuthRepository extends StateNotifier<bool> implements IAuthRepository {
  AuthRepository() : super(false);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<bool> loginGuest() async {
    try {
      await _auth.signInAnonymously();
      state = true;
      return true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      state = false;
      return false;
    }
  }
}
