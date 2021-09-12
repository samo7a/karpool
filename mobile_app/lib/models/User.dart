class User {
  final String uid;
  final String firstName;
  final String lastName;
  // final String email;
  final String phoneNumber;
  // final String dateOfBirth;
  // final String gender;
  final bool isDriver;
  final bool isVerified;
  final bool isRider;
  final String profileURL;
  final int rating; // change to double later
  User(
      {required this.uid,
      required this.firstName,
      required this.lastName,
      // required this.dateOfBirth,
      // required this.gender,
      required this.isDriver,
      required this.isRider,
      required this.isVerified,
      required this.rating,
      required this.profileURL,
      // required this.email,
      required this.phoneNumber});
}
// (Ahmed) I will add the other fields later.
