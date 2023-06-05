import 'package:flutter/material.dart';

import '../model/post.dart';
import '../repo/database_queries.dart';

/// ViewModel che gestisce la pagina Feed
class FeedViewModel extends ChangeNotifier{

  /// Metodo che permette di ottenere tutti i post
  Future<List<Post>> fetchPosts() async {
    final utenti = await DatabaseQueries().getAllUsersExceptMe();
    final posts = await DatabaseQueries().getAllPostsExceptMine(utenti);
    return posts;
  }

}