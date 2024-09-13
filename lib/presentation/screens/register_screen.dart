import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/presentation/controllers/login_controller.dart';
import 'package:pet_adoption/presentation/controllers/login_state.dart';
import 'package:pet_adoption/presentation/widgets/custom_header.dart';
import 'package:pet_adoption/presentation/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulHookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match"),
      ));
    } else {
      ref
          .read(loginControllerProvider.notifier)
          .register(emailController.text, passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginControllerProvider, ((previous, state) {
      if (state is LoginStateError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.error),
        ));
      }
    }));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            const CustomHeader(title: 'Pet Adoption', subtitle: 'Sign up'),
            CustomTextField(
              controller: emailController,
              label: 'Email Address',
            ),
            CustomTextField(
              controller: passwordController,
              label: 'Password',
              obscureText: true,
            ),
            CustomTextField(
              controller: confirmPasswordController,
              label: 'Confirm Password',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); 
                  },
                  child: const Text('Sign in', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
