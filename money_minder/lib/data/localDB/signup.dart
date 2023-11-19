/**
 * Signup: This class will store the signup information of the user
 **/

class Signup {
  int? id;
  String? emailAddress;
  String? fullName;
  String? username;
  String? password;

  Signup({
    this.id,
    this.emailAddress,
    this.fullName,
    this.username,
    this.password,
  });

  // Create a SignUp object from a map (e.g., when retrieving data from SharedPreferences)
  factory Signup.fromMap(Map<String, dynamic> map) {
    return Signup(
      id: map['id'],
      emailAddress: map['emailAddress'],
      fullName: map['fullName'],
      username: map['username'],
      password: map['password'],
    );
  }

  // Convert a SignUp object to a map for data storage (e.g., in SharedPreferences)
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
