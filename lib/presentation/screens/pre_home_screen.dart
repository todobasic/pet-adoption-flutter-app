import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/presentation/providers/ui_state_providers.dart';
import 'package:pet_adoption/presentation/screens/collaborative_filtering_screen.dart';
import 'package:pet_adoption/presentation/screens/home_screen.dart';
import 'package:pet_adoption/presentation/screens/recommendations_screen.dart';

class PreHomeScreen extends ConsumerStatefulWidget {
  const PreHomeScreen({super.key});

  @override
  ConsumerState<PreHomeScreen> createState() => PreHomeScreenState();
}

class PreHomeScreenState extends ConsumerState<PreHomeScreen> {
  @override
  Widget build(BuildContext context) {

    final List<Widget> screens = [
      const HomeScreen(),
      const RecommendationsScreen(),
      const CollaborativeFilteringScreen(),
    ];

    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
            currentIndex: indexBottomNavbar,
            onTap: (value) {
              ref.read(indexBottomNavbarProvider.notifier).update((state) => value);
            },            
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.recommend),
                label: 'Recommended'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Collaborative'
              ),
            ],
          ),
        body: screens[indexBottomNavbar],
    );
  }
}