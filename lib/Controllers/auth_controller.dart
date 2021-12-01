import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_reviews/Constants/constant.dart';
import 'package:document_reviews/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../home.dart';
import '../register.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;

 // late Rx<GoogleSignInAccount?> googleSignInAccount;

  @override
  void onReady() {
    super.onReady();
    // auth is comning from the constants.dart file but it is basically FirebaseAuth.instance.
    // Since we have to use that many times I just made a constant file and declared there

    firebaseUser = Rx<User?>(auth.currentUser);


    firebaseUser.bindStream(auth.userChanges());
  //  ever(firebaseUser, _setInitialScreen);

  }

  _setInitialScreen(User? user) {
    if (user == null) {

      // if the user is not found then the user is navigated to the Register Screen
      Get.offAll(() =>  Login());

    } else {

      // if the user exists and logged in the the user is navigated to the Home Screen
      Get.offAll(() => Home());

    }
  }

  void register(String email, password, name) async {
    EasyLoading.show();
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final CollectionReference userReference=firebaseFirestore.collection('Users');
      userReference.doc(firebaseUser.value!.uid).set({
        'name':name,
        'email':email,
      });
    } catch (firebaseAuthException) {
      Get.snackbar(
        "Error",
        firebaseAuthException.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    EasyLoading.dismiss();
  }

  void login(String email, password) async {
    EasyLoading.show();
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password).whenComplete(() =>
        {
          if(auth.currentUser!=null)
          {
            Get.to(Home()),
            EasyLoading.dismiss()
          }
        }
      );
    } catch (firebaseAuthException) {
      Get.snackbar(
        "Error",
        firebaseAuthException.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      EasyLoading.dismiss();
    }

  }

  void signOut() async {
    await auth.signOut();
    Get.offAll(()=>Login());
  }

  Future getPdfAndUpload()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf']);

    if (result != null) {
     // Uint8List fileBytes = result.files.first.bytes;
      File file = File(result.files.single.path.toString());
      String fileName = result.files.first.name;

      // Upload file
      await FirebaseStorage.instance.ref('uploads/$fileName').putFile(file);
    }
  }
}
