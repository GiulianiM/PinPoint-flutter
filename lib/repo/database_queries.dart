import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:pinpoint/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinpoint/model/utente.dart';

class DatabaseQueries {
  final DatabaseReference _followsRef =
      FirebaseDatabase.instance.ref().child('follows');
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

  Future<Utente> getCurrentUserInfo() {
    final completer = Completer<Utente>();

    _usersRef.child(_auth.currentUser!.uid).once().then((snapshot) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final user = Utente(
          username: data['username'] as String?,
          fullname: data['fullname'] as String?,
          image: data['image'] as String?,
          bio: data['bio'] as String?,
          email: data['email'] as String?,
          latitude: data['latitude'] as String?,
          longitude: data['longitude'] as String?,
          uid: data['uid'] as String?,
        );
        completer.complete(user);
      }
    });
    return completer.future;
  }

  Future<List<Utente>> getAllUsersExceptMeThatMatch(String username) {
    final completer = Completer<List<Utente>>();

    _usersRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final userList = data.entries
            .where((entry) => entry.key != _auth.currentUser!.uid)
        .where((entry) => entry.value['username'].toString().contains(username))
            .map((entry) => Utente(
          username: entry.value['username'] as String?,
          fullname: entry.value['fullname'] as String?,
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

  Future<List<Utente>> getAllUsersExceptMe() {
    final completer = Completer<List<Utente>>();

    _usersRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final userList = data.entries
            .where((entry) => entry.key != _auth.currentUser!.uid)
            .map((entry) => Utente(
                  username: entry.value['username'] as String?,
                  fullname: entry.value['fullname'] as String?,
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

  Future<List<Post>> getAllPostsExceptMine(List<Utente> utenti) async {
    final completer = Completer<List<Post>>();

    _postsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final postList = <Post>[];

        data.forEach((idUtente, postMap) {
          if (idUtente != _auth.currentUser!.uid) {
            postMap.forEach((idPost, postData) {
              final user = utenti.singleWhere((element) =>
              element.uid == idUtente);
              final post = Post(
                postId: idPost,
                userId: idUtente as String?,
                date: postData['date'] as String?,
                imageUrl: postData['imageUrl'] as String?,
                latitude: postData['latitude'] as String?,
                longitude: postData['longitude'] as String?,
                description: postData['description'] as String?,
                username: user.username,
                userPic: user.image
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

  Future<List<Post>> getAllMinePosts() async {
    final currentUser = await getCurrentUserInfo();
    final completer = Completer<List<Post>>();

    _postsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final postList = <Post>[];

        data.forEach((idUtente, postMap) {
          if (idUtente == _auth.currentUser!.uid) {
            postMap.forEach((idPost, postData) {
              final post = Post(
                  postId: idPost,
                  userId: idUtente as String?,
                  date: postData['date'] as String?,
                  imageUrl: postData['imageUrl'] as String?,
                  latitude: postData['latitude'] as String?,
                  longitude: postData['longitude'] as String?,
                  description: postData['description'] as String?,
                  username: currentUser.username,
                  userPic: currentUser.image
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

  Future<void> savePost(Post post) {
    final Completer<void> completer = Completer<void>();

    _postsRef.child(post.userId!).set(post.toMap()).then((_) {
      completer.complete();
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  Future<int> getFollowerCount() async {
    DataSnapshot snapshot = await _followsRef.child(_auth.currentUser!.uid).child('followers').get();
    if (snapshot.value != null && snapshot.value is Map) {
      Map<String, dynamic> followers = Map<String, dynamic>.from(snapshot.value as Map);
      return followers.length;
    }
    return 0;
  }

  Future<int> getFollowingCount() async {
    DataSnapshot snapshot = await _followsRef.child(_auth.currentUser!.uid).child('following').get();
    if (snapshot.value != null && snapshot.value is Map) {
      Map<String, dynamic> followers = Map<String, dynamic>.from(snapshot.value as Map);
      return followers.length;
    }
    return 0;
  }

  Future<int> getPostCount() async {
    DataSnapshot snapshot = await _postsRef.child(_auth.currentUser!.uid).get();
    if (snapshot.value != null && snapshot.value is Map) {
      Map<String, dynamic> posts = Map<String, dynamic>.from(snapshot.value as Map);
      return posts.length;
    }
    return 0;
  }
}
