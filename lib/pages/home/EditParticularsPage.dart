part of 'ProfilePicturePage.dart';

class EditParticularsPage extends StatefulWidget {
  const EditParticularsPage(this.choice, {Key? key}) : super(key: key);

  final ProfileParticulars choice;

  @override
  State<EditParticularsPage> createState() => _EditParticularsPageState();
}

class _EditParticularsPageState extends State<EditParticularsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late FocusNode _nameFocus = FocusNode();
  late FocusNode _locationFocus = FocusNode();
  late FocusNode _emailFocus = FocusNode();
  late FocusNode _confirmEmailFocus = FocusNode();
  late FocusNode _pwFocus = FocusNode();
  late FocusNode _cpwFocus = FocusNode();

  late AuthEvent action;

  @override
  void dispose() {
    _nameFocus.dispose();
    _locationFocus.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late String textPrompt;
    late List<Widget> displayFields;

    _submitForm(AuthEvent submitAction) => () {
          if (_formKey.currentState!.validate()) {
            context.read<AuthBloc>().add(submitAction);
            Navigator.pop(context);
          }
        };

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          switch (widget.choice) {
            case ProfileParticulars.Name:
              textPrompt = "Change your display name:";
              action = UpdateDisplayName(_nameController.text);
              displayFields = [
                TextFormField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'New display name'),
                  focusNode: _nameFocus,
                  onChanged: (_) => setState(() {
                    action = UpdateDisplayName(_nameController.text);
                  }),
                  onEditingComplete: _submitForm(action),
                )
              ];
              break;
            case ProfileParticulars.Location:
              textPrompt = "Set your location:";
              action = UpdateLocation(_locationController.text);
              displayFields = [
                TextFormField(
                  controller: _locationController,
                  decoration:
                      const InputDecoration(labelText: 'Set your location'),
                  focusNode: _locationFocus,
                  onChanged: (_) => setState(() {
                    action = UpdateLocation(_locationController.text);
                  }),
                  onEditingComplete: _submitForm(action),
                )
              ];
              break;
            case ProfileParticulars.Email:
              action = UpdateEmail(_emailController.text);
              textPrompt = "Change your email:";
              displayFields = [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'New email'),
                  focusNode: _emailFocus,
                  onChanged: (_) => setState(() {
                    action = UpdateEmail(_emailController.text);
                  }),
                  onEditingComplete: _confirmEmailFocus.requestFocus,
                  validator: emailValidator,
                ),
                TextFormField(
                  controller: _confirmEmailController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm new email'),
                  focusNode: _confirmEmailFocus,
                  onEditingComplete: _submitForm(action),
                  validator: (value) {
                    String? checkEntry = emailValidator(value);
                    if (checkEntry == null)
                      return value != _emailController.text
                          ? 'Unmatching emails'
                          : null;
                    else
                      return checkEntry;
                  },
                )
              ];
              break;
            case ProfileParticulars.Password:
              action = UpdatePassword(_passwordController.text);
              textPrompt = "Change your password";
              displayFields = [
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'New password'),
                  obscureText: true,
                  focusNode: _pwFocus,
                  onChanged: (_) => setState(() {
                    action = UpdatePassword(_passwordController.text);
                  }),
                  onEditingComplete: _cpwFocus.requestFocus,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter your password';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm new password'),
                  obscureText: true,
                  focusNode: _cpwFocus,
                  onEditingComplete: _submitForm(action),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Non-matching passwords';
                    }
                    return null;
                  },
                )
              ];
              break;
          }

          final Widget textPromptDisplay = Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.07),
            child: AutoSizeText(textPrompt, minFontSize: 20),
          );

          final Widget completeButton = Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.03),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _submitForm(action),
              child: AutoSizeText(
                "Save Changes",
                minFontSize: 16,
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.85,
                  MediaQuery.of(context).size.height * 0.02,
                ),
                padding: const EdgeInsets.all(10),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                ),
              ),
            ),
          );

          final Size _deviceDimensions = MediaQuery.of(context).size;
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: _deviceDimensions.height,
                width: _deviceDimensions.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: _deviceDimensions.height * 0.02,
                      horizontal: _deviceDimensions.width * 0.075),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [textPromptDisplay, ...displayFields]),
                        ),
                      ),
                      completeButton,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
