import 'package:flutter/material.dart';
import 'package:pinpoint/widget/post_widget.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(
                child: Text('Feed',
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        body: const PostWidget());
  }
}
