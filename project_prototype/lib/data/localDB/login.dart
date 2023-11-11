class Login {
  String emailAddress;
  String password;

  Login({
    required this.emailAddress,
    required this.password,
  });

  // Convert a Login object to a map for data storage (e.g., in SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'emailAddress': emailAddress,
      'password': password,
    };
  }

  // Create a Login object from a map (e.g., when retrieving data from SharedPreferences)
  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      emailAddress: map['emailAddress'],
      password: map['password'],
    );
  }
}
