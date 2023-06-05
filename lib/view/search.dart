import 'package:flutter/material.dart';

import '../model/utente.dart';
import '../viewmodel/search_viewmodel.dart';
import '../widget/search_box.dart';
import '../widget/search_result_item.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchViewModel _viewModel = SearchViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Cerca',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SearchBox(
              onTextChanged: _viewModel.searchUsers,
              onSearchCancelled: _viewModel.cancelSearch,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Utente>>(
              stream: _viewModel.searchResultsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final searchResults = snapshot.data!;
                  if (searchResults.isEmpty) {
                    return const Center(
                      child: Text('Nessun risultato trovato'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final user = searchResults[index];
                        return SearchResultItem(user: user);
                      },
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('Errore durante la ricerca');
                } else if (_viewModel.isSearching()) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Container(); // Mostra una lista vuota se la ricerca è vuota
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
