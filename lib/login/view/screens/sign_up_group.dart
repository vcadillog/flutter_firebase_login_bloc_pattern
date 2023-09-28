part of '../login_form.dart';

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
                'Password must be at least 8 characters long and have one letter and one number.';
          case PasswordValidationError.invalidLen:
            errorText = 'Password must be at least 8 characters long.';
          case PasswordValidationError.invalidLenLetter:
            errorText =
                'Password must be at least 8 characters long with one letter.';
          case PasswordValidationError.invalidLenNumber:
            errorText =
                'Password must be at least 8 characters long with one number.';
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
    return Padding(
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
    );
  }
}
