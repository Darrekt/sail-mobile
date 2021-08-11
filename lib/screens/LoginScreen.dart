import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late FocusNode _emailFocus = FocusNode();
  late FocusNode _pwFocus = FocusNode();
  late FocusNode _cpwFocus = FocusNode();

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
        Navigator.pop(context);
      } else {
        log("user null??");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.popAndPushNamed(context, '/login');
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

  Future<void> _submitForm(bool loginNotSignup) async {
    if (_formKey.currentState!.validate()) {
      if (loginNotSignup) {
        await _signInWithEmailAndPassword();
      } else {
        await _createUserWithEmailAndPassword();
      }
    } else {
      log("invalid form???");
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // if (loginResult.status == LoginStatus.success) {
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return _auth.signInWithCredential(facebookAuthCredential);
    // }
  }

  @override
  Widget build(BuildContext context) {
    bool loginNotSignup = ModalRoute.of(context)!.settings.name! == '/login';

    final Widget heroLogo = Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.07),
        child: Center(
            child: FlutterLogo(size: MediaQuery.of(context).size.width * 0.4)));

    final Widget emailField = TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'Email'),
      focusNode: _emailFocus,
      onEditingComplete: _pwFocus.requestFocus,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );

    final Widget passwordField = TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      focusNode: _pwFocus,
      onEditingComplete: () => loginNotSignup
          ? _submitForm(loginNotSignup)
          : _cpwFocus.requestFocus(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );

    final Widget confirmPasswordField = TextFormField(
      controller: _confirmPasswordController,
      decoration: const InputDecoration(labelText: 'Confirm Password'),
      focusNode: _cpwFocus,
      onEditingComplete: () => _submitForm(loginNotSignup),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        } else if (value != _passwordController.text) {
          return 'Non-matching password';
        }
        return null;
      },
    );

    final Widget completeButton = Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.03),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => _submitForm(loginNotSignup),
        child: AutoSizeText(
          loginNotSignup ? 'Login' : 'Register',
          minFontSize: 16,
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(
            MediaQuery.of(context).size.width * 0.4,
            MediaQuery.of(context).size.height * 0.02,
          ),
          padding: const EdgeInsets.all(10),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0),
          ),
        ),
      ),
    );

    //TODO: Turn into mini button row. Fuck these libraries.
    final Widget socialSignInButtonBar = Container(
        width: MediaQuery.of(context).size.width * 0.55,
        child: Column(
          children: [
            SignInButton(
              Buttons.Facebook,
              onPressed: signInWithFacebook,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
            ),
            SignInButton(
              Buttons.GoogleDark,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
            ),
            // SignInWithAppleButton(onPressed: () {}),
            SignInButton(
              Buttons.AppleDark,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
            ),
            SizedBox(height: 20),
            SignInButtonBuilder(
              elevation: 2.0,
              key: ValueKey("Email"),
              text: 'Sign up with Email',
              icon: Icons.email,
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              backgroundColor: Colors.grey[700]!,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
            ),
          ],
        ));

    List<Widget> renderLogin = [
      heroLogo,
      emailField,
      passwordField,
      completeButton,
      socialSignInButtonBar,
    ];
    List<Widget> renderSignup = [
      heroLogo,
      emailField,
      passwordField,
      confirmPasswordField,
      completeButton,
    ];

    //FIXME: Remove elevated border surrounding the scrollview. Get dart devtools working to debug.
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: !loginNotSignup,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: loginNotSignup ? renderLogin : renderSignup,
            ),
          ),
        ),
      ),
    );
  }
}
