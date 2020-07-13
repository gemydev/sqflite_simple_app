class Employee {
  static const String kId = "employee_id";

  static const String kFirstName = "employee_first_name";
  static const String kLastName = "employee_last_name";
  static const String kPosition = "employee_position";
  static const String kMobile = "employee_mobile";

  int _id;
  String _firstName;
  String _position;
  String _mobile;
  String _lastName;

  Employee(
    this._firstName,
    this._position,
    this._mobile,
    this._lastName,
  );

  Employee.withID(
    this._id,
    this._firstName,
    this._position,
    this._mobile,
    this._lastName,
  );

  String get firstName => _firstName;

  String get position => _position;

  String get mobile => _mobile;

  String get lastName => _lastName;

  int get id => _id;

  set name(String value) {
    _firstName = value;
  }

  set position(String value) {
    _position = value;
  }

  set lastName(String value) {
    _lastName = value;
  }

  set mobile(String value) {
    _mobile = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map[kId] = _id;
    }
    map[kFirstName] = _firstName;
    map[kLastName] = _lastName;
    map[kPosition] = _position;
    map[kMobile] = _mobile;
    return map;
  }

  Employee.fromMapObject(Map<String, dynamic> map) {
    this._id = map[kId];
    this._firstName = map[kFirstName];
    this._lastName = map[kLastName];
    this._position = map[kPosition];
    this._mobile = map[kMobile];
  }
}
