import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: EmailForm(),
      ),
    );
  }
}

class EmailForm extends StatefulWidget {
  EmailForm({Key? key}) : super(key: key);

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool loginNotSignup = ModalRoute.of(context)!.settings.name! == '/login';
    // log("fucken here\n\n");
    // log(ModalRoute.of(context)!.settings.name!);
    // log("fucken done\n\n");

    String titleStr = loginNotSignup ? 'Sign In' : 'Register';
    var title = Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        titleStr,
        style: TextStyle(
          fontSize: 24.0,
        ),
      ),
    );

    var emailField = TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
    var passwordField = TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(labelText: 'Password'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
    var confirmPasswordField = TextFormField(
      controller: _confirmPasswordController,
      decoration: const InputDecoration(labelText: 'Confirm Password'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        return null;
      },
    );

    String buttonStr = loginNotSignup ? 'Sign Me In' : 'Register Me';
    var completeButton = Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (loginNotSignup) {
              await _signInWithEmailAndPassword();
            } else {
              await _createUserWithEmailAndPassword();
            }
          } else {
            log("invalid form???");
          }
        },
        child: Text(buttonStr),
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
          padding: const EdgeInsets.all(16),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0),
          ),
        ),
      ),
    );

    var signupPageButton = Container(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
        child: Text("New to Spark? SIGN UP"),
        style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 16)),
      ),
    );
    var renderLogin = [
      title,
      emailField,
      passwordField,
      completeButton,
      signupPageButton
    ];
    var renderSignup = [
      title,
      emailField,
      passwordField,
      confirmPasswordField,
      completeButton,
    ];
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: loginNotSignup ? renderLogin : renderSignup,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (user != null) {
        log("user logged in"); // move to home from here
        Navigator.popAndPushNamed(context, '/');
      } else {
        log("user null??");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      if (_passwordController.text == _confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.popAndPushNamed(context, '/login');
      } else {
        log('Please ensure the password is the same for both fields.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
