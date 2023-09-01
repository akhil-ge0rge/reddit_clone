import 'package:flutter/material.dart';
import 'package:reddit_clone/core/constants/constants.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {},
        icon: Image.asset(
          Constants.googlePath,
          width: 45,
        ),
        label: const Text(
          "Continue with Google",
          style: TextStyle(fontSize: 18),
        ));
  }
}
