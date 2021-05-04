import 'package:cloud_firestore/cloud_firestore.dart';

class Posts{
  String description;
 String imageUrl;
 String id;
// DateTime createdAt;

 Posts({this.imageUrl,  this.description, this.id});


 factory Posts.fromJson(Map<String, dynamic> json, String docId){
   return Posts(
     description: json['description'],
     imageUrl: json['imageUrl'],
    id: docId,
    // createdAt: json['createdAt']
   );
 }


 Map<String, dynamic> toJson(){
   return {
     'description': description,
     'imageUrl': imageUrl,
    // 'createdAt': Timestamp.now()
   };
 }


}