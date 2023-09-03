import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebaseProviders = Provider((ref) => FirebaseFirestore.instance);
final authProviders = Provider((ref) => FirebaseAuth.instance);
final storageProviders = Provider((ref) => FirebaseStorage.instance);
final googleSignInProviders = Provider((ref) => GoogleSignIn());
