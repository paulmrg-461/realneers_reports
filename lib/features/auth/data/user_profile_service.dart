import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  final FirebaseFirestore? firestore;
  UserProfileService({this.firestore});

  Map<String, dynamic> buildProfileData({
    required String name,
    required String email,
    required String dni,
    required String phone,
  }) {
    return {
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'dni': dni.trim(),
      'phone': phone.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Future<void> saveUserProfile({required String uid, required String name, required String email, required String dni, required String phone}) async {
    final safeUid = uid.trim();
    if (safeUid.isEmpty) {
      throw ArgumentError('uid is required');
    }
    final userDoc = (firestore ?? FirebaseFirestore.instance).collection('users').doc(safeUid);
    await userDoc.set(
      buildProfileData(name: name, email: email, dni: dni, phone: phone),
      SetOptions(merge: true),
    );
  }
}