import 'package:flutter/material.dart';
import 'package:todo_list/cubit/cubit.dart';

Widget buildTaskItem(tasks, context) => Dismissible(
      key: Key(tasks['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteFromDatabase(
          id: tasks['id'],
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blueGrey[500],
              child: Text('${tasks['time']}'),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${tasks['title']}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${tasks['date']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'done', id: tasks['id']);
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'archived', id: tasks['id']);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
