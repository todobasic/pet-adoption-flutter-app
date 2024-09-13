class PetPostModel {
  final String postId;
  final String userId;
  final String name;
  final String breed;
  final String type;
  final double weight;
  final int age;
  final String imageUrl;
  final bool isAdopted;
  final String petAddress;

  PetPostModel({
    required this.postId,
    required this.userId,
    required this.name,
    required this.breed,
    required this.type,
    required this.weight,
    required this.age,
    required this.imageUrl,
    this.isAdopted = false,
    required this.petAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'name': name,
      'breed': breed,
      'type': type,
      'weight': weight,
      'age': age,
      'imageUrl': imageUrl,
      'isAdopted': isAdopted,
      'petAddress': petAddress,
    };
  }

  factory PetPostModel.fromMap(Map<String, dynamic> map) {
    return PetPostModel(
      postId: map['postId'],
      userId: map['userId'],
      name: map['name'],
      breed: map['breed'],
      type: map['type'],
      weight: map['weight'],
      age: map['age'],
      imageUrl: map['imageUrl'],
      isAdopted: map['isAdopted'] ?? false,
      petAddress: map['petAddress'],
    );
  }
}