import 'package:firebase_auth/firebase_auth.dart';
import 'package:an_muk_so/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userEmail {
    return _auth.currentUser.email;
  }

  // create user obj based on firebase user
  TheUser _userFromFirebaseUser(User user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<TheUser> get user {
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
    // .map(_userFromFirebaseUser);
  }

  // register with email and password
  Future signUpWithEmail(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return _userFromFirebaseUser(result.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return '이미 사용 중인 이메일 입니다';
      } else if (e.code == 'invalid-email') {
        return '유효한 이메일 형식이 아닙니다';
      } else if (e.code == 'weak-password') {
        return '입력한 비밀번호가 너무 약합니다';
      }
    }
  }

  // login with email and password
  Future signInWithEmail(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return '회원이 아니시거나 아이디를 잘못입력하셨습니다';
      } else if (e.code == 'invalid-email') {
        return '잘못된 이메일 형식입니다';
      } else if (e.code == 'wrong-password') {
        return '비밀번호를 잘못입력하셨습니다';
      }
    }
  }


  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // 사용자에게 비밀번호 재설정 메일을 전송
  Future sendPasswordResetEmail(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return '회원이 아니시거나 아이디를 잘못입력하셨습니다';
      } else if (e.code == 'invalid-email') {
        return '잘못된 이메일 형식입니다';
      } else if (e.code == 'wrong-password') {
        return '비밀번호를 잘못입력하셨습니다';
      }
    }
  }

  // Firebase로부터 회원 탈퇴
  Future withdrawalAccount() async {
    try {
      return await _auth.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return '로그인을 다시 하신 후 시도해주시기 바랍니다.';
      } else
        return e.toString();
    }

    // catch (error) {
    //   print(error.toString());
    //   return error.toString();
    // }
  }

}
