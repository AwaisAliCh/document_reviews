import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_reviews/Controllers/auth_controller.dart';
import 'package:document_reviews/Controllers/document_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

AuthController authController = AuthController.instance;
DocumentController documentController=DocumentController.instance;
final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;