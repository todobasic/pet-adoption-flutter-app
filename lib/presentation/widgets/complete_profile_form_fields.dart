// lib/presentation/widgets/profile_form_fields.dart

import 'package:flutter/material.dart';

class ProfileFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController favoritePetTypeController;
  final TextEditingController favoriteBreedController;

  const ProfileFormFields({
    Key? key,
    required this.nameController,
    required this.surnameController,
    required this.addressController,
    required this.phoneController,
    required this.favoritePetTypeController,
    required this.favoriteBreedController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Please, complete your profile'),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: surnameController,
          decoration: const InputDecoration(labelText: 'Surname'),
        ),
        TextField(
          controller: addressController,
          decoration: const InputDecoration(labelText: 'Address'),
        ),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(labelText: 'Phone number'),
        ),
        // New fields for adoption tendencies
        TextField(
          controller: favoritePetTypeController,
          decoration: const InputDecoration(labelText: 'Favorite Pet Type'),
        ),
        TextField(
          controller: favoriteBreedController,
          decoration: const InputDecoration(labelText: 'Favorite Breed'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
