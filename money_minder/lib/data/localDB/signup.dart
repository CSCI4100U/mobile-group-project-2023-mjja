/// Signup: This class will store the signup information of the user

class Signup {
  int? id;                  // unique Signup identifier
  String? emailAddress;     // email address of the user
  String? fullName;         // fullname of the user
  String? username;         // usernam eof the user
  String? password;         // password of the user

  Signup({
    this.id,
    this.emailAddress,
    this.fullName,
    this.username,
    this.password,
  });

  // generate a new Signup object from a map, typically from the database
  factory Signup.fromMap(Map<String, dynamic> map) {
    return Signup(
      id: map['id'],
      emailAddress: map['emailAddress'],
      fullName: map['fullName'],
      username: map['username'],
      password: map['password'],
    );
  }

  // convert a Signup object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emailAddress': emailAddress,
      'fullName': fullName,
      'username': username,
      'password': password,
    };
  }

}
