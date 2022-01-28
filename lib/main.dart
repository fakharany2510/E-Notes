import 'package:e_notes/cubit/states.dart';
import 'package:e_notes/layout/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'bloc/bloc_observer.dart';

void main() {
  Bloc.observer= MyBlocObserver();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
