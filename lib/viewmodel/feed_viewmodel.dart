import 'package:flutter/cupertino.dart';

import '../model/post.dart';
import '../repo/database_queries.dart';

class FeedViewModel extends ChangeNotifier{

  Future<List<Post>> fetchPosts() async {
    final utenti = await DatabaseQueries().getAllUsersExceptMe();
    final posts = await DatabaseQueries().getAllPostsExceptMine(utenti);
    return posts;
  }

}