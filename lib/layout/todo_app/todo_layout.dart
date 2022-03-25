import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reuseable_componets/shared/components/components.dart';
import 'package:reuseable_componets/shared/cubit/cubit.dart';
import 'package:reuseable_componets/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override

  Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  initState() {
    super.initState();
   // creatDatabase();
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context )=>AppCubit()..creatDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);}
        },
        builder: (context, state ){
          AppCubit cubit =  AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text( cubit.titles[cubit.currentIndex]),
            ),
            body: state is! AppGetDatabaseLoadingState? cubit.screens[cubit.currentIndex] :Center(child: CircularProgressIndicator()),
            //tasks.length == 0
              //  ? Center(child: CircularProgressIndicator())
               // : cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDatabase(title: titleController.text,
                        date: dateController.text, time: timeController.text);

                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) => Container(
                      color: Colors.lightGreenAccent[100],
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                              controller: titleController,
                              type: TextInputType.text,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'title must not be empty ';
                                }
                                return null;
                              },
                              label: 'Task Title',
                              hint: 'Title',
                              prefix: Icons.title,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                              controller: timeController,
                              type: TextInputType.datetime,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'time must not be empty ';
                                }
                                return null;
                              },
                              label: 'Task Time',
                              hint: 'Time',
                              prefix: Icons.watch_later_outlined,
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                    .then((value) {
                                  timeController.text = value.format(context);
                                });
                              },
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                              controller: dateController,
                              type: TextInputType.datetime,
                              validate: (String value) {
                                if (value.isEmpty) {
                                  return 'date must not be empty ';
                                }
                                return null;
                              },
                              label: 'Task Date',
                              hint: 'Date',
                              prefix: Icons.calendar_today_outlined,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-05-03'),
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  )
                      .closed
                      .then((value) {
                        cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);

                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);

                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex:  cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: 'Archived'),
              ],
            ),
          );
        },

      ),
    );
  }


}
