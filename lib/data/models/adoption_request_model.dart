import 'package:cloud_firestore/cloud_firestore.dart';

class AdoptionRequestModel {
  final String requestId;
  final String postId;
  final String postOwnerId;
  final String requesterId;
  final String requesterName;
  final String petName;
  final String message;
  final DateTime requestDate;
  final String status; // 'pending', 'accepted', 'rejected'

  AdoptionRequestModel({
    required this.requestId,
    required this.postId,
    required this.postOwnerId,
    required this.requesterId,
    required this.requesterName,
    required this.petName,
    required this.message,
    required this.requestDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'postId': postId,
      'postOwnerId': postOwnerId,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'petName': petName,
      'message': message,
      'requestDate': requestDate,
      'status': status,
    };
  }

  factory AdoptionRequestModel.fromMap(Map<String, dynamic> map) {
    return AdoptionRequestModel(
      requestId: map['requestId'],
      postId: map['postId'],
      postOwnerId: map['postOwnerId'],
      requesterId: map['requesterId'],
      requesterName: map['requesterName'],
      petName: map['petName'],
      message: map['message'],
      requestDate: map['requestDate'].toDate(),
      status: map['status'],
    );
  }

  factory AdoptionRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return AdoptionRequestModel(
      requestId: doc.id,
      postId: data['postId'] ?? '',
      requesterId: data['requesterId'] ?? '',
      requesterName: data['requesterName'] ?? '',
      postOwnerId: data['postOwnerId'] ?? '',
      message: data['message'] ?? '',
      requestDate: (data['requestDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      petName: data['petName'] ?? '',
    );
  }
}