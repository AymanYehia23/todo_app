import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components.dart';
import 'package:todo_app/shared/cubit/appCubit.dart';
import 'package:todo_app/shared/cubit/appStates.dart';

class HomeLayout extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener:(BuildContext context , AppStates states){
          if(states is AppInsertToDataBaseState){
            Navigator.pop(context);
            titleController.clear();
            timeController.clear();
            dateController.clear();
          }
        },
        builder: (BuildContext context , AppStates states){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: states is! AppGetFromDataBaseLoadingState,
              builder:(context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabIcon),
              onPressed: ()
              {
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState.validate()){
                    cubit.insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text,
                    );
                  }
                }else{
                  scaffoldKey.currentState.showBottomSheet((context) =>
                      Container(
                        padding: EdgeInsets.all(20.0),
                        color: Colors.white,
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:
                            [
                              defaultFormField(
                                controller: titleController,
                                validate: (String value){
                                  if(value.isEmpty)
                                    return 'title must not be empty';
                                  return null;
                                },
                                label: 'Task Title',
                                prefix: Icons.title,
                              ),
                              SizedBox(height: 15,),
                              defaultFormField(
                                controller: timeController,
                                validate: (String value){
                                  if(value.isEmpty)
                                    return 'time must not be empty';
                                  return null;
                                },
                                label: 'Task Time',
                                prefix: Icons.watch_later_outlined,
                                isReadOnly: true,
                                onTap: (){
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now()
                                  ).then((value) {
                                    timeController.text = value.format(context);
                                  });
                                },
                              ),
                              SizedBox(height: 15,),
                              defaultFormField(
                                controller: dateController,
                                validate: (String value){
                                  if(value.isEmpty)
                                    return 'date must not be empty';
                                  return null;
                                },
                                label: 'Task Date',
                                prefix: Icons.calendar_today,
                                isReadOnly: true,
                                onTap: (){
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year+1),
                                  ).then((value) {
                                    dateController.text=DateFormat.yMMMd().format(value);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),elevation: 20).closed
                      .then((value) {
                        cubit.changeBottomSheet(false, Icons.edit);
                  });
                  cubit.changeBottomSheet(true, Icons.add);
                  // setState(() {
                  //   fabIcon = Icons.add;
                  // });
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex:cubit.currentIndex ,
              onTap: (index){
                cubit.changeBottomNavIndex(index);
              },
              items:
              [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived'
                ),
              ],
            ),
          );
        },
      ),
    );
  }



}


