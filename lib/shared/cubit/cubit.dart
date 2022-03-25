import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import 'package:reuseable_componets/modules/todo_app/done_tasks/done_tasks_screen.dart';
import 'package:reuseable_componets/modules/todo_app/new_tasks/new_tasks_screen.dart';
import 'package:reuseable_componets/shared/cubit/states.dart';
import 'package:reuseable_componets/shared/network/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  int currentIndex = 0;

  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  Database database;
  void changeIndex (int index ){
    currentIndex = index ;
    emit(AppChangeBottomNavBarState());
  }
  void creatDatabase()  {
    openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
          print('database created');
          database
              .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT,time TEXT, status TEXT)')
              .then((value) {
            print('table is created');
          }).catchError((error) {
            print('Error when creating database ${error.toString()}');
          });
        }, onOpen: (database) {
          getDataFromDatabase(database);
        },).then((value) {
          database = value;
          emit(AppCreateDatabaseState());
    } );
  }

  insertToDatabase(
      {@required String title,
        @required String date,
        @required String time}) async {
     await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO Tasks (title, date, time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
            emit(AppInsertDatabaseState());
            getDataFromDatabase(database);
        print('${value} inserted successfully ');
      }).catchError((error) {
        print('Error when insert to  database ${error.toString()}');
      });
      return null;
    });
  }

  getDataFromDatabase(database) {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM Tasks').then((value) {

      value.forEach((element) {
       if(element['status']== 'new'){
         newTasks.add(element);
       }
       else if(element['status']== 'done'){
         doneTasks.add(element);
       }
       else {
         archivedTasks.add(element);
       }
      });
      emit(AppGetDatabaseState());
    });
  }
 void  updateDatabase ({
  @required String status,
    @required int id
}) async{
    database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          getDataFromDatabase(database);
          emit( AppUpdateDatabaseState());
    });
  }
  void  deleteDatabase ({
      @required int id
  }) async{
    database.rawDelete(
        'DELETE FROM Tasks WHERE id = ?', [id])
       .then((value) {
      getDataFromDatabase(database);
      emit( AppDeleteDatabaseState());
    });
  }
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({
      @required bool isShow ,@required IconData icon}){

    isBottomSheetShown = isShow ;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
  bool isDark = false ;
void changeAppThemeMode ({bool fromShared}){
  if(fromShared != null){
    isDark = fromShared;
  emit(ChangeAppThemeModeState());}
  else {
    isDark = !isDark;
    CacheHelper.setData(key: 'isDark', value: isDark).then((value) {
      emit(ChangeAppThemeModeState());
    });
  }
}
}