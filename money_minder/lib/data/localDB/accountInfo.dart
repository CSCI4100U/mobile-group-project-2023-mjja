/**
 * AccountInfo: This class will store the account information of the user
 **/

class AccountInfo {
  int? id;                // unique AccountInfo identifier
  String? emailAddress;   // email address of the user
  String? fullName;       // fullname of the user
  String? username;       // username of the user
  String? password;       // password of the user

  AccountInfo({
    this.id,
    this.emailAddress,
    this.fullName,
    this.username,
    this.password,
  });

  // generate a new AccountInfo object from a map, typically from the database
  factory AccountInfo.fromMap(Map<String, dynamic> map) {
    return AccountInfo(
      id: map['id'],
      emailAddress: map['emailAddress'],
      fullName: map['fullName'],
      username: map['username'],
      password: map['password'],
    );
  }

  // convert an AccountInfo object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emailAddress': emailAddress,
      'fullName': fullName,
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'Account Info [id: $id, fullname: $fullName, email: $emailAddress]';
  }
}
