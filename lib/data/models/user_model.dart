import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? surname;
  final String address;
  final String? phone;
  final bool profileComplete;
  final String? favoritePetType;
  final String? favoriteBreed;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.surname,
    required this.address,
    this.phone,
    this.profileComplete = false,
    this.favoritePetType,
    this.favoriteBreed,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'],
      surname: data['surname'],
      address: data['address'],
      phone: data['phone'],
      profileComplete: data['profileComplete'] ?? false,
      favoritePetType: data['favoritePetType'],
      favoriteBreed: data['favoriteBreed'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'surname': surname,
      'address': address,
      'phone': phone,
      'profileComplete': profileComplete,
      'favoritePetType': favoritePetType,
      'favoriteBreed': favoriteBreed,
    };
  }
}