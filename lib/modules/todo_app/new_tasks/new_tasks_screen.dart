
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/shared/components/components.dart';
import 'package:reuseable_componets/shared/components/constants.dart';
import 'package:reuseable_componets/shared/cubit/cubit.dart';
import 'package:reuseable_componets/shared/cubit/states.dart';
class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state ){},
        builder: (context, state){
          var tasks =AppCubit.get(context).newTasks;
          return tasks.length >0 ?ListView.separated(itemBuilder: (context, index)=>buildTaskItem(tasks[index],context),
              separatorBuilder: (context,index)=>Padding(
                padding: const EdgeInsetsDirectional.only(
                    start:20.0 ),
                child: Container(
                  height: 1.0,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
              ),
              itemCount:tasks.length):Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.menu),
            Text('No Tasks yet ,please enter new  tasks ',
                  style: TextStyle(fontSize: 20.0,
                  fontWeight: FontWeight.bold)),
          ],),
              );
        },
    );
  }
}
