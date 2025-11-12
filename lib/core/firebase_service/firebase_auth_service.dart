import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password,
    String name,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user != null) {
      // Обновляем displayName
      await user.updateDisplayName(name);
      await Future.delayed(const Duration(milliseconds: 500));
      // ВАЖНО: Перезагружаем пользователя, чтобы получить обновленные данные
      await user.reload();

      // Получаем обновленного пользователя
      final updatedUser = _auth.currentUser;

      print('Updated user displayName: ${updatedUser?.displayName}');

      // Сохраняем в Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'role': 'user',
        'avatarUrl': 'https://i.pravatar.cc/150?img=7',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  Future<void> signOut() async => _auth.signOut();

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
