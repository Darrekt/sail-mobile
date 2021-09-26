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
    Future<void> _submitForm() async {
      if (_formKey.currentState!.validate()) {
        context.read<AuthBloc>().add(
            TryEmailSignUp(_emailController.text, _passwordController.text));
      }
    }

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
          late final String textPrompt;
          final Widget textPromptDisplay = Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.07),
            child: AutoSizeText(
              "Set your name below:",
              minFontSize: 20,
            ),
          );

          final Widget nameField = TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'New display name'),
            focusNode: _nameFocus,
            onEditingComplete: _submitForm,
          );

          final Widget emailField = TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'New email'),
            focusNode: _emailFocus,
            onEditingComplete: _confirmEmailFocus.requestFocus,
            validator: emailValidator,
          );

          final Widget confirmEmailField = TextFormField(
            controller: _confirmEmailController,
            decoration: const InputDecoration(labelText: 'Confirm new email'),
            focusNode: _emailFocus,
            onEditingComplete: _submitForm,
            validator: emailValidator,
          );

          final Widget passwordField = TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'New password'),
            obscureText: true,
            focusNode: _pwFocus,
            onEditingComplete: _cpwFocus.requestFocus,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please enter your password';
              return null;
            },
          );

          final Widget confirmPasswordField = TextFormField(
            controller: _confirmPasswordController,
            decoration:
                const InputDecoration(labelText: 'Confirm new password'),
            obscureText: true,
            focusNode: _cpwFocus,
            onEditingComplete: _submitForm,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              } else if (value != _passwordController.text) {
                return 'Non-matching password';
              }
              return null;
            },
          );

          late final List<Widget> displayFields;

          switch (widget.choice) {
            case ProfileParticulars.Name:
              textPrompt = "Change your display name below:";
              displayFields = [nameField];
              break;
            case ProfileParticulars.Location:
              textPrompt = "Set your location here:";
              displayFields = [emailField, confirmEmailField];
              break;
            case ProfileParticulars.Email:
              textPrompt = "Change your email below:";
              displayFields = [emailField, confirmEmailField];
              break;
            case ProfileParticulars.Password:
              textPrompt = "Change your password below";
              displayFields = [passwordField, confirmPasswordField];
              break;
          }

          final Widget completeButton = Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.03),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _submitForm,
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
