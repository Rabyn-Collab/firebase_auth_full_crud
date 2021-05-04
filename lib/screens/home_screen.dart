import 'package:flutter/material.dart';
import 'package:flutter_app_models/auth_provider/auth_model_provider.dart';
import 'package:flutter_app_models/screens/auth_screen.dart';
import 'package:flutter_app_models/screens/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final authState = watch(authStateProvider);
    return Scaffold(
        body: authState.when(
            data: (data){
              if(data != null){
               return MainScreen();
              }else{
                return AuthScreen();
              }
            },
            loading: () => Center(child: CircularProgressIndicator(),),
            error: (err, stack) => Center(child: Text('$err'),))
    );
  }
}
