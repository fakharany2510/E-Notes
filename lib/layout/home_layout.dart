import 'package:e_notes/cubit/cubit.dart';
import 'package:e_notes/cubit/states.dart';
import 'package:e_notes/modules/archived_tasks/archived_tasks.dart';
import 'package:e_notes/modules/done_tasks/done_tasks.dart';
import 'package:e_notes/modules/new_tasks/newtasks_screen.dart';
import 'package:e_notes/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class HomeLayout extends StatelessWidget {
   HomeLayout({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context , state){
          if(state is InsertDatabaseState){
            Navigator.pop(context, true);
          }
        },
        builder: (context , state){
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(AppCubit.get(context).titles[AppCubit.get(context).currentIndex]),
                centerTitle: true,
                backgroundColor: Colors.deepOrange,
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.white,
                backgroundColor: Colors.deepOrange,
                currentIndex: AppCubit.get(context).currentIndex,
                onTap: (index) {
                  AppCubit.get(context).changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'new tasks',),
                  BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'done tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'archived tasks'),
                ],
              ),
              body: AppCubit.get(context).screen[AppCubit.get(context).currentIndex],
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                if(AppCubit.get(context).isBottomsheetopend){
            if(formKey.currentState!.validate()){
             AppCubit.get(context).insertTOdatabase(
                 title:titleController.text ,
                 time: timeController.text,
                  date: dateController.text);
            }

          }else{
            scaffoldKey.currentState!.showBottomSheet((context)=>Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.grey.shade300,
                  child: Form(
                    key: formKey,
                    child:Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          TextFormField(
                              controller:titleController ,
                              keyboardType: TextInputType.text,
                              onTap: (){},
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'please enter task';
                                }
                              },
                              decoration: InputDecoration(
                                label: Text('Task Title'),
                                prefixIcon: Icon(Icons.title),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                              )
                          ),
                          SizedBox(height:10),
                          TextFormField(
                              controller:timeController ,
                              keyboardType: TextInputType.datetime,
                              onTap: (){
                                showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
                                  timeController.text=value!.format(context).toString();
                                });
                              },
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'please enter task time';
                                }
                              },
                              decoration: InputDecoration(
                                label: Text('Task Time'),
                                prefixIcon: Icon(Icons.watch_later_outlined),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                              )
                          ),
                          SizedBox(height:10),
                          TextFormField(
                              controller:dateController ,
                              keyboardType: TextInputType.datetime,
                              onTap: (){
                                showDatePicker(context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-03-02')).then((value){
                                  dateController.text=DateFormat.yMMMd().format(value!);
                                });
                              },
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'please enter task date';
                                }
                              },
                              decoration: InputDecoration(
                                label: Text('Task date'),
                                prefixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                              )
                          ),

                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            ).closed.then((value){
              AppCubit.get(context).changeBottomsheetIcon(isShow: false, bIcon: Icons.edit);
            }).catchError((error){print('AAAAAAAA${error.toString()}');});
            AppCubit.get(context).changeBottomsheetIcon(isShow: true, bIcon: Icons.add);
          }
                },
                backgroundColor: Colors.deepOrange,
                child: Icon(AppCubit.get(context).fabIcon),
              ),

            );
        },
      ),
    );
  }
}


