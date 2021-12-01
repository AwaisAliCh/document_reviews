import 'dart:io';
import 'package:document_reviews/Constants/constant.dart';
import 'package:document_reviews/document_model.dart';
import 'package:document_reviews/firestore_db.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class DocumentController extends GetxController
{
  static DocumentController instance = Get.find();
  late File file;
  Rx<List<DocumentModel>> documentList = Rx<List<DocumentModel>>([]);
  List<DocumentModel> get documents => documentList.value;

  Rx<List<DocumentModel>> allDocumentList = Rx<List<DocumentModel>>([]);
  List<DocumentModel> get allDocuments => allDocumentList.value;

  @override
  void onReady() {
    documentList.bindStream(FirestoreDb.documentStream());
    allDocumentList.bindStream(FirestoreDb.allDocumentStream());
  }


  Future getPdfFile()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf']);

    if (result != null) {
      // Uint8List fileBytes = result.files.first.bytes;
      file = File(result.files.single.path.toString());
     // fileName = result.files.first.name;
    }
  }

  Future uploadFile(String fileName,desc,category) async
  {
    if(fileName.isEmpty)
      {
        Get.snackbar(
          "Error",
          "plaese enter title",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    else if(desc.isEmpty)
      {
        Get.snackbar(
          "Error",
          "please enter description",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    else if(file.path.isEmpty)
      {
        Get.snackbar(
          "Error",
          "please choose a file to upload",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    else{
      EasyLoading.show();
      // Upload file
      DateTime now = DateTime.now();
      String convertedDateTime = "${now.day.toString()}/${now.month.toString()}/${now.year.toString()}";

      await FirebaseStorage.instance.ref('Documents/'+authController.firebaseUser.value!.uid+'/$fileName').putFile(file)
          .then((taskSnapshot) {
        if (taskSnapshot.state == TaskState.success) {
          FirebaseStorage.instance
              .ref('Documents/'+authController.firebaseUser.value!.uid+'/$fileName')
              .getDownloadURL()
              .then((url) {
            firebaseFirestore
                .collection('Documents')
                .add({
              'userid':auth.currentUser!.uid,
              'title': fileName,
              'category':category,
              'desc':desc,
              'url':url,
              'createdon': convertedDateTime,
              'status': "Uploaded",
              'feedback':"",
              'rating':""
            });
          }).catchError((onError) {
            print("Got Error $onError");
            Get.snackbar(
              "Error",
              onError.toString(),
              snackPosition: SnackPosition.BOTTOM,
            );
          });
        }
      });
      EasyLoading.dismiss();
    }
  }

  Future uploadNewFile(List<DocumentModel> docment) async
  {
    EasyLoading.show();
      // Upload file
      DateTime now = DateTime.now();
      String convertedDateTime = "${now.day.toString()}/${now.month.toString()}/${now.year.toString()}";

      await FirebaseStorage.instance.ref('Documents/'+authController.firebaseUser.value!.uid+'/'+docment[0].title+'v2').putFile(file)
          .then((taskSnapshot) {
        if (taskSnapshot.state == TaskState.success) {
          FirebaseStorage.instance
              .ref('Documents/'+authController.firebaseUser.value!.uid+'/'+docment[0].title+'v2')
              .getDownloadURL()
              .then((url) {
            firebaseFirestore
                .collection('Documents').doc(docment[0].documentId)
                .update({
              'url':url,
              'createdon': convertedDateTime,
              'status': "Revised",
            });
          }).catchError((onError) {
            print("Got Error $onError");
            Get.snackbar(
              "Error",
              onError.toString(),
              snackPosition: SnackPosition.BOTTOM,
            );
          });
        }
      });
      EasyLoading.dismiss();
  }
  Future updateDocument(String id,feedback,bool status,double rating) async
  {
    String stat;
    if(status)
      {
        stat='amendments';
      }
    else
      {
        stat='passed';
      }
    EasyLoading.show();

    await firebaseFirestore
        .collection('Documents')
        .doc(id)
        .update({
      'feedback': feedback,
      'status':stat,
      'rating':rating.toString()
     }
    );
    EasyLoading.dismiss();
  }
}