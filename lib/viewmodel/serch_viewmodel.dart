import 'dart:async';

import 'package:pinpoint/model/user.dart';
import 'package:flutter/material.dart';

class SearchViewModel {
  final List<User> _users = [
    User(
      username: 'john_doe',
      fullName: 'John Doe',
      profileImage: 'assets/images/default_profile_image.jpg',
    ),
    User(
      username: 'jane_smith',
      fullName: 'Jane Smith',
      profileImage: 'assets/images/default_profile_image.jpg',
    ),
    User(
      username: 'alex_carter',
      fullName: 'Alex Carter',
      profileImage: 'assets/images/default_profile_image.jpg',
    ),
    User(
      username: 'emma_wilson',
      fullName: 'Emma Wilson',
      profileImage: 'assets/images/default_profile_image.jpg',
    ),
    User(
      username: 'mike_johnson',
      fullName: 'Mike Johnson',
      profileImage: 'assets/images/default_profile_image.jpg',
    ),
  ];

  final TextEditingController searchController = TextEditingController();
  final StreamController<List<User>> _searchResultsController =
      StreamController<List<User>>.broadcast();

  Stream<List<User>> get searchResultsStream => _searchResultsController.stream;

  void searchUsers(String query) {
    if(query.isEmpty){
      _searchResultsController.sink.add([]);
      return;
    }
    final searchResults =
        _users.where((user) => user.username.contains(query)).toList();
    _searchResultsController.sink.add(searchResults);
  }

  void cancelSearch() {
    searchController.clear();
    _searchResultsController.sink.add([]);
  }

  bool isSearching() {
    return searchController.text.isNotEmpty;
  }

  void dispose() {
    _searchResultsController.close();
  }
}
