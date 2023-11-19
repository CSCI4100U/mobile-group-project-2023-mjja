/**
 * AccountInfo: This class will store the account information of the user
 **/

class AccountInfo {
  int? id;
  String? emailAddress;
  String firstName;
  String lastName;
  String phoneNumber;

  AccountInfo({
    this.id,
    this.emailAddress,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  // create an AccountInfo object from a map
  factory AccountInfo.fromMap(Map<String, dynamic> map) {
    return AccountInfo(
      id: map['id'],
      emailAddress: map['emailAddress'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
    );
  }

  // convert an AccountInfo object to a map for data storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emailAddress': emailAddress,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
    };
  }
}
