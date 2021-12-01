import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_reviews/document_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'Constants/constant.dart';

class FirestoreDb
{
  //late File file;
  static Stream<List<DocumentModel>> documentStream() {
   // EasyLoading.show();
     return firebaseFirestore
        .collection('Documents')
        .snapshots()
        .map((QuerySnapshot query) {
      List<DocumentModel> todos = [];
      for (var todo in query.docs) {
        final documentModel =
        DocumentModel.fromDocumentSnapshot(documentSnapshot: todo);
        if(documentModel.userId==auth.currentUser!.uid)
          {
            todos.add(documentModel);
          }
       // EasyLoading.dismiss();
      }
      return todos;
    });

  }
  static Stream<List<DocumentModel>> allDocumentStream() {
    return firebaseFirestore
        .collection('Documents')
        .snapshots()
        .map((QuerySnapshot query) {
      List<DocumentModel> todos = [];
      for (var todo in query.docs) {
        final documentModel =
        DocumentModel.fromDocumentSnapshot(documentSnapshot: todo);
        if(documentModel.userId!=auth.currentUser!.uid)
        {
          todos.add(documentModel);
        }
        // EasyLoading.dismiss();
      }
      return todos;
    });
  }
}