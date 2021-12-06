class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? surName;
  String? phoneNumber;
  String? userName;
  String? adress;
  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.surName,
      this.phoneNumber,
      this.userName,
      this.adress});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        surName: map['surName'],
        phoneNumber: map['phoneNumber'],
        userName: map['userName'],
        adress: map['adress']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'surName': surName,
      'phoneNumber': phoneNumber,
      'userName': userName,
      'adress': adress
    };
  }
}
