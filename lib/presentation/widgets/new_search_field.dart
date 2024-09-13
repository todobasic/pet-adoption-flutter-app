import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/presentation/providers/ui_state_providers.dart';

class NewSearchField extends ConsumerWidget {
  final TextEditingController controller;

  const NewSearchField({required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        onChanged: (value) => ref.read(newSearchQueryProvider.notifier).state = value,
        decoration: InputDecoration(
          hintText: 'Search by address...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
