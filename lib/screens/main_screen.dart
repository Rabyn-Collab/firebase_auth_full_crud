import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_models/auth_provider/auth_model_provider.dart';
import 'package:flutter_app_models/database_provider/db_provider.dart';
import 'package:flutter_app_models/models/user_posts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final posts = watch(dataProvider) ;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white
              ),
              onPressed: (){
                context.read(authProvider).logOut();
              }, child: Text('Log Out'))
        ],
      ),
      body: posts.when(data: (data) => data.isEmpty ? Center(child: Text('Nothing to Show It\'s empty here'),) :  ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) => ListTile(
          onTap: (){
            // showDialog(context: context, builder: (context) => ShowForm(posts: data[index],));
          },
          title: Text(data[index].imageUrl),
          subtitle: Text(data[index].description),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              // context.read(dbProvider).removeData(data[index].id);
            },
          ),
        ),
      ),
          loading: () => Center(child: Text('hello'),),
          error: (err, stack) => Center(child: Text('$err'))
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(context: context, builder: (context) => ShowForm());
        },
      ),
    );
  }
}

class ShowForm extends StatefulWidget {

  final Posts posts;
  ShowForm({this.posts});

  @override
  _ShowFormState createState() => _ShowFormState();
}

class _ShowFormState extends State<ShowForm> {
  final user = FirebaseAuth.instance.currentUser.uid;
  String description;
  String imageUrl;

  final _form = GlobalKey<FormState>();
  @override
  void initState() {
    if(widget.posts !=null){
      description = widget.posts.description;
      imageUrl = widget.posts.imageUrl;
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 400,
        height: 300,
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                onSaved: (val) => imageUrl = val,
                initialValue: imageUrl,
                decoration: InputDecoration(
                    labelText: 'ImageUrl'
                ),
              ),
              TextFormField(
                onSaved: (val) => description = val,
                initialValue: description,
                decoration: InputDecoration(
                    labelText: 'description'
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    _form.currentState.save();
                    final id = widget.posts?.id ?? DateTime.now().toIso8601String();
                    context.read(dbProvider).createPost(Posts(
                      description: description,
                      imageUrl: imageUrl,
                      id: id,
                    ), context);
                    Navigator.pop(context);
                  }, child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
