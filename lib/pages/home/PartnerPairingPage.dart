import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spark/blocs/bloc_barrel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter a valid email' : null,
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

    final Widget completeButton = Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.03),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: otpSent ? _findPartner : _submitOTP,
        child: AutoSizeText(
          "Pair",
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
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: deviceDimensions.width * 0.15),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: deviceDimensions.height * 0.025,
                        bottom: deviceDimensions.height * 0.05),
                    child: SizedBox(
                      height: deviceDimensions.width * 0.4,
                      width: deviceDimensions.width * 0.4,
                      child: Placeholder(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: deviceDimensions.height * 0.15,
                          width: deviceDimensions.width,
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Enter your partner's email:"),
                                  emailField,
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Enter the code sent to your partner:"),
                                  otpField,
                                ],
                              ),
                            ],
                          ),
                        ),
                        completeButton
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
