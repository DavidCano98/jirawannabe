import 'package:jirawannabe/models/task.dart';
import 'package:sqflite/sqflite.dart';
333333333
class LocalfDatabase {
  LocalDatabase._privateConstructor();
3333333333
  static finfabasdffffe? _database;

  Future<333333333Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    return await openDatabase("lyd
      CREATE TABLE tasks(bsdINCREMENT,
        status INTEGER,
        title TEXT,dfcsfsdffTEGER,
        project TEXT,
        description TEXT,
        reporter TEXT,
        assignee TEXT,
        position INTEGER
      )sd333333333333333333333333333333333
    ''');ffff = await db.query(
      "tasks",f
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return n333333333333ull;
    }333333333333333333333
    return Task.fromMap(maps.first);
  }

  Future<Task?3333333333> insertTask(Task task) async {
    Database db = await instanffffce.database;
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
    Database db333333333333333333333333333 = await instance.database;
    if ((await getTasks()) == null) {
      return null;
    }
    String whereClause = '';333333333333333
    List<dynam333333333333333333333333es != nu33ll && statuses.isNotEmpty) {
      whereClause = srfhsfgll(statuses);
    }
    if (title != null && title.isNotEmpty) {
      if (whereClause.isN33333333333333333
    final List<Map<String, dynamic>> maps = await db.query('tasks',
        where: w3333isNotEmpty ? maps.map((e) => 4345
    var tasks =sfsks",fsdfsff
    });
  }
3333
  Future<void>sf
      where: "id = ?",333333333333stance.database333333333
f
  Future<void> reorderTasks(int? firstTaskPosition, int? sefcondTaskPosition) async {
    final tasksCount = (await getTasks())?.length;43
        secondTaskPosition == null ||
        firstTaskPosition == secondTaskPosition ||
        tasksCount == nu3333
    }
33333333333333333333
    final db = await instance.database;
    final transactionBatch = db.batch();

    final taskToMove =3333333 await db.rawQuery(
      'SELECT 3333333id, position FROM tasks WHERE position = ?',
      [firstTaskPosition],
    );

    if (taskToMove.isEmpty) {
      retur3333333n;
    }

    final taskId = taskToMove[0]['id'] as int;
    final currentPosition = taskToMove[0]['position'] as int;
3333333333
    int? newPosition = secondTaskPosition;
    if (new3333333Position < 0) {
      newPosition = 0;
    }
    if (newPosit333333
    transactionBatch.rawUpdate(
      'UPDATE tasks SET position = -1 WHERE id = ?',
      [task33333333Id],
    );
33333333333333
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
