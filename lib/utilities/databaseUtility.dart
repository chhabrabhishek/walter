import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:walter/models/minion.dart';
import 'package:walter/models/kevin.dart';
import 'package:walter/models/saul.dart';

class DatabaseUtility {
  static final DatabaseUtility instance = DatabaseUtility._init();

  static Database? _database;

  DatabaseUtility._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('walter.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idTypePrimaryKey = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER';
    const bigIntType = 'BIGINT';
    const textType = 'TEXT';
    const dateTimeType = 'DATETIME';
    await db.execute(
      'CREATE TABLE $tableMinions(${MinionsFields.minionId} $idTypePrimaryKey, ${MinionsFields.name} $textType, ${MinionsFields.phonenumber} $textType)',
    );
    await db.execute(
      'CREATE TABLE $tableKevin(${KevinFields.kevinId} $idTypePrimaryKey, ${KevinFields.minionId} $integerType, ${KevinFields.accountNumber} $textType, ${KevinFields.bankName} $textType)',
    );
    await db.execute(
      'CREATE TABLE $tableSaul(${SaulFields.saulId} $idTypePrimaryKey, ${SaulFields.kevinId} $integerType, ${SaulFields.amount} $bigIntType, ${SaulFields.isDebited} $integerType, ${SaulFields.dateOfTransaction} $dateTimeType)',
    );
  }

  Future<Minion> createMinion(Minion minion) async {
    final db = await instance.database;
    final minionId = await db.insert(tableMinions, minion.toJson());
    return minion.copy(minionId: minionId);
  }

  Future<Kevin> createKevin(Kevin kevin) async {
    final db = await instance.database;
    final kevinId = await db.insert(tableKevin, kevin.toJson());
    return kevin.copy(kevinId: kevinId);
  }

  Future<Saul> createSaul(Saul saul) async {
    final db = await instance.database;
    final saulId = await db.insert(tableSaul, saul.toJson());
    return saul.copy(saulId: saulId);
  }

  Future<Saul> updateSaul(Saul saul) async {
    final db = await instance.database;
    final saulId = await db.update(tableSaul, saul.toJson(),
        where: "saulId = ?", whereArgs: [saul.saulId]);
    return saul.copy(saulId: saulId);
  }

  Future<int> deleteSaul(int saulId) async {
    final db = await instance.database;
    final saul = await db.delete(tableSaul,
        where: '${SaulFields.saulId} = ?', whereArgs: [saulId]);
    return saul;
  }

  Future<List<Minion>> minionRead() async {
    final db = await instance.database;
    final minionsList = await db.query(
      tableMinions,
      columns: MinionsFields.values,
    );
    if (minionsList.isNotEmpty) {
      return minionsList.map((json) => Minion.fromJson(json)).toList();
    } else {
      throw Exception('Unable to create');
    }
  }

  Future<List<Kevin>> kevinRead(int? minionId) async {
    final db = await instance.database;
    final kevinList = await db.query(tableKevin,
        columns: KevinFields.values,
        where: '${KevinFields.minionId} = ?',
        whereArgs: [minionId]);
    if (kevinList.isNotEmpty) {
      return kevinList.map((json) => Kevin.fromJson(json)).toList();
    } else {
      throw Exception('ID $minionId not found');
    }
  }

  Future<List<Saul>> saulRead(int? kevinId) async {
    final db = await instance.database;
    final saulList = await db.query(tableSaul,
        columns: SaulFields.values,
        where: '${SaulFields.kevinId} = ?',
        whereArgs: [kevinId]);
    if (saulList.isNotEmpty) {
      return saulList.map((json) => Saul.fromJson(json)).toList();
    } else {
      throw Exception('ID $kevinId not found');
    }
  }

  Future<List<Map<String, Object?>>> readAll(String table) async {
    final db = await instance.database;
    final result = await db.query(table);
    return result;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
