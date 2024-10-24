import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    this.email,
    this.name,
    this.photoURL,
    this.emailVerified = false,
    this.phoneNumber,
    this.createdAt,
  });

  final String uid;
  final String? email;
  final bool emailVerified;
  final String? name;
  final String? photoURL;
  final String? phoneNumber;
  final Timestamp? createdAt;

  static const empty = UserModel(uid: '');

  bool get isEmpty => uid.isEmpty;

  bool get isNotEmpty => uid.isNotEmpty;

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final Map<String, dynamic>? map = snapshot.data();
    return map != null ? UserModel.fromMap(map) : UserModel.empty;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      emailVerified: map['emailVerified'],
      photoURL: map['photoURL'],
      phoneNumber: map['phoneNumber'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'emailVerified': emailVerified,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [uid, email, name, photoURL];
}
