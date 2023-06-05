import 'dart:async';

import 'package:pinpoint/model/utente.dart';
import 'package:flutter/material.dart';
import 'package:pinpoint/repo/database_queries.dart';

class SearchViewModel {
  final TextEditingController searchController = TextEditingController();
  final StreamController<List<Utente>> _searchResultsController =
  StreamController<List<Utente>>.broadcast();

  Stream<List<Utente>> get searchResultsStream => _searchResultsController.stream;

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      _searchResultsController.sink.add([]);
      return;
    }

    final userList = await DatabaseQueries().getAllUsersExceptMeThatMatch(query);
    _searchResultsController.sink.add(userList);
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
