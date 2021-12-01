import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:document_reviews/Constants/constant.dart';
import 'package:document_reviews/Controllers/document_controller.dart';
import 'package:document_reviews/document_model.dart';
import 'package:document_reviews/firestore_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';


class DocumentViewer extends StatefulWidget
{
  const DocumentViewer({Key?key}):super(key: key);

  State<DocumentViewer> createState()=> _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer>
{
  var rating;
  bool isChecked = false;
  DocumentController _documentController=Get.put(DocumentController());
  bool _isLoading = true;
  late PDFDocument document;
   List<DocumentModel> one=Get.arguments;
   TextEditingController feedbackController=TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDocument(one[0].url);
  }

  loadDocument(String url) async {
    document = await PDFDocument.fromURL(url);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
      appBar: AppBar(title: Text('Document Review'),centerTitle: true,),
      body:SingleChildScrollView(
        child:Column(
          children: [
            Container(
                padding: EdgeInsets.all(10),
              child:Wrap(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child:Text('Title:  '+one[0].title,style: TextStyle(fontSize: 16),),
                    //child:Text('Description:  '+one[0].description,style: TextStyle(fontSize: 16)) ,
                  )
                ],
              )
            ),
            Container(padding: EdgeInsets.all(10),
              child: Wrap(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child:Text('Description:  '+one[0].description,style: TextStyle(fontSize: 16)),
                    //child:Text('Description:  '+one[0].description,style: TextStyle(fontSize: 16)) ,
                  )
                ],
              )
              ),
            Container(padding: EdgeInsets.all(10),
              child: Wrap(
                  children:[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Status:  '+one[0].status,style: TextStyle(fontSize: 16)),
                    )
                  ]
              ),
            ),
            Container(padding: EdgeInsets.all(10),
              child: Wrap(
                children:[
                  Align(
                    alignment: Alignment.centerLeft,
                    child:Text('Category:  '+one[0].category,style: TextStyle(fontSize: 16)),
                  )
                ]
              ),
            ),
            if(!one[0].feedback.isEmpty)
              Container(padding: EdgeInsets.all(10),
                child: Wrap(
                    children:[
                      Align(
                        alignment: Alignment.centerLeft,
                        child:Text('Feedback:  '+one[0].feedback,style: TextStyle(fontSize: 16)),
                      )
                    ]
                ),
              ),
            if(!one[0].rating.isEmpty)
              Container(padding: EdgeInsets.all(10),
                child: Wrap(
                    children:[
                      Align(
                        alignment: Alignment.centerLeft,
                        child:Text('Rating:  '+one[0].rating,style: TextStyle(fontSize: 16)),
                      )
                    ]
                ),
              ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 800,
                child: _isLoading ? Center(child: CircularProgressIndicator()) : PDFViewer( document: document,
                  zoomSteps: 1,)),
            if(one[0].feedback.isEmpty)
            addExtraWidget(),
          ],
        ) ,
      )
    );

  }

  Widget addExtraWidget()
  {

    if(auth.currentUser!.uid!=one[0].userId)
      {
        return Container(
            padding: EdgeInsets.all(10),
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(Colors.blue.shade500),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  Text("need Ammendments")
                ],
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                minLines: 2,
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: "Feedback",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                controller: feedbackController,
              ),
              SizedBox(height: 10,),
              RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
               itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (r) {
                //print(rating);
                rating=r;
              },
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
                    if(feedbackController.text.isEmpty)
                      {
                        Fluttertoast.showToast(
                            msg: "please enter a feedback!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                    else if(rating==null || rating<1)
                      {
                        Fluttertoast.showToast(
                            msg: "please provide rating!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                    else
                      {
                        _documentController.updateDocument(one[0].documentId.toString(), feedbackController.text.trim(),isChecked,rating);
                        feedbackController.clear();
                        Get.back();
                      }
                  },
                  child: Text('Submit Feedback')),
          ],
        ),    
        );
      }
    else
      return Container(
        child: Text(''),
      );

  }

}