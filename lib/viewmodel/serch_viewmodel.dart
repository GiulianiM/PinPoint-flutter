import 'dart:async';

import 'package:pinpoint/model/user.dart';
import 'package:flutter/material.dart';

class SearchViewModel {
  late final List<User> _users;
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
        _users.where((user) => user.username!.contains(query)).toList();
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