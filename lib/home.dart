import 'package:document_reviews/Controllers/auth_controller.dart';
import 'package:document_reviews/Controllers/document_controller.dart';
import 'package:document_reviews/add_document.dart';
import 'package:document_reviews/document_viewer.dart';
import 'package:document_reviews/upload_new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Constants/constant.dart';

class Home extends StatefulWidget
{
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
{
  DocumentController documentController=Get.put(DocumentController());
  AuthController authController=Get.put(AuthController());
  String btnText='View';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: Scaffold(
          appBar: AppBar(title:const Text('Document Reviews',),
           centerTitle: true,
           bottom: TabBar(
            tabs: [
              Text('My Docs'),
              Text('Others')
            ],
          ),
          ),
          drawer:Drawer(
            child:ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                 DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child:Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(auth.currentUser!.email.toString()),
                  ),
                ),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () {
                    authController.signOut();
                  },
                ),
                ListTile(
                  title: const Text('Add Document'),
                  onTap: () {
                    Get.back();
                    Get.to(AddDocument());
                  },
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              GetX<DocumentController>(
                init: Get.put<DocumentController>(DocumentController()),
                builder: (DocumentController docController)
                {
                  return ListView.builder(
                      itemCount: docController.documents.length,
                      itemBuilder:(BuildContext context,int index)
                      {
                        return Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                print('Card tapped.');
                              },
                              child:Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(docController.documents[index].title,style: TextStyle(fontSize: 18),),
                                        ElevatedButton(onPressed:() {
                                          if(documentController.documents[index].status=='amendments')
                                            {
                                              Get.to(AddNewDocument(), arguments: [docController.documents[index]]);
                                            }
                                          else
                                            {
                                              Get.to(DocumentViewer(), arguments: [docController.documents[index]]);
                                            }
                                        },
                                          child:documentController.documents[index].status=='amendments'? Text('Upload new'):Text('View'),style: ButtonStyle(
                                            elevation: MaterialStateProperty.all(1),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                            backgroundColor: MaterialStateProperty.all(Colors.blue.shade300),
                                            //shadowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSurface)
                                            ),)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(docController.documents[index].date,style: TextStyle(color: Colors.grey.shade600,fontSize: 15),),
                                        Text(docController.documents[index].status,style: TextStyle(color: Colors.grey.shade800,fontSize: 16))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ));
                      }
                  );
                },
              ),
              GetX<DocumentController>(
                init: Get.put<DocumentController>(DocumentController()),
                builder: (DocumentController docController)
                {
                  return ListView.builder(
                      itemCount: docController.allDocuments.length,
                      itemBuilder:(BuildContext context,int index)
                      {
                        return Card(
                            child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {
                                  print('Card tapped.');
                                },
                                child:Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(docController.allDocuments[index].title,style: TextStyle(fontSize: 18),),
                                          ElevatedButton(onPressed:() {
                                            Get.to(DocumentViewer(), arguments: [docController.allDocuments[index]]);
                                          },
                                            child: Text('View'),style: ButtonStyle(
                                              elevation: MaterialStateProperty.all(1),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                              backgroundColor: MaterialStateProperty.all(Colors.blue.shade300),
                                              //shadowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSurface)
                                            ),)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(docController.allDocuments[index].date,style: TextStyle(color: Colors.grey.shade600,fontSize: 15),),
                                          Text(docController.allDocuments[index].status,style: TextStyle(color: Colors.grey.shade800,fontSize: 16))
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ));
                      }
                  );
                },
              ),
            ],
          ),
        ));
  }


}