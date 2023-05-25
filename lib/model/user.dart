class User {
  final String bio;
  final String email;
  final String fullName;
  final String image;
  final String latitude;
  final String longitude;
  final String uid;
  final String username;

  User({
    required this.username,
    required this.fullName,
    required this.image,
    required this.bio,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.uid,
  });
}
