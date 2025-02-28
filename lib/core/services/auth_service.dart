import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? errorMessage;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print("로그인 오류: $e");
      }
      return null;
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {

      if (kDebugMode) {
        print("회원가입 오류: $e");
      }
      errorMessage = _getErrorMessage(e.toString());
      return null;
    }
  }

  String _getErrorMessage(String error) {

    if (kDebugMode) {
      print('error $error');
    }
    if (error.contains('invalid-email')) {
      return '잘못된 이메일 형식입니다.';
    } else if (error.contains('weak-password')) {
      return '비밀번호는 최소 6자 이상이어야 합니다.';
    } else if (error.contains('email-already-in-use')) {
      return '이미 사용 중인 이메일입니다.';
    } else {
      return '회원가입 중 오류가 발생했습니다.';
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();


      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print("Google 로그인 오류: $e");
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
