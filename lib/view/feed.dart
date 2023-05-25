import 'package:flutter/material.dart';
import 'package:pinpoint/model/post.dart';
import 'package:pinpoint/repo/database_queries.dart';

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
    final posts = await DatabaseQueries().getAllPostsExceptMine();
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
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.userId ?? '',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(post.description ?? ''),
              ],
            ),
          );
        },
      ),
    );
  }
}
