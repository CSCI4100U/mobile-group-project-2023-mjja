class AccountInfo {
  String emailAddress;
  String firstName;
  String lastName;
  String phoneNumber;

  AccountInfo({
    required this.emailAddress,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  // Convert an AccountInfo object to a map for data storage
  Map<String, dynamic> toMap() {
    return {
      'emailAddress': emailAddress,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
    };
  }

  // Create an AccountInfo object from a map
  factory AccountInfo.fromMap(Map<String, dynamic> map) {
    return AccountInfo(
      emailAddress: map['emailAddress'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
