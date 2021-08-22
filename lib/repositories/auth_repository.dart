import 'package:firedart/auth/firebase_auth.dart';

abstract class IAuthRepository {
  Future<bool> loginGuest();
}

class AuthRepository implements IAuthRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<bool> loginGuest() async {
    try {
      await _auth.signInAnonymously();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
