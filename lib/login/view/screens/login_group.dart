part of '../login_form.dart';

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 80,
            child: TextField(
              key: const Key('loginForm_emailInput_textField'),
              onChanged: (email) =>
                  context.read<LoginCubit>().emailChanged(email),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                prefixIcon:
                    const Icon(FontAwesomeIcons.solidUser, color: Colors.grey),
                labelText: 'Email',
                helperText: '',
                errorText:
                    state.email.displayError != null ? 'Invalid email' : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool viewPassword = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 80,
            child: TextField(
              key: const Key('loginForm_passwordInput_textField'),
              onChanged: (password) =>
                  context.read<LoginCubit>().passwordChanged(password),
              obscureText: !viewPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                prefixIcon:
                    const Icon(FontAwesomeIcons.lock, color: Colors.grey),
                suffixIcon: GestureDetector(
                  child: Icon(
                    viewPassword
                        ? FontAwesomeIcons.solidEye
                        : FontAwesomeIcons.eye,
                    color: Colors.grey,
                  ),
                  onTap: () => setState(() {
                    viewPassword = !viewPassword;
                  }),
                ),
                labelText: 'Password',
                helperText: '',
                errorText: state.password.displayError != null
                    ? 'Invalid password'
                    : null,
                errorMaxLines: 3,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  final bool enableTap;
  const _GoogleLoginButton({this.enableTap = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ElevatedButton.icon(
          key: const Key('loginForm_googleLogin_raisedButton'),
          label: const Text(
            'SIGN IN WITH GOOGLE',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: theme.colorScheme.secondary,
          ),
          icon: const Icon(
            FontAwesomeIcons.google,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            if (enableTap) {
              context.read<LoginCubit>().logInWithGoogle();
            }
          },
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;
  final Widget textWidget;
  const _LoginButton({
    this.onTap,
    this.color = const Color(0xFFFFD600),
    required this.textWidget,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 40,
                width: 80,
                child: TextButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: color,
                  ),
                  onPressed: () {
                    if (state.isValid) {
                      context.read<LoginCubit>().logInWithCredentials();
                    }
                    onTap!();
                  },
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: state.isValid || onTap != null
                          ? theme.primaryColor
                          : Colors.grey,
                    ),
                    child: textWidget,
                  ),
                ),
              );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;
  final Widget textWidget;
  const _SignUpButton({
    this.onTap,
    this.color = Colors.transparent,
    required this.textWidget,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          width: 80,
          child: TextButton(
            key: const Key('loginForm_createAccount_flatButton'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: color,
            ),
            onPressed: () {
              if (state.isValid) {
                context.read<SignUpCubit>().signUpFormSubmitted();
              }
              onTap!();
            },
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: state.isValid || onTap != null
                    ? theme.primaryColor
                    : Colors.grey,
              ),
              child: textWidget,
            ),
          ),
        );
      },
    );
  }
}

class _DummyConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          prefixIcon: const Icon(
            FontAwesomeIcons.lock,
            color: Colors.grey,
          ),
          suffixIcon: const Icon(
            FontAwesomeIcons.eye,
            color: Colors.grey,
          ),
          labelText: 'Confirm password',
          helperText: '',
        ),
      ),
    );
  }
}
