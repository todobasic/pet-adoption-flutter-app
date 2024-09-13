import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/presentation/providers/filtered_pet_posts_provider.dart';
import 'package:pet_adoption/presentation/providers/ui_state_providers.dart';
import 'package:pet_adoption/presentation/widgets/custom_drawer.dart';
import 'package:pet_adoption/presentation/widgets/expandable_fab.dart';
import 'package:pet_adoption/presentation/widgets/new_search_field.dart';
import 'package:pet_adoption/presentation/widgets/search_field.dart'; 
import 'package:pet_adoption/presentation/widgets/pet_posts/pet_post_card.dart'; 

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _newsearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchQueryProvider.notifier).state = '';
      ref.read(newSearchQueryProvider.notifier).state = '';
      ref.read(checkBoxProvider.notifier).state = true;
    });    
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(authStateProvider);
    
    if (userState.value == null) {
      return const CircularProgressIndicator();
    }

    final userId = userState.value!.uid;
    final filteredPetPosts = ref.watch(filteredPetPostsProvider);    
    final checkBox = ref.watch(checkBoxProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Adoption'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: Column(
            children: [
              SearchField(controller: _searchController),
              NewSearchField(controller: _newsearchController)
            ],
          ), 
        ),
      ),
      drawer: const CustomDrawer(),
      body: filteredPetPosts.isNotEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    children: [
                      const Text('Show already adopted: '),
                      Checkbox(
                        value: checkBox, 
                        onChanged: (bool? value) {
                          ref.read(checkBoxProvider.notifier).state = value!;
                        }),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredPetPosts.length,
                    itemBuilder: (context, index) {
                      final petPost = filteredPetPosts[index];
                      return PetPostCard(petPost: petPost, userId: userId); 
                    },
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: [
                  const Text('Show already adopted: '),
                  Checkbox(
                    value: checkBox, 
                    onChanged: (bool? value) {
                      ref.read(checkBoxProvider.notifier).state = value!;
                    }),
                ],
              ),
            ),
      floatingActionButton: const ExpandableFloatingActionButton(),
    );
  }
}
