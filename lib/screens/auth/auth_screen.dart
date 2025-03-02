import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:k_tv/focusable.dart';
import 'package:k_tv/providers/auth_provider.dart';
import 'package:k_tv/utils/platform_details.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;

  final PlatformDetails details = PlatformDetails();
  bool _isTV = false;

  void _authenticate() {
    final auth = ref.read(authProvider.notifier);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (isLogin) {
      auth.signIn(email, password);
    } else {
      auth.signUp(email, password);
    }
  }

  void _googleSignIn() {
    ref.read(authProvider.notifier).signInWithGoogle();
  }

  Future<void> _checkPlatform() async {
    final isTV = await details.isTv();
    setState(() {
      _isTV = isTV;
    });
  }

  @override
  void initState() {
    _checkPlatform();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    log("User: $user");
    if (user != null) {
      WidgetsBinding.instance.addPersistentFrameCallback((_) {
        if (mounted) {
          context.go('/home');
        }
      });
    }
    return Scaffold(
      appBar:
          AppBar(title: Text(user == null ? "Auth" : "Welcome ${user.email}")),
      body: user == null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  FocusableWidget(
                      onSelect: _authenticate,
                      onFocus: () => {},
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          isLogin ? "Login" : "Register",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                      // ElevatedButton(
                      //   onPressed: _authenticate,
                      //   child: Text(
                      //     isLogin ? "Login" : "Register",
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // ),
                      ),
                  const SizedBox(height: 20),
                  _isTV
                      ? const SizedBox.shrink()
                      : FocusableWidget(
                          onFocus: () => {},
                          onSelect: () => setState(() => isLogin = !isLogin),
                          child: Container(
                            width: 120,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey)),
                            child: Text(
                              isLogin
                                  ? "Create Account"
                                  : "Already have an account? Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                  // ElevatedButton(
                  //     onPressed: () => setState(() => isLogin = !isLogin),
                  //     child: Text(
                  //         isLogin
                  //             ? "Create Account"
                  //             : "Already have an account? Login",
                  //         style: TextStyle(color: Colors.white)),
                  //   ),
                  const SizedBox(height: 20),

                  FocusableWidget(
                    onSelect: _googleSignIn,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Sign in With Google",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FocusableWidget(
                    onSelect: () => context.go("/qr-login"),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.qr_code,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Login With QR-Code",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ElevatedButton.icon(
                  //   onPressed: () => context.push("/qr-login"),
                  //   icon: Icon(
                  //     Icons.login,
                  //     color: Colors.white,
                  //   ),
                  //   label: Text(
                  //     "Login with QR code",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   style:
                  //       ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  // ),
                ],
              ),
            )
          : CircularProgressIndicator(),
    );
  }
}
