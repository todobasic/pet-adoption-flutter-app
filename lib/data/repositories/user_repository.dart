import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_adoption/data/models/user_model.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  
  UserRepository(this._firestore);

  Stream<UserModel?> userStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  Future<void> createUserProfile(String uid) async {
  final firestore = FirebaseFirestore.instance;
  final userDoc = firestore.collection('users').doc(uid);

  final userSnapshot = await userDoc.get();

  if (!userSnapshot.exists) {    
    await userDoc.set({
      'profileComplete': false,      
    });
  }
}

  Future<UserModel?> fetchCurrentUser() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          return UserModel(
            uid: user.uid,
            name: userData['name'],
            surname: userData['surname'],
            email: userData['email'],
            address: userData['address'],
            phone: userData['phone'],
          );
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    } else {
      return null;
    }
  }  

  Future<void> updateUserProfile(UserModel userModel) async {
    await _firestore.collection('users').doc(userModel.uid).update(userModel.toFirestore());
  }

  Future<bool> isProfileComplete(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists && doc.data()?['profileComplete'] == true;
  }

  Future<void> completeUserProfile(
    String uid, String? email, String name, String surname, String address, 
    String phone, String favoritePetType, String favoriteBreed) 
    async {
    await _firestore.collection('users').doc(uid).update({
      'name': name,
      'email': email,
      'surname': surname,
      'address': address,
      'phone': phone,
      'favoritePetType': favoritePetType,
      'favoriteBreed': favoriteBreed,
      'profileComplete': true,
    });
  }

  Future<bool> hasUserLikedPost(String postId, String userId) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('likes')
      .where('userId', isEqualTo: userId)
      .where('postId', isEqualTo: postId)
      .limit(1)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

  Future<void> likePost(String postId, String userId) async {
    await FirebaseFirestore.instance.collection('likes').add({
      'userId': userId,
      'postId': postId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unlikePost(String postId, String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('likes')
        .where('userId', isEqualTo: userId)
        .where('postId', isEqualTo: postId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.delete();
    }
  }
  
}


