import 'package:e_notes/cubit/cubit.dart';
import 'package:e_notes/cubit/states.dart';
import 'package:e_notes/shared/components.dart';
import 'package:e_notes/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit , AppStates>(
        builder: (context , state){
          return ListView.separated(
              itemBuilder:(context , index)=>buildScreencomponent(AppCubit.get(context).newTasks[index],context),
              separatorBuilder: (context , index)=>Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              itemCount: AppCubit.get(context).newTasks.length);
        },
        listener:(context , builder){} ,
      );
  }
}
