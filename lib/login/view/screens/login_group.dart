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

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 40,
      child: TextButton(
        key: const Key('loginForm_createAccount_flatButton'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.transparent,
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          context.read<LoginCubit>().resetForms();
          context.read<AnimationCubit>().toSignup();
        },
        child: Text(
          'SIGN UP',
          style: TextStyle(color: theme.primaryColor),
        ),
      ),
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      curve: Curves.bounceOut,
      height: 40,
      duration: const Duration(seconds: 1),
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
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: theme.colorScheme.secondary,
          ),
          icon: const Icon(
            FontAwesomeIcons.google,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                height: 40,
                child: TextButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color(0xFFFFD600),
                  ),
                  onPressed: state.isValid
                      ? () => context.read<LoginCubit>().logInWithCredentials()
                      : () => (),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      color: state.isValid ? theme.primaryColor : Colors.grey,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
