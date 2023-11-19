/**
 * Login: This class will store the login information of the user
 **/

class Login {
  int? id;
  String? emailAddress;
  String? password;

  Login({
    this.id,
    this.emailAddress,
    this.password,
  });

  // create a Login object from a map
  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      id: map['id'],
      emailAddress: map['emailAddress'],
      password: map['password'],
    );
  }

  // convert a Login object to a map for data storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emailAddress': emailAddress,
      'password': password,
    };
  }
}
