import 'package:flutter/material.dart';
import 'package:pinpoint/model/utente.dart';

class SearchResultItem extends StatelessWidget {
  final Utente user;

  const SearchResultItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.image!),
      ),
      title: Text(user.username!),
      subtitle: Text(user.fullname!),
    );
  }
}