import 'package:flutter/material.dart';
import 'package:flutter_app_models/auth_provider/auth_model_provider.dart';
import 'package:flutter_app_models/utils/text_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class AuthScreen extends ConsumerWidget {


  final _form = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  @override
  Widget build(BuildContext context, watch) {
    final status = watch(statusProvider);
    final vStatus = watch(visibilityProvider);
    final loading = watch(loadProvider);

    return Scaffold(
        body: Form(
          key:  _form,
          child: Container(
            margin: EdgeInsets.only(top: 122),
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text( status ? 'Sign Up' : 'Sign In', style: TextStyle(
                    color: Colors.black54,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  SizedBox(height: 30,),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: kBoxDecorationStyle,
                        child: TextFormField(
                          validator: (val){
                            if(!val.contains('@') || val.isEmpty ){
                              return 'Please provide a valid email';
                            }
                            return null;
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.black,),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14),
                              prefixIcon: Icon(Icons.email, color: Colors.white,
                              ),
                              hintText: 'Enter your Email',
                              hintStyle: kHintTextStyle
                          ),
                        ),
                      ),



                  SizedBox(height: 30,),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: kBoxDecorationStyle,
                        child: TextFormField(
                          validator: (val){
                            if(val.length < 5 || val.isEmpty ){
                              return 'minimum value of password is 5';
                            }
                            return null;
                          },

                          controller: passController,
                          keyboardType: TextInputType.text,
                          obscureText:vStatus ? false : true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              errorStyle: TextStyle(color: Colors.black),
                              contentPadding: EdgeInsets.only(top: 14),
                              suffixIcon: IconButton(
                                onPressed: (){
                                  context.read(visibilityProvider.notifier).toggle();
                                },
                                icon: Icon(vStatus ? Icons.visibility : Icons.visibility_off),
                              ),
                              prefixIcon: Icon(Icons.vpn_key_outlined, color: Colors.white,
                              ),
                              hintText: 'Enter your Password',
                              hintStyle: kHintTextStyle
                          ),
                        ),
                      ),


SizedBox(height: 20,),

              loading.when(data: (data){
               return   Container(
                 padding: EdgeInsets.symmetric(vertical: 25.0),
                 width: double.infinity,
                 child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     primary: Colors.white70,
                     padding: EdgeInsets.all(15.0),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(30.0),
                     ),
                   ),
                   onPressed: () {

                     if(_form.currentState.validate()){
                       _form.currentState.save();
                       if(status){
                         context.read(loadProvider.notifier)
                             .signUp(email: emailController.text.trim(),
                             password: passController.text.trim(),context: context);
                         FocusScope.of(context).unfocus();
                       }else{
                         context.read(loadProvider.notifier)
                             .signIn(email: emailController.text.trim(),
                             password: passController.text.trim(),context: context);
                         FocusScope.of(context).unfocus();
                       }
                     }

                   },
                   child: Text(
                     status ? 'SIGN UP' : 'LOGIN ',
                     style: TextStyle(
                       color: Color(0xFF527DAA),
                       letterSpacing: 1.5,
                       fontSize: 18.0,
                       fontWeight: FontWeight.bold,
                       fontFamily: 'OpenSans',
                     ),
                   ),
                 ),
               );

              }, loading: () => CircularProgressIndicator(), error: (err, stack) => Text('$err')),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text( status ? 'Already have an Account' : 'Don\'t have an Account'  ),
                    TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.pink[200]
                        ),
                        onPressed: (){
                          context.read(statusProvider.notifier).toggle();
                        },
                        child: Text( status ? 'Login here' : 'Create a New One'  ),
                      )
                    ],
                  )

                ],
              ),
            ),
          ),
        )
    );
  }
}
