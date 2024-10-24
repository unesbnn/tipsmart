import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../commons/utils.dart';
import '../../services/app_exceptions.dart';
import '../models/user_model.dart';

class AuthenticationRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  UserModel currentUser = UserModel.empty;

  Stream<UserModel> get getUser {
    return FirebaseFirestore.instance
        .collection('Users')
        .withConverter(
          fromFirestore: (snap, _) => UserModel.fromFirestore(snap),
          toFirestore: (user, _) => user.toJson(),
        )
        .doc(currentUser.uid)
        .snapshots()
        .map((event) {
      final user = event.data();
      return user ?? UserModel.empty;
    });
  }

  Stream<UserModel> get user {
    if (currentUser.isEmpty) {
      return _firebaseAuth.authStateChanges().map((firebaseUser) {
        final user = firebaseUser == null
            ? UserModel.empty
            : UserModel(
                uid: firebaseUser.uid,
                name: firebaseUser.displayName,
                email: firebaseUser.email,
                photoURL: firebaseUser.photoURL,
              );

        currentUser = user;
        return currentUser;
      });
    } else {
      return getUser;
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      throw AppException.signInFailure(e.code);
    } catch (e) {
      throw const AppException();
    }
  }

  Future<void> verifyUserEmail() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      printMessage('Code: ${e.code} - Message: ${e.message}', tag: 'AppAuthentication');
      throw AppException.signInWithGoogleFailure(e.code);
    } catch (e) {
      printMessage('$e', tag: 'AppAuthentication');
      throw const AppException();
    }
  }

  Future<void> signUpWithEmailEndPassword({
    required String? name,
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        if (user.displayName == null) {
          await user.updateDisplayName(name);
          await user.reload();
        }
        if (name != null) {
          await Future.delayed(
            const Duration(seconds: 1),
            () {
              FirebaseFirestore.instance.collection('Users').doc(user.uid).update(
                {'name': name},
              ).onError(
                (error, stackTrace) {
                  printMessage('Error updating user name $error', tag: 'USER_UPDATED');
                  return null;
                },
              );
            },
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      throw AppException.signUpFailure(e.code);
    } catch (_) {
      throw const AppException();
    }
  }

  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw AppException.signUpFailure(e.code);
    } catch (_) {
      throw const AppException();
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AppException.logOutFailure(e.code);
    } catch (e) {
      printMessage(e.toString());
      throw AppException.logOutFailure('');
    }
  }

  Future<void> deleteAccount() async {
    try {
      // await _deleteUser();
      await _firebaseAuth.currentUser?.delete();
    } catch (e) {
      printMessage(e.toString());
      throw const AppException('Account deletion failed');
    }
  }
}
