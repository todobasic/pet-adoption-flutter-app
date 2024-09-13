import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/data/services/post_submit_service.dart';
import 'package:pet_adoption/presentation/controllers/post_form_controller.dart';
import 'package:pet_adoption/presentation/screens/pre_home_screen.dart';
import 'package:pet_adoption/utils/image_picker_helper.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() {
    return _CreatePostScreenState();
  }
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final formController = PostFormController();
  final postSubmissionService = PostSubmitService();
  final ImagePickerHelper imagePickerHelper = ImagePickerHelper();  

  void _pickImage() async {
    final image = await imagePickerHelper.pickImageFromGallery();
    if (image != null) {
      setState(() {
        formController.image = image;
      });
    }
  }

  @override
  void dispose() {
    formController.dispose();
    super.dispose();
  }

  void _clearForm() {
    formController.clearInputs();
  }

  void _submitPost() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user !=null && formController.validateInputs()) {
      showDialog(
        context: context, 
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: const Text(
              'Are you sure you want to submit these details?'
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.amber),
                ),
                onPressed: () {
                  _clearForm();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.amber),
                ),
                onPressed: () async {
                  final downloadUrl = await postSubmissionService.uploadImage(formController.image!);
                  final postId = FirebaseFirestore.instance.collection('pet_posts').doc().id;

                  final petPost = PetPostModel(
                    postId: postId,
                    userId: user.uid,
                    name: formController.nameController.text,
                    breed: formController.breedController.text.trim(),
                    type: formController.typeController.text.trim(),
                    weight: double.parse(formController.weightController.text),
                    age: int.parse(formController.ageController.text),
                    imageUrl: downloadUrl,
                    petAddress: formController.locationController.text,
                  );

                  await postSubmissionService.submitPost(petPost);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const PreHomeScreen())
                    );
                  }
                  _clearForm();
                },
              ),
            ],
          );
    });} else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill in all the requested fields.'),
        ));
    }       
  }  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Pet Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Center(
                        child: formController.image == null 
                        ? const Text('No image selected') 
                        : Image.file(
                          formController.image!,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ElevatedButton( 
                             onPressed: () async { 
                               _pickImage();
                             }, 
                             child: const Text('Select image'),
                            ),
                  ],
                ),
                TextField(controller: formController.nameController, decoration:  const InputDecoration(labelText: 'Name')),
                TextField(controller: formController.breedController, decoration:  const InputDecoration(labelText: 'Breed')),
                TextField(controller: formController.typeController, decoration:  const InputDecoration(labelText: 'Pet type')),
                TextField(controller: formController.weightController, decoration:  const InputDecoration(labelText: 'Weight')),
                TextField(controller: formController.ageController, decoration:  const InputDecoration(labelText: 'Age')),
                TextField(controller: formController.locationController, decoration: const InputDecoration(labelText: 'Pet Location')),
                ElevatedButton(
                  onPressed: _submitPost, 
                  child: const Text('Submit Post'),
                ),
              ],
            ),
          );
          }
        ),
      ),
    );
  }
}