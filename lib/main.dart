import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/auth_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCZP_0DdPvFcaSMsEKAs3N2M21uyRDxnSk', 
      appId: '1:668885427463:android:8ac7613bd09556619f51a2', 
      messagingSenderId: '668885427463', 
      projectId: 'pet-adoption-ffaaa',
      storageBucket: 'pet-adoption-ffaaa.appspot.com'  
    )
  );  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(        
        primarySwatch: Colors.blue,
      ),
      home: const AuthChecker(),           
    );
  }
}

