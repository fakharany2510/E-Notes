import 'package:e_notes/modules/archived_tasks/archived_tasks.dart';
import 'package:e_notes/modules/done_tasks/done_tasks.dart';
import 'package:e_notes/modules/new_tasks/newtasks_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_notes/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screen = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void changeIndex(index){
    currentIndex=index;
    emit(ChangeBottomNavBarState());
  }


   Database? database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];


  void createDatabase()async
  {
     await openDatabase(
        'e.db',
        version: 1,
        onCreate: (database, version) {
          print('Database Created');
          database.execute(
              'CREATE TABLE Task (id INTEGER PRIMARY KEY , title TEXT , time TEXT , date Text , status Text)'
          ).then((value) {
            print('Table Created');
          }).catchError((error) {
            print('error while creating database${error.toString()}');
          });
        },
        onOpen: (database) {
          getDatafromdatabase(database);
        }
    ).then((value){
      database =value;
      emit(CreateDatabaseState());
     });
  }

    insertTOdatabase({
    required String title,
    required String time,
    required String date
})async{
    await database?.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO Task(title , time , date ,status) VALUES("$title","$time" ,"$date","new")')
          .then((value) {
        print('Task ${value}Inserted successfully');
        emit(InsertDatabaseState());
        getDatafromdatabase(database);
      }).catchError((error) {
        print('ERROR INSERT TO DB ${error.toString()}');
      });
    });
  }

  void getDatafromdatabase(database)async{
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
      await database.rawQuery('SELECT * FROM Task').then((value){
        value.forEach((element){
          if(element['status'] == 'new'){
            newTasks.add(element);
          }else if(element['status'] == 'done'){
            doneTasks.add(element);
          }else{
            archivedTasks.add(element);
          }
        });
        emit(GetDatabasState());
      });
  }

  void updateDatabase({
  required String status,
    required int id,
})async{
    await database?.rawUpdate(
        'UPDATE Task SET status = ? WHERE id = ?',
        ['$status', id]).then((value){
          getDatafromdatabase(database);
          emit(UpdateDatabasState());
    });
  }
  void deletDatabase({
  required int id,
})async{
    await database?.rawDelete('DELETE FROM Task WHERE id = ?', [id]).then((value){
      getDatafromdatabase(database);
      emit(DeletDatabasState());
    });
  }

  bool isBottomsheetopend=false;
  IconData fabIcon=Icons.edit;

  changeBottomsheetIcon(
  {
    required bool isShow,
    required IconData bIcon,
}
){
    isBottomsheetopend = isShow;
    fabIcon = bIcon;
    emit(ChangBottomSheetState());
  }



}