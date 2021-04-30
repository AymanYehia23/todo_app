import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components.dart';
import 'package:todo_app/shared/cubit/appCubit.dart';
import 'package:todo_app/shared/cubit/appStates.dart';

class ArchivedTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,states){

      },
      builder: (context,states){
        return buildTasks(AppCubit.get(context).archivedTasks);
      },
    );
  }
}
