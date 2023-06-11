import 'dart:async';

import 'package:pinpoint/model/utente.dart';
import 'package:flutter/material.dart';
import 'package:pinpoint/repo/database_queries.dart';

/// ViewModel che gestisce la pagina di ricerca
class SearchViewModel {
  final TextEditingController searchController = TextEditingController();
  final StreamController<List<Utente>> _searchResultsController = StreamController<List<Utente>>();

  Stream<List<Utente>> get searchResultsStream => _searchResultsController.stream;

  /// Metodo che permette di ottenere tutti gli utenti che corrispondono alla query.
  /// [query] Query da cercare
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      _searchResultsController.sink.add([]);
      return;
    }

    final thatUser = await DatabaseQueries().getAllUsersExceptMeThatMatch(query);
    thatUser.listen((user) {
      _searchResultsController.add(user);
    });
  }

  /// Metodo che permette di cancellare la ricerca. Svuota la lista degli utenti.
  void cancelSearch() {
    searchController.clear();
    _searchResultsController.add([]);
  }

  /// Metodo che permette di ottenere se la ricerca è attiva, ossia se l'utente sta digitando qualcosa.
  bool isSearching() {
    return searchController.text.isNotEmpty;
  }

  /// Metodo che permette di chiudere lo stream.
  void dispose() {
    _searchResultsController.close();
  }
}
