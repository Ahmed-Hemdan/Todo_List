import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/cubit/cubit.dart';
import 'package:todo_list/cubit/states.dart';

import '../../Componants/Componants.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: AppCubit.get(context).archivedTasks.isNotEmpty,
          builder: (context) {
            return ListView.separated(
                itemBuilder: (context, index) => buildTaskItem(
                    AppCubit.get(context).archivedTasks[index], context),
                separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                itemCount: AppCubit.get(context).archivedTasks.length);
          },
          fallback: (context) => const Center(
            child: Text(
              'Please enter some Tasks',
              style: TextStyle(fontSize: 22, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
