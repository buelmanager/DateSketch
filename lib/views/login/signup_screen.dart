import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/auth_service.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = ref.read(authServiceProvider);
    try {
      final user = await authService.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() {
        _errorMessage = authService.errorMessage;
      });

      if (user != null) {
        Navigator.pop(context); // 회원가입 성공 시 로그인 화면으로 이동
      }
    } catch (e) {

      if (kDebugMode) {
        print('e $e');
      }

      setState(() {
        _errorMessage = authService.errorMessage;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _signupWithGoogle() async {
    final authService = ref.read(authServiceProvider);

    final user = await authService.signInWithGoogle();
    if (user == null) {
      setState(() {
        _errorMessage = "Google 회원가입에 실패했습니다.";
      });
    } else {
      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(_errorMessage);
    }
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "이메일"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "비밀번호"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null && _errorMessage!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ElevatedButton(
              onPressed: _isLoading ? null : _signup,
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("회원가입"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _signupWithGoogle,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/google_logo.png", height: 24),
                  const SizedBox(width: 10),
                  const Text("Google로 회원가입", style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}