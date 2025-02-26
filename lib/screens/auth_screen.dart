import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:k_tv/focusable.dart';
import 'package:k_tv/providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;

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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    log("User: $user");
    if (user != null) {
      WidgetsBinding.instance.addPersistentFrameCallback((_) {
        if (mounted) {
          // Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (context) => HomeScreen()));
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
                  FocusableWidget(
                    onSelect: () => {},
                    onFocus: () => print("Items focused"),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email"),
                    ),
                  ),
                  FocusableWidget(
                    onSelect: () => {},
                    onFocus: () => print("Items focused"),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  FocusableWidget(
                    onSelect: () => {},
                    onFocus: () => print("Items focused"),
                    child: ElevatedButton(
                      onPressed: _authenticate,
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () => setState(() => isLogin = !isLogin),
                  //   child: Text(isLogin
                  //       ? "Create Account"
                  //       : "Already have an account? Login"),
                  // ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _googleSignIn,
                    icon: Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Sign in with Google",
                      style: TextStyle(color: Colors.white),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => context.push("/qr-login"),
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => QrLoginScreen(),
                    //   ),
                    // ),
                    icon: Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Login with QR code",
                      style: TextStyle(color: Colors.white),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ],
              ),
            )
          : CircularProgressIndicator(),
    );
  }
}
