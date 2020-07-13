import 'package:sqflite_app/models/employee.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataBaseHelper {
  static DataBaseHelper _databaseHelper;
  static Database _database;
  String tableName = 'employee_table';
  // this names must be the same of keys in map in employee model
  String id = 'employee_id';
  String firstName = 'employee_first_name';
  String lastName = 'employee_last_name';
  String position = 'employee_position';
  String mobile = 'employee_mobile';

  DataBaseHelper._createInstance();

  factory DataBaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DataBaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'employee.db';
    var employeeDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return employeeDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName($id INTEGER PRIMARY KEY AUTOINCREMENT, $firstName TEXT, $lastName TEXT,$position TEXT, $mobile TEXT)');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> getAllEmployeesMapList() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $tableName order by $id ASC');
    //var result = await db.query(tableName, orderBy: '$id ASC');
    return result;
  }

  Future<int> insertEmployee(Employee employee) async {
    Database db = await this.database;
    var result = await db.insert(tableName, employee.toMap());
    return result;
  }

  Future<int> updateEmployee(Employee employee) async {
    Database db = await this.database;
    var result = await db.update(tableName, employee.toMap(),
        where: '$id = ?', whereArgs: [employee.id]);
    return result;
  }

  Future<int> deleteEmployee(int id1) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $tableName WHERE $id = $id1');
    return result;
  }

  Future<int> getCount() async {
    var db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $tableName');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Employee>> getEmployeeList() async {
    var employeeMapList = await getAllEmployeesMapList();
    int count = employeeMapList.length;
    List<Employee> employeeList = List<Employee>();
    for (int i = 0; i < count; i++) {
      employeeList.add(Employee.fromMapObject(employeeMapList[i]));
    }
    return employeeList;
  }
}
