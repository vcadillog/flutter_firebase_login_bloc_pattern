
# Firebase flutter login

Firebase login extending flutter_login library and flutter_bloc guide, added verification login and recover passowrd logic.

### How to use

Follow the firebase official documentation https://firebase.google.com/docs/flutter/setup

And add the generated firebase_options.dart to the /lib directory.

## Warning

If logging with a Google account in a previously registered but unverified account it will require you to reset (recover)  your password (only if the same email allow different login methods in your firebase configuration project). It doesn't display this behaviour if you verified your account beforehand and log in normally with the password you registered.
