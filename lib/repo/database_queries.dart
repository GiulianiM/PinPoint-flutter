import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:pinpoint/model/post.dart';
import 'package:pinpoint/model/utente.dart';

/// Classe che contiene tutti i metodi per effettuare le query al database
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

  /// Metodo che permette di registrare un utente nel database
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

  /// Metodo che ritorna l'id dell'utente corrente
  Future<String> getCurrentUserUid() async {
    final completer = Completer<String>();
    completer.complete(_auth.currentUser!.uid);
    return completer.future;
  }

  /// Metodo che ritorna le informazioni correnti dell'utente quali:
  /// + username
  /// + fullname
  /// + image
  /// + bio
  /// + email
  /// + latitude
  /// + longitude
  /// + uid
  Stream<Utente> getCurrentUserInfoStream() {
    final usersStreamController = StreamController<Utente>();

    _usersRef.child(_auth.currentUser!.uid).onValue.listen((event) {
      final snapshot = event.snapshot;
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final user = Utente.fromMap(data);
        usersStreamController.add(user);
      }
    });

    return usersStreamController.stream;
  }


  /// Metodo che ritorna le informazioni di un utente dato il suo username
  Stream<List<Utente>> getAllUsersExceptMeThatMatch(String username) {
    final usersStreamController = StreamController<List<Utente>>();

    _usersRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final userList = data.entries
            .where((entry) => entry.key != _auth.currentUser!.uid)
            .where((entry) =>
                entry.value['username'].toString().contains(username))
            .map((entry) => Utente.fromMap(entry.value as Map<dynamic, dynamic>))
            .toList();
        usersStreamController.add(userList);
      }
    });
    return usersStreamController.stream;
  }

  /// Metodo che ritorna tutti gli utenti tranne l'utente corrente come uno stream
  Stream<List<Utente>> getAllUsersExceptMeStream() {
    final usersStreamController = StreamController<List<Utente>>();
    _usersRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final userList = data.entries
            .where((entry) => entry.key != _auth.currentUser!.uid)
            .map((entry) => Utente.fromMap(entry.value as Map<dynamic, dynamic>))
            .toList();

        usersStreamController.add(userList);
      }
    });

    return usersStreamController.stream;
  }

  /// Metodo che ritorna tutti i post degli utenti tranne quelli dell'utente corrente come uno stream
  Stream<List<Post>> getAllPostsExceptMineStream(List<Utente> utenti) {
    final postsStreamController = StreamController<List<Post>>();
    _postsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final postList = <Post>[];

        data.forEach((idUtente, postMap) {
          if (idUtente != _auth.currentUser!.uid) {
            postMap.forEach((idPost, postData) {
              final user =
                  utenti.singleWhere((element) => element.uid == idUtente);
              final post = Post(
                postId: idPost as String?,
                userId: idUtente as String?,
                date: postData['date'] as String?,
                imageUrl: postData['imageUrl'] as String?,
                latitude: postData['latitude'] as String?,
                longitude: postData['longitude'] as String?,
                description: postData['description'] as String?,
                username: user.username,
                userPic: user.image,
              );
              postList.add(post);
            });
          }
        });

        postList.sort((a, b) => b.date!.compareTo(a.date!));

        postsStreamController.add(postList);
      }
    });

    return postsStreamController.stream;
  }

  /// Metodo che ritorna tutti i post dell'utente corrente
  Future<Stream<List<Post>>> getAllMyPostsStream() async {
    final currentUser = await getCurrentUserInfoStream().first;
    final postsStreamController = StreamController<List<Post>>();
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
                userPic: currentUser.image,
              );
              postList.add(post);
            });
          }
        });

        postList.sort((a, b) => b.date!.compareTo(a.date!));

        postsStreamController.add(postList);
      }
    });

    return postsStreamController.stream;
  }

  /// Metodo che salva un post sul database.
  /// [post] è il post da salvare.
  /// Ritorna un Future<void> che indica se l'operazione è andata a buon fine.
  Future<void> savePost(Post post) {
    final Completer<void> completer = Completer<void>();

    _postsRef
        .child(post.userId!)
        .child(getRandomString(10))
        .set(post.toMap())
        .then((_) {
      completer.complete();
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  /// Metodo che ritorna il numero di follower dell'utente corrente.
  /// Ritorna il numero di follower.
  Stream<int> getFollowerCountStream() async* {
    final followersStreamController = StreamController<int>();
    _followsRef
        .child(_auth.currentUser!.uid)
        .child('followers')
        .onValue
        .listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        final followers = Map<String, dynamic>.from(snapshot.value as Map);
        followersStreamController.add(followers.length);
      } else {
        followersStreamController.add(0);
      }
    });

    yield* followersStreamController.stream;
  }



  /// Metodo che ritorna il numero di following dell'utente corrente.
  /// Ritorna il numero di following
  Stream<int> getFollowingCountStream() async* {
    final followingStreamController = StreamController<int>();

    _followsRef
        .child(_auth.currentUser!.uid)
        .child('following')
        .onValue
        .listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        final following = Map<String, dynamic>.from(snapshot.value as Map);
        followingStreamController.add(following.length);
      } else {
        followingStreamController.add(0);
      }
    });

    yield* followingStreamController.stream;
  }



  /// Metodo che ritorna il numero di post dell'utente corrente.
  /// Ritorna il numero di post
  Stream<int> getPostCountStream() async* {
    final postCountStreamController = StreamController<int>();

    _postsRef.child(_auth.currentUser!.uid).onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        final posts = Map<String, dynamic>.from(snapshot.value as Map);
        postCountStreamController.add(posts.length);
      } else {
        postCountStreamController.add(0);
      }
    });

    yield* postCountStreamController.stream;
  }



  /// Metodo che genera una stringa random.
  /// [length] lunghezza della stringa.
  /// Ritorna la stringa generata
  String getRandomString(int length) {
    final random = Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

    return randomString;
  }

  /// Metodo che elimina un post dal database
  void deletePost(String? postId, String date) {
    _postsRef.child(_auth.currentUser!.uid).child(postId!).remove();
    FirebaseStorage.instance
        .ref()
        .child('Post')
        .child(_auth.currentUser!.uid)
        .child('$date.jpg')
        .delete();
  }

  /// Metodo che imposta la posizione dell'utente corrente sul database
  void setNewLocation(LocationData newLocation) {
    _usersRef.child(_auth.currentUser!.uid).update({
      'latitude': newLocation.latitude.toString(),
      'longitude': newLocation.longitude.toString(),
    });
  }
}
