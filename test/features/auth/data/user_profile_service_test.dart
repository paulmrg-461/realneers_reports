import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realneers_reports/features/auth/data/user_profile_service.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('UserProfileService', () {
    test('saveUserProfile throws when uid is empty', () async {
      final service = UserProfileService();
      expect(
        () => service.saveUserProfile(uid: '', name: 'John', email: 'john@example.com', dni: '12345678', phone: '999999999'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('buildProfileData trims and lowercases fields correctly', () async {
      final service = UserProfileService();
      final data = service.buildProfileData(
        name: ' John Doe ',
        email: ' JOHN@Example.COM ',
        dni: ' 12345678 ',
        phone: ' 999999999 ',
      );
      expect(data['name'], 'John Doe');
      expect(data['email'], 'john@example.com');
      expect(data['dni'], '12345678');
      expect(data['phone'], '999999999');
      expect(data.containsKey('createdAt'), true);
      expect(data.containsKey('updatedAt'), true);
    });
  });
}