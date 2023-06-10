import 'package:flutter/material.dart';
import 'package:pinpoint/model/post.dart';
import 'package:pinpoint/viewmodel/feed_viewmodel.dart';
import 'package:pinpoint/widget/post_widget.dart';

/// Classe che mostra la pagina Feed
class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late FeedViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = FeedViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Feed',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: StreamBuilder<List<Post>>(
        stream: _viewModel.postsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostWidget(post: post, isProfile: false);
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

