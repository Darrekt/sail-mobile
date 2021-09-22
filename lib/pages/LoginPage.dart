import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sail/blocs/bloc_barrel.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sail/components/util/ErrorToast.dart';
import 'package:sail/util/constants.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  @override
  Widget build(BuildContext context) {
    bool loginNotSignup = ModalRoute.of(context)!.settings.name! == '/login';

    Future<void> _submitForm(bool loginNotSignup) async {
      if (_formKey.currentState!.validate()) {
        context.read<AuthBloc>().add(loginNotSignup
            ? TryEmailSignIn(_emailController.text, _passwordController.text)
            : TryEmailSignUp(_emailController.text, _passwordController.text));
      } else {
        log("invalid form???");
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: !loginNotSignup,
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) Navigator.pop(context);
          if (state is Unauthenticated && state.reason != null)
            showErrorToast(state.reason!);
        },
        builder: (context, state) {
          final Widget heroLogo = Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.07),
              child: Center(
                  child: FlutterLogo(
                      size: MediaQuery.of(context).size.width * 0.4)));

          final Widget emailField = TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            focusNode: _emailFocus,
            onEditingComplete: _pwFocus.requestFocus,
            validator: emailValidator,
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
              if (value == null || value.isEmpty)
                return 'Please enter your password';
              return null;
            },
          );

          final Widget confirmPasswordField = TextFormField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
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

          //TODO: Turn into mini button row. I hate these libraries.
          final Widget socialSignInButtonBar = Container(
              width: MediaQuery.of(context).size.width * 0.55,
              child: Column(
                children: [
                  SignInButton(
                    Buttons.Facebook,
                    onPressed: () =>
                        context.read<AuthBloc>().add(TryFacebookSignIn()),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  ),
                  SignInButton(
                    Buttons.GoogleDark,
                    onPressed: () =>
                        context.read<AuthBloc>().add(TryGoogleSignIn()),
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

          return SingleChildScrollView(
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
          );
        },
      ),
    );
  }
}
