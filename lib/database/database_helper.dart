import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:stocks_news_new/database/databaseModals/login_visibility.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/utils/utils.dart';

class DatabaseHelper {
  // constructor with instance variable
  static final DatabaseHelper instance = DatabaseHelper();

  // variables to use
  static const dbName = "stock_news_database.db";
  static const dbVersion = 1;
  static const dbLoginVisibilityTable = 'login_visible_management';

  // tables column Course
  static const screenName = 'screen_name';
  static const lastVisible = 'last_visible';
  static const visibleCount = 'visible_count';
  static const maxVisibleCount = 'max_visible_count';
  static const statusColumn = 'status';

  // database variable
  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: onCreate,
      onUpgrade: onUpdate,
    );
  }

  Future onCreate(db, version) async {
    await db.execute('''
      CREATE TABLE $dbLoginVisibilityTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        $screenName TEXT,
        $lastVisible TEXT,
        $visibleCount INTEGER,
        $maxVisibleCount INTEGER,
        $statusColumn INTEGER
      );
    ''');

    Utils().showLog("Exam Table Created ******  ");
  }

  Future onUpdate(db, oldVersion, newVersion) async {
    // Clear tables on any version upgrade
    await db.execute('DROP TABLE IF EXISTS $dbLoginVisibilityTable');
    onCreate(db, newVersion);
  }

  // Future<void> insertVideoData(LoginVisibility videoData) async {
  //   final Database db = await instance.database;
  //   await db.insert(dbLoginVisibilityTable, videoData.toJson());
  // }

  Future<void> checkAndInsertInitialData(
      {required int count, required int status}) async {
    final Database db = await instance.database;
    List<LoginVisibility> allData = await getAllData();

    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(today);

    if (allData.isEmpty && status == 1) {
      LoginVisibility blogScreen = LoginVisibility(
        screenName: BlogDetail.path,
        lastVisible: formattedDate,
        count: 0,
        status: status,
        maxCount: count,
      );
      await db.insert(dbLoginVisibilityTable, blogScreen.toJson());
      LoginVisibility newsDetailScreen = LoginVisibility(
        screenName: NewsDetails.path,
        lastVisible: formattedDate,
        count: 0,
        maxCount: count,
        status: status,
      );
      await db.insert(dbLoginVisibilityTable, newsDetailScreen.toJson());
    } else if (allData.isNotEmpty && status == 0) {
      await db.update(dbLoginVisibilityTable, {statusColumn: 0});
    }
  }

  Future<bool> fetchLoginDialogData(screen) async {
    final db = await instance.database;

    final result = await db.query(
      dbLoginVisibilityTable,
      where: '$screenName = ?',
      whereArgs: [screen],
    );

    if (result.isNotEmpty) {
      LoginVisibility visible = LoginVisibility.fromJson(result.first);

      if (visible.status == 1 &&
          ((isToday(visible) && visible.count < visible.maxCount) ||
              !isToday(visible))) {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  bool isToday(LoginVisibility visible) {
    DateTime today = DateTime.now();

    DateTime parsedDate = DateTime.parse(visible.lastVisible);

    // Compare dates ignoring time
    bool isSameDay = today.year == parsedDate.year &&
        today.month == parsedDate.month &&
        today.day == parsedDate.day;

    return isSameDay;
  }

  Future<void> update(int screen) async {
    final Database db = await instance.database;

    // DateTime today = DateTime.now();
    // String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(today);

    await db.update(
      dbLoginVisibilityTable,
      {visibleCount: 1},
      where: '$screen = ?',
      whereArgs: [screen],
    );
  }

  // Future<LoginVisibility?> getLoginVisibilityByScreen(
  //     {required String screen}) async {
  //   final db = await database;
  //   List<Map<String, dynamic>> videoDataMap = await db.query(
  //     dbLoginVisibilityTable,
  //     where: '$screenName = ?',
  //     whereArgs: [screen],
  //   );
  //   if (videoDataMap.isNotEmpty) {
  //     return LoginVisibility.fromJson(videoDataMap.first);
  //   } else {
  //     return null;
  //   }
  // }

  Future<List<LoginVisibility>> getAllData() async {
    final Database db = await instance.database;
    List<Map<String, dynamic>> maps =
        await db.rawQuery('''SELECT * FROM $dbLoginVisibilityTable''');
    return List.generate(maps.length, (i) {
      return LoginVisibility(
        screenName: maps[i][screenName],
        count: maps[i][visibleCount],
        lastVisible: maps[i][lastVisible],
        status: maps[i][statusColumn],
        maxCount: maps[i][maxVisibleCount],
      );
    });
  }

  Future<void> markViewed(int screen) async {
    final Database db = await instance.database;

    // Update isAnswered in the questions table
    await db.update(
      dbLoginVisibilityTable,
      {visibleCount: 1},
      where: '$screen = ?',
      whereArgs: [screen],
    );

    // Retrieve the updated ExamData from the database
    // final updatedExamData =
    //     await getExamDataByQuestionBankId(exmId, questionBId);
    // return updatedExamData;
  }

  Future<void> clearAllData() async {
    final Database db = await database;
    await db.delete(dbLoginVisibilityTable);
  }
}
