import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/services/complete_profile_service.dart';
import 'package:pet_adoption/presentation/widgets/complete_profile_form_fields.dart';
import 'package:pet_adoption/presentation/screens/pre_home_screen.dart';

class ProfileCompletionScreen extends ConsumerWidget {
  const ProfileCompletionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController surnameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();    
    final TextEditingController favoritePetTypeController = TextEditingController();
    final TextEditingController favoriteBreedController = TextEditingController();

    void completeProfile() async {
      if (nameController.text.isEmpty ||
          surnameController.text.isEmpty ||
          addressController.text.isEmpty ||
          phoneController.text.isEmpty ||
          favoritePetTypeController.text.isEmpty ||
          favoriteBreedController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All fields must be filled out'),
          ),
        );
        return; 
      }
      await completeUserProfile(
        ref,
        nameController.text,
        surnameController.text,
        addressController.text,
        phoneController.text,
        favoritePetTypeController.text,
        favoriteBreedController.text
      );
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PreHomeScreen()),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ProfileFormFields(
              nameController: nameController,
              surnameController: surnameController,
              addressController: addressController,
              phoneController: phoneController,
              favoritePetTypeController: favoritePetTypeController,
              favoriteBreedController: favoriteBreedController,
            ),
          ),
          const SizedBox(height: 20),
            ElevatedButton(
              onPressed: completeProfile,
              child: const Text('Complete Profile'),
            ),
        ],
      ),      
    );
  }
}
