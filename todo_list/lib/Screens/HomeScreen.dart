import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/cubit/cubit.dart';
import 'package:todo_list/cubit/states.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDateBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is InsertToDatabase) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                AppCubit.get(context)
                    .titles[AppCubit.get(context).currentIndex],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (AppCubit.get(context).isButtonSheetShown) {
                  if (formKey.currentState!.validate()) {
                    AppCubit.get(context).insertIntoDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);
                    timeController.text = '';
                    dateController.text = '';
                    titleController.text = '';
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        elevation: 15,
                        (context) => Container(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter the task name !'
                                      : null,
                                  controller: titleController,
                                  decoration: InputDecoration(
                                      icon: const Icon(
                                        Icons.title_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      hintText: 'Enter the task name !'),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter the task time !'
                                      : null,
                                  controller: timeController,
                                  decoration: InputDecoration(
                                      icon: const Icon(
                                        Icons.schedule_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      hintText: 'Enter the task time !'),
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) => timeController.text =
                                            value!.format(context).toString());
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter the task deadline!'
                                      : null,
                                  controller: dateController,
                                  decoration: InputDecoration(
                                      icon: const Icon(
                                        Icons.date_range,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      hintText: 'Enter the task deadline!'),
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2023-06-16'))
                                        .then(
                                      (value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) => {
                            AppCubit.get(context)
                                .showButtonsheet(show: false, icon: Icons.edit),
                          });
                  AppCubit.get(context).showButtonsheet(
                      show: true, icon: Icons.done_outline_rounded);
                }
              },
              child: Icon(AppCubit.get(context).floatingIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.done_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
            body: AppCubit.get(context)
                .screens[AppCubit.get(context).currentIndex],
          );
        },
      ),
    );
  }
}
