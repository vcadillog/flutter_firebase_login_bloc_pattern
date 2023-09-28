part of '../login_form.dart';

/// HANDLES ALL THE ANIMATIONS

class _EmailAltInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 80,
            child: TextField(
              key: const Key('signUpForm_emailInput_textField'),
              onChanged: (email) =>
                  context.read<SignUpCubit>().emailChanged(email),
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

class _SignUpAltButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: TextButton(
            key: const Key('loginForm_createAccount_flatButton'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: const Color(0xFFFFD600),
            ),
            onPressed: () => state.isValid
                ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                : null,
            child: Text(
              'SIGN UP',
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

class _PasswordAltInput extends StatefulWidget {
  @override
  State<_PasswordAltInput> createState() => _PasswordAltInputState();
}

class _PasswordAltInputState extends State<_PasswordAltInput> {
  bool viewPassword = false;
  String errorText = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        switch (state.password.displayError) {
          case PasswordValidationError.invalid:
            errorText =
                'Password must be at least 8 characters long and have one letter and a number.';
          case PasswordValidationError.invalidLen:
            errorText = 'Password must be at least 8 characters long.';
          case PasswordValidationError.invalidLenLetter:
            errorText =
                'Password must be at least 8 characters long and one letter.';
          case PasswordValidationError.invalidLenNumber:
            errorText =
                'Password must be at least 8 characters long and one number.';
          case PasswordValidationError.invalidLetter:
            errorText = 'Password must include at least one letter.';
          case PasswordValidationError.invalidLetterNum:
            errorText = 'Password must include at least one number and letter.';
          case PasswordValidationError.invalidNumber:
            errorText = 'Password must include at least one number.';
          default:
            errorText = '';
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 80,
            child: TextField(
              key: const Key('signUpForm_passwordInput_textField'),
              onChanged: (password) =>
                  context.read<SignUpCubit>().passwordChanged(password),
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
                errorText: errorText.isEmpty ? null : errorText,
                errorMaxLines: 3,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatefulWidget {
  @override
  State<_ConfirmPasswordInput> createState() => _ConfirmPasswordInputState();
}

class _ConfirmPasswordInputState extends State<_ConfirmPasswordInput> {
  bool viewPassword = false;
  String errorText = '';

  @override
  Widget build(BuildContext context) {
    return _InFieldAnimation(
      boxHeight: 88,
      onEnd: context.read<AnimationCubit>().onSingupEnd,
      inputWidget: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
        child: BlocBuilder<SignUpCubit, SignUpState>(
          builder: (context, state) {
            return TextField(
              key: const Key(
                'signUpForm_confirmedPasswordInput_textField',
              ),
              onChanged: (confirmPassword) => context
                  .read<SignUpCubit>()
                  .confirmedPasswordChanged(confirmPassword),
              obscureText: !viewPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                prefixIcon: const Icon(
                  FontAwesomeIcons.lock,
                  color: Colors.grey,
                ),
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
                labelText: 'Confirm password',
                helperText: '',
                errorText: state.confirmedPassword.displayError != null
                    ? 'Passwords do not match'
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoginAltButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: BlocBuilder<AnimationCubit, AnimationState>(
        builder: (context, state) {
          return TextButton(
            key: const Key('loginForm_continue_raisedButton'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.transparent,
            ),
            onPressed: () {
              if (state.status == ButtonPushStatus.signupEnd) {
                FocusScope.of(context).unfocus();
                context.read<SignUpCubit>().resetForms();
                context.read<AnimationCubit>().toLogin();
              }
            },
            child: const Text('LOGIN'),
          );
        },
      ),
    );
  }
}
