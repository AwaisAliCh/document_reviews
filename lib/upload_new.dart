import 'dart:io';

import 'package:document_reviews/Constants/constant.dart';
import 'package:document_reviews/Controllers/document_controller.dart';
import 'package:document_reviews/document_model.dart';
import 'package:document_reviews/firestore_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AddNewDocument extends StatefulWidget
{
  const AddNewDocument({Key?key}):super(key: key);

  State<AddNewDocument> createState()=> _AddNewDocumentState();
}

class _AddNewDocumentState extends State<AddNewDocument>
{
  DocumentController _documentController=Get.put(DocumentController());
  List<DocumentModel> one=Get.arguments;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Add new version'),),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top:30),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 35, right: 35),
                child: Column(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(1),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                          backgroundColor: MaterialStateProperty.all(Colors.blue.shade300),
                          //shadowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSurface)
                        ),
                        onPressed: ()  {
                          _documentController.getPdfFile();
                        },
                        child: Text('choose document')),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(1),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                          backgroundColor: MaterialStateProperty.all(Colors.blue.shade300),
                          //shadowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSurface)
                        ),
                        onPressed: (){
                          _documentController.uploadNewFile(one);
                        },
                        child: Text('Upload')),
                  ],
                ),
              )
            ],
          ),
        ),
      ) ,
    );

  }

}