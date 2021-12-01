import 'dart:io';

import 'package:document_reviews/Controllers/document_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDocument extends StatefulWidget
{
  const AddDocument({Key?key}):super(key: key);

  State<AddDocument> createState()=> _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument>
{
  DocumentController _documentController=Get.put(DocumentController());
  final TextEditingController titleController=TextEditingController();
  final TextEditingController descController=TextEditingController();
  late File _file;
  String dropdownvalue = 'Article';
  var options =  ['Article','Story','Report','Other'];


  @override
  Widget build(BuildContext context)
  {
    bool loading=true;
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Add Document'),),),
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
                    TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: "Title",
                          hintStyle:TextStyle(color: Colors.grey.shade500) ,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      controller: titleController,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: "Description",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      controller: descController,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    DropdownButton(
                      value: dropdownvalue,
                      icon: Icon(Icons.keyboard_arrow_down),
                      items:options.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Text(items)
                        );
                      }
                      ).toList(),
                      onChanged: (String? newValue){
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
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
                          _documentController.uploadFile(titleController.text.trim(),descController.text.trim(),dropdownvalue);
                          titleController.clear();
                          descController.clear();
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