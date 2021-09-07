import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sail/blocs/bloc_barrel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sail/components/util/SingleInputFormPage.dart';
import 'package:sail/util/constants.dart';

class PartnerPairingPage extends StatefulWidget {
  const PartnerPairingPage({Key? key}) : super(key: key);

  @override
  _PartnerPairingPageState createState() => _PartnerPairingPageState();
}

class _PartnerPairingPageState extends State<PartnerPairingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final PageController _pageController = PageController();
  late FocusNode _otpFocus = FocusNode();
  bool otpSent = false;

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  String currentText = "";

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceDimensions = MediaQuery.of(context).size;

    void _findPartner() {
      if (_formKey.currentState!.validate())
        context.read<AuthBloc>().add(TryFindPartner(_emailController.text));
    }

    void _submitOTP() {
      if (_formKey.currentState!.validate())
        context
            .read<AuthBloc>()
            .add(TryLinkPartner(_emailController.text, _otpController.text));
    }

    final Widget emailField = TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: emailValidator,
    );

    final Widget otpField = PinCodeTextField(
      autoDisposeControllers: false,
      appContext: context,
      pastedTextStyle: TextStyle(
        color: Colors.green.shade600,
        fontWeight: FontWeight.normal,
      ),
      length: 6,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        fieldHeight: 50,
        fieldWidth: 40,
        inactiveColor: Colors.grey,
        activeColor: Colors.cyan,
        selectedColor: Colors.cyanAccent,
      ),
      cursorColor: Colors.black,
      animationDuration: Duration(milliseconds: 200),
      errorAnimationController: errorController,
      controller: _otpController,
      keyboardType: TextInputType.number,

      onCompleted: (v) {
        print("Completed");
      },
      // onTap: () {
      //   print("Pressed");
      // },
      onChanged: (value) {
        setState(() {
          currentText = value;
        });
      },
      beforeTextPaste: (text) {
        print("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PairingInProgress) {
          setState(() {
            otpSent = true;
          });
          _pageController.nextPage(
              duration: Duration(milliseconds: 200), curve: Curves.ease);
          Future.delayed(Duration(milliseconds: 250), _otpFocus.requestFocus);
        } else if (state is PairingFailed)
          Fluttertoast.showToast(
              msg: state.reason,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
      },
      child: SingleInputFormPage(
        title: "Partner pairing",
        formKey: _formKey,
        submitText: !otpSent ? "Send pairing code" : "Submit OTP",
        onSubmit: !otpSent ? _findPartner : _submitOTP,
        children: [
          SizedBox(
            height: deviceDimensions.height * 0.15,
            width: deviceDimensions.width,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: AutoSizeText("Enter your partner's email:"),
                    ),
                    emailField,
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child:
                          AutoSizeText("Enter the code sent to your partner:"),
                    ),
                    otpField,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
