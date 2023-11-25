/**
 * AccountInfo: This class will store the account information of the user
 **/

class AccountInfo {
  int? id;
  String? emailAddress;
  String? fullName;
  String? username;
  String? password;

  AccountInfo({
    this.id,
    this.emailAddress,
    this.fullName,
    this.username,
    this.password,
  });

  // Create a AccountInfo object from a map (e.g., when retrieving data from SharedPreferences)
  factory AccountInfo.fromMap(Map<String, dynamic> map) {
    return AccountInfo(
      id: map['id'],
      emailAddress: map['emailAddress'],
      fullName: map['fullName'],
      username: map['username'],
      password: map['password'],
    );
  }

  // Convert a AccountInfo object to a map for data storage (e.g., in SharedPreferences)
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
