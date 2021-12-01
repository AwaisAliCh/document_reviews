import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentModel
{
  String? documentId;
  late String title;
  late String description;
  late String url;
  late String category;
  late String userId;
  late String date;
  late String status;
  late String feedback;
  late String rating;

  DocumentModel({required this.title,required this.description,required this.category});

  DocumentModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    documentId = documentSnapshot.id;
    title = documentSnapshot["title"];
    description = documentSnapshot["desc"];
    url = documentSnapshot["url"];
    category = documentSnapshot["category"];
    userId=documentSnapshot["userid"];
    date=documentSnapshot["createdon"];
    status=documentSnapshot["status"];
    feedback=documentSnapshot["feedback"];
    rating=documentSnapshot["rating"];
  }
}