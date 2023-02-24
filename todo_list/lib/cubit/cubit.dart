import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/Screens/Archive/ArchivedTasksScreen.dart';
import 'package:todo_list/Screens/Done/DoneTasksScreen.dart';
import 'package:todo_list/Screens/New/NewTasksScreen.dart';
import 'package:todo_list/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());
  static AppCubit get(context) => BlocProvider.of(context);
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  void getpath() async {
    var databasesPath = await getDatabasesPath();
    emit(DatabasePath());
  }

  void createDateBase() {
    openDatabase(
      'Todo.db',
      version: 1,
      onCreate: (Database db, int version) async {
        try {
          await db.execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, status TEXT , date TEXT , time TEXT)');
          print('Database created and table created');
        } catch (error) {
          print(
              'there is error while we creating the database and the table of it and the error is ${error.toString()}');
        }
      },
      onOpen: (db) async {
        print('database onpned');
        getDataFromDatabase(db);
      },
    ).then((value) {
      database = value;
      emit(CreatDatabase());
    });
  }

  Future insertIntoDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    try {
      await database!.transaction(
        (txn) async {
          await txn
              .rawInsert(
                  'INSERT INTO Tasks (title , status , date , time) VALUES ("$title" , "new" , "$date" , "$time")')
              .then((value) {
            print('database inserted');
            emit(InsertToDatabase());
            getDataFromDatabase(database);
            
          });
        },
      );
    } catch (error) {
      print(
          'we have an error while we insert to database and the error is ${error.toString()}');
    }
  }

  void getDataFromDatabase(db) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    db.rawQuery('SELECT * FROM Tasks').then(
      (value) {
        value.forEach((e) {
          if (e['status'] == 'new') {
            newTasks.add(e);
          } else if (e['status'] == 'done') {
            doneTasks.add(e);
          } else {
            archivedTasks.add(e);
          }
        });
        emit(GetFromDatabse());
      },
    );
  }

  void updateDatabase({required status, required id}) {
    database!.rawUpdate('UPDATE Tasks SET status = ?  WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(UpdateDatabase());
    });
  }

  void deleteFromDatabase({required int id}) {
    database!.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(DeleteFromDatabase());
    });
  }

  bool isButtonSheetShown = false;
  IconData floatingIcon = Icons.edit;

  void showButtonsheet({
    required bool show,
    required IconData icon,
  }) {
    isButtonSheetShown = show;
    floatingIcon = icon;
    emit(ButtonSheetShown());
  }

  
}
