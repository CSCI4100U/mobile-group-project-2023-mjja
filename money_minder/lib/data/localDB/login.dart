/**
 * Login: This class will store the login information of the user
 **/

class Login {
  int? id;                  // unique Login identifier
  String? emailAddress;     // email address of the user
  String? password;         // password of the user

  Login({
    this.id,
    this.emailAddress,
    this.password,
  });

  // generate a new Login object from a map, typically from the database
  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      id: map['id'],
      emailAddress: map['emailAddress'],
      password: map['password'],
    );
  }

  // convert an Expense object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emailAddress': emailAddress,
      'password': password,
    };
  }
}
