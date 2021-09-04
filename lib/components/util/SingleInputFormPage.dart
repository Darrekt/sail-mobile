import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SingleInputFormPage extends StatelessWidget {
  const SingleInputFormPage({
    Key? key,
    required this.formKey,
    required this.children,
    this.title,
    required this.submitText,
    required this.onSubmit,
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  final String? title;
  final List<Widget> children;
  final String submitText;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final Size deviceDimensions = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          title ?? "",
          maxFontSize: 18,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        minimum:
            EdgeInsets.symmetric(horizontal: deviceDimensions.width * 0.15),
        child: Form(
          key: formKey,
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
                    children: children,
                  ),
                ),
                Container(
                  // padding: EdgeInsets.symmetric(
                  //     vertical: MediaQuery.of(context).size.height * 0.03),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    child: AutoSizeText(
                      submitText,
                      minFontSize: 16,
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.7,
                        MediaQuery.of(context).size.height * 0.02,
                      ),
                      padding: const EdgeInsets.all(10),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
