import 'package:jirawannabe/models/task.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._privateConstructor();

  static final LocalDatabase instance = LocalDatabase._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    return await openDatabase("localjirawannabe.db", version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        status INTEGER,
        title TEXT,
        priority INTEGER,
        project TEXT,
        description TEXT,
        reporter TEXT,
        assignee TEXT,
        position INTEGER
      )
    ''');
    await db.execute(
      'CREATE TABLE locale(id INTEGER PRIMARY KEY AUTOINCREMENT, localeLanguage TEXT)',
    );
  }

  Future<Task?> getTask(int? id) async {
    Database db = await instance.database;
    final maps = await db.query(
      "tasks",
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return null;
    }
    return Task.fromMap(maps.first);
  }

  Future<Task?> insertTask(Task task) async {
    Database db = await instance.database;
    task.position = await getLastTaskPosition();
    var id = await db.insert("tasks", task.toMap());
    return await getTask(id);
  }

  Future<Task?> saveTask(Task task) async {
    Database db = await instance.database;
    await db.update(
      "tasks",
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
    return await getTask(task.id);
  }

  Future<List<Task>?> filterTasks({List<int>? statuses, String? title}) async {
    Database db = await instance.database;
    if ((await getTasks()) == null) {
      return null;
    }
    String whereClause = '';
    List<dynamic> whereArgs = [];
    if (statuses != null && statuses.isNotEmpty) {
      whereClause = 'status IN (${List.filled(statuses.length, '?').join(', ')})';
      whereArgs.addAll(statuses);
    }
    if (title != null && title.isNotEmpty) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += 'title LIKE ?';
      whereArgs.add('%$title%');
    }
    final List<Map<String, dynamic>> maps = await db.query('tasks',
        where: whereClause.isEmpty ? null : whereClause,
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
        orderBy: 'position ASC');
    return maps.isNotEmpty ? maps.map((e) => Task.fromMap(e)).toList() : [];
  }

  Future<List<Task>?> getTasks() async {
    Database db = await instance.database;
    var tasks = await db.query("tasks", orderBy: 'position');
    List<Task>? taskList = tasks.isNotEmpty ? tasks.map((e) => Task.fromMap(e)).toList() : null;
    return taskList;
  }

  Future<void> saveTasks(List<Task> tasks) async {
    Database db = await instance.database;

    await db.transaction((txn) async {
      for (Task task in tasks) {
        List<Map<String, dynamic>> result = await txn.query(
          "tasks",
          where: "id = ?",
          whereArgs: [task.id],
        );

        if (result.isNotEmpty) {
          await txn.update(
            "tasks",
            task.toMap(),
            where: "id = ?",
            whereArgs: [task.id],
          );
        }
      }
    });
  }

  Future<void> deleteTask(Task task) async {
    Database db = await instance.database;
    int? oldIndex = task.position;
    await db.delete(
      "tasks",
      where: "id = ?",
      whereArgs: [task.id],
    );

    await db.transaction((txn) async {
      await txn.rawQuery('UPDATE tasks SET position = position - 1 WHERE position > ?', [oldIndex]);
    });
  }

  Future<void> deleteAllTasks() async {
    Database db = await instance.database;
    await db.delete("tasks");
  }

  Future<void> reorderTasks(int? firstTaskPosition, int? secondTaskPosition) async {
    final tasksCount = (await getTasks())?.length;
    if (firstTaskPosition == null ||
        secondTaskPosition == null ||
        firstTaskPosition == secondTaskPosition ||
        tasksCount == null ||
        tasksCount == 0) {
      return;
    }

    final db = await instance.database;
    final transactionBatch = db.batch();

    final taskToMove = await db.rawQuery(
      'SELECT id, position FROM tasks WHERE position = ?',
      [firstTaskPosition],
    );

    if (taskToMove.isEmpty) {
      return;
    }

    final taskId = taskToMove[0]['id'] as int;
    final currentPosition = taskToMove[0]['position'] as int;

    int? newPosition = secondTaskPosition;
    if (newPosition < 0) {
      newPosition = 0;
    }
    if (newPosition >= tasksCount) {
      newPosition = tasksCount - 1;
    }

    transactionBatch.rawUpdate(
      'UPDATE tasks SET position = -1 WHERE id = ?',
      [taskId],
    );

    if (currentPosition < newPosition) {
      transactionBatch.rawUpdate(
        'UPDATE tasks SET position = position - 1 WHERE position > ? AND position <= ?',
        [currentPosition, newPosition],
      );
    } else {
      transactionBatch.rawUpdate(
        'UPDATE tasks SET position = position + 1 WHERE position >= ? AND position < ?',
        [newPosition, currentPosition],
      );
    }

    transactionBatch.rawUpdate(
      'UPDATE tasks SET position = ? WHERE id = ?',
      [newPosition, taskId],
    );

    await transactionBatch.commit(noResult: true);
  }

  Future<int> getLastTaskPosition() async {
    final db = await instance.database;
    final result = await db.query('tasks', columns: ['MAX(position)']);
    final maxValue = result.first['MAX(position)'] as int?;
    return maxValue != null ? maxValue + 1 : 0;
  }

  Future<void> saveLocale(String languageCode) async {
    final Database db = await instance.database;
    await db.insert(
      "locale",
      {
        "localeLanguage": languageCode,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getLocale() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query("locale", orderBy: 'id DESC');
    if (maps.isNotEmpty) {
      return maps.first["localeLanguage"] as String;
    }
    return null;
  }
}
