import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graph_app/services/login_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isObscured = true;

  void login(BuildContext context) async {
    try {
      await _authService.signIn(
          usernameController.text, passwordController.text);

      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (ex) {
      var snackBar = SnackBar(
        content: Text(ex.message!),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (ex) {
      var snackBar = const SnackBar(
        content: Text("An unexpected error occurred. Please try again."),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: Text(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              'Sign In',
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                '../assets/img/galois.jpg',
                height: 400,
              ),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                ),
                obscureText: _isObscured,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, '/create-account');
                    },
                    child: const Text(
                      ' Sign up',
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
