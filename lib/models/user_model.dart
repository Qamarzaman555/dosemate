class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? dob;
  String? phoneNumber;
  String? gender;
  String? address;
  String? profilePictureUrl;
  String? uid;

  UserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.dob,
    this.phoneNumber,
    this.gender,
    this.address,
    this.uid,
    this.profilePictureUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'email': email,
      'address': address,
      'profilePictureUrl': profilePictureUrl,
      'uid': uid,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      dob: json['dob'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      email: json['email'],
      address: json['address'],
      profilePictureUrl: json['profilePictureUrl'],
      uid: json['uid'],
    );
  }
}
