import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/presentation/widgets/custom_drawer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController favoritePetTypeController = TextEditingController();
  final TextEditingController favoriteBreedController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          nameController.text = data['name'] ?? '';
          emailController.text = data['email'] ?? '';
          surnameController.text = data['surname'] ?? '';
          addressController.text = data['address'] ?? '';
          phoneController.text = data['phone'] ?? '';
          favoritePetTypeController.text = data['favoritePetType'] ?? '';
          favoriteBreedController.text = data['favoriteBreed'] ?? '';
        }
      }
    }
  }

  void _updateProfile() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': nameController.text,
        'email': emailController.text,
        'surname': surnameController.text,
        'address': addressController.text,
        'phone': phoneController.text,
        'favoritePetType': favoritePetTypeController.text,
        'favoriteBreed': favoriteBreedController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                enabled: isEditing,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                enabled: isEditing,
              ),
              TextField(
                controller: surnameController,
                decoration: const InputDecoration(labelText: 'Surname'),
                enabled: isEditing,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                enabled: isEditing,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                enabled: isEditing,
              ),
              TextField(
                controller: favoritePetTypeController,
                decoration: const InputDecoration(labelText: 'Favorite Pet Type'),
                enabled: isEditing,
              ),
              TextField(
                controller: favoriteBreedController,
                decoration: const InputDecoration(labelText: 'Favorite Pet Breed'),
                enabled: isEditing,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (isEditing) {
                      _updateProfile();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated')),
                      );
                    }
                    isEditing = !isEditing;
                  });
                },
                child: Text(isEditing ? 'Save Changes' : 'Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
