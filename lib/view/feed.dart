import 'package:flutter/material.dart';
import 'package:pinpoint/model/post.dart';
import 'package:pinpoint/repo/database_queries.dart';
import 'package:pinpoint/widget/post_widget.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<Post> _postList = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() async {
    final posts = await DatabaseQueries()
        .getAllUsersExceptMe()
        .then((utenti) => DatabaseQueries().getAllPostsExceptMine(utenti));
    setState(() {
      _postList = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Feed', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      body: ListView.builder(
        itemCount: _postList.length,
        itemBuilder: (context, index) {
          final post = _postList[index];
          return PostWidget(post: post);
        },
      ),
    );
  }
}
