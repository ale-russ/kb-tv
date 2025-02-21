import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                      child: Text(isLogin ? "Login" : "Register"),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(isLogin
                        ? "Create Account"
                        : "Already have an account? Login"),
                  ),
                  ElevatedButton.icon(
                    onPressed: _googleSignIn,
                    icon: Icon(Icons.login),
                    label: Text("Sign in with Google"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome, ${user.email}"),
                  ElevatedButton(
                      onPressed: () =>
                          ref.read(authProvider.notifier).signOut(),
                      child: Text("Log out"))
                ],
              ),
            ),
    );
  }
}
