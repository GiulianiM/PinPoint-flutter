import 'package:flutter/material.dart';
import 'package:pinpoint/model/user.dart';

class SearchResultItem extends StatelessWidget {
  final User user;

  const SearchResultItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(user.image!),
      ),
      title: Text(user.username!),
      subtitle: Text(user.fullName!),
    );
  }
}