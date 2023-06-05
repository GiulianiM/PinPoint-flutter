import 'package:flutter/material.dart';
import 'package:pinpoint/model/utente.dart';
import 'package:pinpoint/repo/database_queries.dart';
import 'package:pinpoint/model/post.dart';

class ProfileViewModel extends ChangeNotifier {
  DatabaseQueries databaseQueries = DatabaseQueries();
  int followerCount = 0;
  int followingCount = 0;
  int postCount = 0;
  Utente utente = Utente();
  List<Post> posts = <Post>[];
  final String defaultIcon =
      'https://firebasestorage.googleapis.com/v0/b/pinpointmvvm.appspot.com/o/Default%20Images%2FProfilePicture.png?alt=media&token=780391e3-37ee-4352-8367-f4c08b0f809d';

  void fetchData() async {
    try {
      final thatUser = await databaseQueries.getCurrentUserInfo();
      utente = thatUser;

      final thosePosts = await databaseQueries.getAllMyPosts();
      posts = thosePosts;

      final thatFollowerCount = await databaseQueries.getFollowerCount();
      followerCount = thatFollowerCount;

      final thatFollowingCount = await databaseQueries.getFollowingCount();
      followingCount = thatFollowingCount;

      final thatPostCount = await databaseQueries.getPostCount();
      postCount = thatPostCount;

      notifyListeners();
    } catch (error) {
      // Gestione dell'errore
      print('Errore durante il recupero dei dati: $error');
    }
  }
}