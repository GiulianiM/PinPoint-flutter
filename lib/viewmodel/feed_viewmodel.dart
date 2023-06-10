import 'package:flutter/material.dart';

import '../model/post.dart';
import '../repo/database_queries.dart';

/// ViewModel che gestisce la pagina Feed
class FeedViewModel extends ChangeNotifier {
  final DatabaseQueries _databaseQueries = DatabaseQueries();
  late Stream<List<Post>> _postsStream;

  Stream<List<Post>> get postsStream => _postsStream;

  FeedViewModel() {
    _fetchPosts();
  }

  void _fetchPosts() {
    final utentiStream = _databaseQueries.getAllUsersExceptMeStream();
    _postsStream = utentiStream.asyncExpand((utenti) {
      return _databaseQueries.getAllPostsExceptMineStream(utenti);
    });
    notifyListeners();
  }
}


