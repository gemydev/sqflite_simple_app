import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_app/models/employee.dart';
import 'package:sqflite_app/utils/database_helper.dart';
import 'package:sqflite_app/utils/navigation_funs.dart';

class AddEmployeeScreen extends StatefulWidget {
  final String appBarTitle;
  final Employee employee;

  AddEmployeeScreen(this.employee, this.appBarTitle);

  @override
  AddEmployeeScreenState createState() =>
      new AddEmployeeScreenState(this.employee, this.appBarTitle);
}

class AddEmployeeScreenState extends State<AddEmployeeScreen> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<Employee> employeeList;
  int count = 0;
  final FocusNode myFocusNode = FocusNode();
  String appBarTitle;
  Employee employee;
  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  AddEmployeeScreenState(this.employee, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    nameController.text = employee.firstName;
    positionController.text = employee.position;
    mobileController.text = employee.mobile;
    lastNameController.text = employee.lastName;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.indigo,
          title: new Text(appBarTitle),
        ),
        body: new Container(
            color: Colors.white,
            child: new ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Container(
                      height: 185.0,
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: new Stack(fit: StackFit.loose, children: <
                                Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                      width: 140.0,
                                      height: 140.0,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          image: new ExactAssetImage(
                                              'assets/images/profile.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                ],
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 90.0, right: 100.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new CircleAvatar(
                                        backgroundColor: Colors.indigo,
                                        radius: 25.0,
                                        child: new Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )),
                            ]),
                          )
                        ],
                      ),
                    ),
                    new Container(
                      color: Color(0xffFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Employee Information',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            infoField(
                                fieldName: "First name",
                                controller: nameController,
                                hint: "Enter first name",
                                onChangedFun: (value) {
                                  updateName();
                                }),
                            infoField(
                                fieldName: "Last Name",
                                controller: lastNameController,
                                hint: "Enter last name",
                                onChangedFun: (value) {
                                  updateLastName();
                                }),
                            infoField(
                                fieldName: "Position in the company",
                                controller: positionController,
                                hint: "Enter position in the company",
                                onChangedFun: (value) {
                                  updatePosition();
                                }),
                            infoField(
                                fieldName: "Mobile",
                                controller: mobileController,
                                hint: "Enter Mobile Number",
                                onChangedFun: (value) {
                                  updateMobileNumber();
                                }),
                            _getActionButtons(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )));
  }

  Widget infoField(
      {String fieldName,
      String hint,
      TextEditingController controller,
      Function onChangedFun}) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              fieldName,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            new TextField(
              controller: controller,
              onChanged: onChangedFun,
              decoration: InputDecoration(
                hintText: hint,
              ),
            )
          ],
        ));
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text(
                  appBarTitle,
                  style: TextStyle(fontSize: 20),
                ),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _save();
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  void _save() async {
    moveToLastScreen(context);
    int result;
    if (employee.id != null) {
      // Update operation
      result = await dataBaseHelper.updateEmployee(employee);
    } else {
      result = await dataBaseHelper.insertEmployee(employee);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Employee Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void updateName() {
    employee.name = nameController.text;
  }

  void updatePosition() {
    employee.position = positionController.text;
  }

  void updateMobileNumber() {
    employee.mobile = mobileController.text;
  }

  void updateLastName() {
    employee.lastName = lastNameController.text;
  }
}
