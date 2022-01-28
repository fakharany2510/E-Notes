import 'package:e_notes/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildScreencomponent(Map model , context)=>Dismissible(key:Key(model['id'].toString()),
    child: Padding(
  padding: EdgeInsets.all(10),
  child: Row(
    children: [
      CircleAvatar(
        radius: 35,
        child: Text('${model['time']}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.grey.shade400,
      ),
      SizedBox(width: 10,),
      Expanded(child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${model['title']}',style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 5,),
          Text('${model['date']}',style: TextStyle(
            color: Colors.grey,
          ),),
        ],
      ),),
      SizedBox(width: 10,),
      IconButton(onPressed: (){
        AppCubit.get(context).updateDatabase(status: 'done', id: model['id']);

      }, icon: Icon(Icons.check_circle),color: Colors.green.shade900,),
      IconButton(onPressed: (){
        AppCubit.get(context).updateDatabase(status: 'archived', id: model['id']);
      }, icon: Icon(Icons.archive_outlined),color: Colors.red.shade900,),

    ],
  ),
),
    //background: Colors.red,
    onDismissed: (direction){
   AppCubit.get(context).deletDatabase(id: model['id']);
    },
   background:  Container(
         child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Padding(
               padding: EdgeInsets.only(left: 20),
               child:Icon(Icons.delete , color: Colors.white,),
             ),
             SizedBox(width: 120),
             Padding(
               padding: EdgeInsets.only(left: 20),
               child:Icon(Icons.delete , color: Colors.white,),
             ),
           ],
         ),
         color: Colors.red.shade500),


);

