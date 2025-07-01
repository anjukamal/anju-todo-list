
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_task_management/models/task.dart';


class TaskProvider with ChangeNotifier {
  final CollectionReference _tasksCollection = FirebaseFirestore.instance.collection('tasks');
  Database? _database;
  List<Task> _tasks = [];
  String? _errorMessage;

  List<Task> get tasks => _tasks;
  String? get errorMessage => _errorMessage;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'tasks.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, description TEXT, dueDate TEXT, status TEXT, priority TEXT, userId TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> loadTasks(String userId) async {
    try {
      _errorMessage = null;
      final snapshot = await _tasksCollection.where('userId', isEqualTo: userId).get();
      _tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>)).toList();

      // Sync to local database
      if (_database == null) await initDatabase();
      await _database!.delete('tasks', where: 'userId = ?', whereArgs: [userId]);
      for (var task in _tasks) {
        await _database!.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      notifyListeners();
    } catch (e) {
      if (_database == null) await initDatabase();
      final localTasks = await _database!.query('tasks', where: 'userId = ?', whereArgs: [userId]);
      _tasks = localTasks.map((map) => Task.fromMap(map)).toList();
      _errorMessage = 'Failed to load tasks from cloud: $e';
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _tasksCollection.doc(task.id).set(task.toMap());
      if (_database == null) await initDatabase();
      await _database!.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add task: $e';
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _tasksCollection.doc(task.id).update(task.toMap());
      if (_database == null) await initDatabase();
      await _database!.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update task: $e';
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId, String userId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
      if (_database == null) await initDatabase();
      await _database!.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete task: $e';
      notifyListeners();
    }
  }
}
