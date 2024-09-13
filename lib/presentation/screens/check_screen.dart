import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/domain/services/profile_service.dart';
import 'package:pet_adoption/presentation/screens/pre_home_screen.dart';
import 'package:pet_adoption/presentation/screens/profile_completion_screen.dart';

class CheckerScreen extends ConsumerStatefulWidget {
  const CheckerScreen({super.key});

  @override
  ConsumerState<CheckerScreen> createState() {
    return _CheckerScreenState();
  }
}

class _CheckerScreenState extends ConsumerState<CheckerScreen> {
  @override
  void initState() {
    super.initState();
    _checkProfileCompletion();
  }

  Future<void> _checkProfileCompletion() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      final isProfileComplete = await ref.read(profileServiceProvider).checkProfileCompletion(user.uid);
      if (!isProfileComplete) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProfileCompletionScreen()),
        );
        }
      } else {
        if (mounted) {
          Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PreHomeScreen()),
        );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
   }
}
