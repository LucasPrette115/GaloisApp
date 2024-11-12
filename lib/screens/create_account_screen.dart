import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graph_app/services/create_account_service.dart';
import 'package:graph_app/services/login_service.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final CreateAccountService _accountService = CreateAccountService();
  final AuthService _authService = AuthService();
  bool _isObscured = true;

  void createAccount(BuildContext context) async {
    try {
      var user = await _accountService.signUp(
          emailController.text, passwordController.text);

      if (user != null) {
        _authService.signIn(emailController.text, passwordController.text);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (ex) {
      var errorMessage = ex.message ?? "An unexpected error occurred.";
      var snackBar = SnackBar(
        content: Text(errorMessage),
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
              'Create account',
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                '../assets/img/galois_1.jpg',
                height: 400,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
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
                onPressed: () {
                  createAccount(context);
                },
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      ' Log in',
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
