import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';

class PetPostRepository {
  final FirebaseFirestore _firestore;

  PetPostRepository(this._firestore);  

  Future<void> createPetPost(PetPostModel petPost) async {
    final postDoc = _firestore.collection('pet_posts').doc(petPost.postId);
    await postDoc.set(petPost.toMap());
  }

  Stream<List<PetPostModel>> getPetPosts() {
    return _firestore.collection('pet_posts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PetPostModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<void> updatePetPostStatus(String postId) async {
    final postDoc = _firestore.collection('pet_posts').doc(postId);
    await postDoc.update({'isAdopted': true});
  }  

}