import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/appStates.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit() : super (AppInitialState());

  static AppCubit get (context) => BlocProvider.of(context);

  int currentIndex=0;
  Database database;
  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archivedTasks =[];


  List<Widget> screens = [
    NewTask(),
    DoneTask(),
    ArchivedTask(),
  ];

  List<String>titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  void changeBottomNavIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }


  void createDataBase(){
     openDatabase(
        'todo.db',version: 1,
        onCreate: (Database database,int version) async{
          await database.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)'
          ).then((value) => print('Table Created')).catchError((error) => print('Error when creating table ${error.toString()}'));
        },
        onOpen: (Database database){
          getDataFromDataBase(database);
        }
    ).then((value){
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase({@required String title, @required String date,@required String time}) async{
    await database.transaction((txn) {
      txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")').then((value){
        emit(AppInsertToDataBaseState());

        getDataFromDataBase(database);

      }).catchError((error){
        print('Error when inserting new record ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDataBase(database) {
    emit(AppGetFromDataBaseLoadingState());

    database.rawQuery(
      'SELECT * FROM tasks WHERE status = "new"',).then((value) {
      newTasks=value;
    });

    database.rawQuery(
      'SELECT * FROM tasks WHERE status = "done"',).then((value) {
      doneTasks=value;
    });

    database.rawQuery(
      'SELECT * FROM tasks WHERE status = "archive"',).then((value) {
      archivedTasks=value;
    });
    emit(AppGetFromDataBaseState());
  }

  void updateData(String status, int id){
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [status,id]).then((value) {
          emit(AppUpdateFromDataBaseState());
    }).then((value) {
      getDataFromDataBase(database);
    });
  }


  void deleteData(int id){
    database.rawDelete( 'DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteFromDataBaseState());
    }).then((value) {
      getDataFromDataBase(database);
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheet(bool isShown, IconData icon){
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

}