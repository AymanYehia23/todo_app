import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'layout/home_layout.dart';
import 'shared/cubit/observer.dart';

void main() {
  runApp(MyApp());
  Bloc.observer = MyBlocObserver();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeLayout()
    );
  }
}

