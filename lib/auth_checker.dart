import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/presentation/screens/check_screen.dart';
import 'package:pet_adoption/presentation/screens/login_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (user != null) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CheckerScreen()),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        });
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) {
        print("Error occurred in auth state: $error");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        });
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
