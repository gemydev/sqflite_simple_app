import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_app/Screens/add_employee_screen.dart';
import 'package:sqflite_app/models/employee.dart';
import 'package:sqflite_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_app/utils/navigation_funs.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<Employee> employeeList;
  int count = 0;
  bool _status = false;

  @override
  Widget build(BuildContext context) {
    if (employeeList == null) {
      employeeList = List<Employee>();
      updateListView();
    }

    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.indigo,
        title: new Text("Employees System"),
      ),
      body: !_status
          ? new Center(
              child: Text(
                'No Employee Records Found',
                style: TextStyle(fontSize: 19, color: Colors.indigo),
              ),
            )
          : new Column(
              children: <Widget>[
                new Expanded(
                    child: new ListView.builder(
                        itemCount: employeeList.length,
                        itemBuilder: (context, index) {
                          return new Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.person_outline),
                              ),
                              title: Text(this.employeeList[index].firstName),
                              subtitle: Text(this.employeeList[index].position),
                              trailing: GestureDetector(
                                  child: Icon(Icons.delete, color: Colors.grey),
                                  onTap: () {
                                    _delete(context, employeeList[index]);
                                  }),
                              onTap: () {
                                navigateToDetail(
                                    this.employeeList[index], 'Edit Employee');
                              },
                            ),
                          );
                        })),
              ],
            ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _openAddingScreen(Employee('', '', '', ''), 'Add Employee');
        },
        backgroundColor: Colors.indigo,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _delete(BuildContext context, Employee employee) async {
    int result = await dataBaseHelper.deleteEmployee(employee.id);
    if (result != 0) {
      _showSnackBar(context, 'Employee deleted successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String s) {}

  void _openAddingScreen(Employee note, String title) async {
    bool result = await normalShift(context, AddEmployeeScreen(note, title));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = dataBaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Employee>> noteListFuture = dataBaseHelper.getEmployeeList();
      noteListFuture.then((employeesList) {
        setState(() {
          this.employeeList = employeesList;
          this.count = employeesList.length;
          if (count == 0) {
            _status = false;
          } else {
            _status = true;
          }
        });
      });
    });
  }

  void navigateToDetail(Employee employee, String title) async {
    bool result =
        await normalShift(context, AddEmployeeScreen(employee, title));
    if (result == true) {
      updateListView();
    }
  }
}
