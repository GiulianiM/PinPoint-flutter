import 'package:flutter/material.dart';
import 'package:pinpoint/model/post.dart';
import 'package:pinpoint/repo/database_queries.dart';
import 'package:pinpoint/viewmodel/feed_viewmodel.dart';
import 'package:pinpoint/widget/post_widget.dart';
import 'package:provider/provider.dart';

class Feed extends StatelessWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FeedViewModel>(
      create: (_) => FeedViewModel(),
      child: Consumer<FeedViewModel>(
        builder: (context, viewModel, _) {
          return _FeedState(viewModel: viewModel);
        },
      ),
    );
  }
}
class _FeedState extends StatefulWidget {
  final FeedViewModel viewModel;
  const _FeedState({required this.viewModel});

  @override
  State<_FeedState> createState() => _FeedStateState();
}

class _FeedStateState extends State<_FeedState> {
  late List<Post> _postList = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final posts = await widget.viewModel.fetchPosts();
      if (mounted) {
        setState(() {
          _postList = posts;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
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
      body: ListView.builder(
        itemCount: _postList.length,
        itemBuilder: (context, index) {
          final post = _postList[index];
          return PostWidget(post: post, isProfile: false);
        },
      ),
    );
  }
}
