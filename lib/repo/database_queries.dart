import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:pinpoint/model/user.dart';

class DatabaseQueries {
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('users');

  Future<List<User>> getAllUsersExceptMe() {
    const myId = "HhmFSoYrI4ejNv5mWJuFqbge2Qr2";
    final completer = Completer<List<User>>();

    _usersRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final userList = data.entries
            .where((entry) => entry.key != myId)
            .map((entry) => User(
          username: entry.value['username'] as String?,
          fullName: entry.value['fullName'] as String?,
          image: entry.value['image'] as String?,
          bio: entry.value['bio'] as String?,
          email: entry.value['email'] as String?,
          latitude: entry.value['latitude'] as String?,
          longitude: entry.value['longitude'] as String?,
          uid: entry.value['uid'] as String?,
        ))
            .toList();

        completer.complete(userList);
      }
    });

    return completer.future;
  }




}
