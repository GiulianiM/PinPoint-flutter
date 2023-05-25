import 'package:firebase_database/firebase_database.dart';
import 'package:pinpoint/model/user.dart';

class DatabaseQueries {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('users');

  Future<List<User>> getUsers(String currentUserId) async {
    DatabaseEvent event = await _usersRef.once();
    DataSnapshot snapshot = event.snapshot;
    Map<String, dynamic> usersData = snapshot.value as Map<String, dynamic>;
    List<User> users = [];

    if (usersData != null) {
      usersData.forEach((userId, userData) {
        if (userId != currentUserId) {
          User user = User(
            uid: userId,
            username: userData['username'],
            fullName: userData['fullName'],
            image: userData['image'],
            bio: userData['bio'],
            email: userData['email'],
            latitude: userData['latitude'],
            longitude: userData['longitude'],
          );
          users.add(user);
        }
      });
    }

    return users;
  }
}
