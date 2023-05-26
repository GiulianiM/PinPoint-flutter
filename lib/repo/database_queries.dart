import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:pinpoint/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinpoint/model/utente.dart';

class DatabaseQueries {
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('users');
  final DatabaseReference _postsRef =
      FirebaseDatabase.instance.ref().child('posts');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final email = "prova@prova.com";
  final password = "prova123";

  Future<bool> loginWithEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Utente>> getAllUsersExceptMe() {
    final completer = Completer<List<Utente>>();

    _usersRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final userList = data.entries
            .where((entry) => entry.key != _auth.currentUser!.uid)
            .map((entry) => Utente(
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

  Future<List<Post>> getAllPostsExceptMine() async {
    final completer = Completer<List<Post>>();

    _postsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final postList = <Post>[];

        data.forEach((idUtente, postMap) {
          if (idUtente != _auth.currentUser!.uid) {
            postMap.forEach((idPost, postData) {
              final post = Post(
                postId: idPost,
                userId: idUtente as String?,
                date: postData['date'] as String?,
                imageUrl: postData['imageUrl'] as String?,
                latitude: postData['latitude'] as String?,
                longitude: postData['longitude'] as String?,
                description: postData['description'] as String?,
              );
              postList.add(post);
            });
          }
        });

        completer.complete(postList);
      }
    });
    final List<Post> postList = await completer.future;
    return postList;
  }
}
