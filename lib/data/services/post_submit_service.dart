import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:pet_adoption/data/models/pet_post_model.dart';

class PostSubmitService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image) async {
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = storage.ref().child('pet_images/$imageName.jpg');
    final uploadTask = storageRef.putFile(image);
    return await (await uploadTask).ref.getDownloadURL();
  }

  Future<void> submitPost(PetPostModel petPost) async {
    await firestore.collection('pet_posts').doc(petPost.postId).set(petPost.toMap());
  }
}
