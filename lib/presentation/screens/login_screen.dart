import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/presentation/controllers/login_controller.dart';
import 'package:pet_adoption/presentation/controllers/login_state.dart';
import 'package:pet_adoption/presentation/screens/register_screen.dart';
import 'package:pet_adoption/presentation/widgets/custom_header.dart';
import 'package:pet_adoption/presentation/widgets/custom_text_field.dart';
import 'package:pet_adoption/presentation/widgets/login_error_snackbar.dart';

class LoginScreen extends StatefulHookConsumerWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    ref
        .read(loginControllerProvider.notifier)
        .login(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginControllerProvider, (previous, state) {
      if (state is LoginStateError) {
        showLoginErrorSnackBar(context, state.error);
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const CustomHeader(title: 'Pet Adoption', subtitle: 'Sign in'),
            CustomTextField(
              controller: emailController,
              label: 'Email Address',
            ),
            CustomTextField(
              controller: passwordController,
              label: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Do not have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Sign up', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
