import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import '../models/tsk.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;
  Future<void> getTask() async {
    final List<Map<String, dynamic>> tsks = await DBHelper?.query();
    taskList.assignAll(tsks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTask(Task tsk) async {
    await DBHelper.delete(tsk);
    getTask();
  }

  void deleteAllTask() async {
    await DBHelper.deleteAll();
    getTask();
  }

  void changTask(int id) async {
    await DBHelper.update(id);
    getTask();
  }

  Future<int> addTask({Task? tsk}) {
    return DBHelper.insert(tsk);
  }
}
