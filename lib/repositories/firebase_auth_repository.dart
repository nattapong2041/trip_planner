import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart' as app_user;
import 'auth_repository.dart';

/// Firebase implementation of AuthRepository
class FirebaseAuthRepository implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  @override
  Stream<app_user.User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_firebaseUserToAppUser);
  }

  @override
  app_user.User? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    return _firebaseUserToAppUser(firebaseUser);
  }

  @override
  Future<app_user.User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web implementation
        return await _signInWithGoogleWeb();
      } else {
        // Mobile implementation
        return await _signInWithGoogleMobile();
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  /// Google Sign-In implementation for mobile platforms
  Future<app_user.User?> _signInWithGoogleMobile() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();
    
    if (googleUser == null) {
      // User cancelled the sign-in
      throw Exception('Google sign-in was cancelled');
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create a new credential
    final credential = firebase_auth.GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return _firebaseUserToAppUser(userCredential.user);
  }

  /// Google Sign-In implementation for web platform
  Future<app_user.User?> _signInWithGoogleWeb() async {
    // Create a new provider
    firebase_auth.GoogleAuthProvider googleProvider = firebase_auth.GoogleAuthProvider();

    googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
    googleProvider.addScope('https://www.googleapis.com/auth/userinfo.profile');

    // Once signed in, return the UserCredential
    final userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
    return _firebaseUserToAppUser(userCredential.user);
  }

  @override
  Future<app_user.User?> signInWithApple() async {
    try {
      // Check if Apple Sign In is available on this platform
      if (!await SignInWithApple.isAvailable()) {
        throw Exception('Apple Sign In is not available on this platform');
      }

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an `OAuthCredential` from the credential returned by Apple
      final oauthCredential =
          firebase_auth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      return _firebaseUserToAppUser(userCredential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } on SignInWithAppleException catch (e) {
      throw Exception('Apple sign-in failed: ${e.toString()}');
    } catch (e) {
      throw Exception('Apple sign-in failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Sign out from Google Sign-In if not on web
      if (!kIsWeb) {
        await _firebaseAuth.signOut();
      }
      
      // Sign out from Firebase
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Convert Firebase User to app User model
  app_user.User? _firebaseUserToAppUser(firebase_auth.User? firebaseUser) {
    if (firebaseUser == null) return null;

    return app_user.User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? 'Unknown User',
      photoUrl: firebaseUser.photoURL,
    );
  }

  /// Handle Firebase Auth exceptions and convert to meaningful error messages
  Exception _handleFirebaseAuthException(
      firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return Exception(
            'An account already exists with a different sign-in method.');
      case 'invalid-credential':
        return Exception('The credential is invalid or has expired.');
      case 'operation-not-allowed':
        return Exception('This sign-in method is not enabled.');
      case 'user-disabled':
        return Exception('This user account has been disabled.');
      case 'user-not-found':
        return Exception('No user found with this credential.');
      case 'wrong-password':
        return Exception('Wrong password provided.');
      case 'invalid-verification-code':
        return Exception('Invalid verification code.');
      case 'invalid-verification-id':
        return Exception('Invalid verification ID.');
      case 'network-request-failed':
        return Exception('Network error. Please check your connection.');
      case 'too-many-requests':
        return Exception('Too many requests. Please try again later.');
      case 'popup-closed-by-user':
        return Exception('Sign-in was cancelled.');
      case 'popup-blocked':
        return Exception('Sign-in popup was blocked. Please allow popups and try again.');
      default:
        return Exception('Authentication failed: ${e.message}');
    }
  }
}
