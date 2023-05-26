import 'package:flutter/material.dart';
import 'package:pinpoint/model/utente.dart';
import 'package:pinpoint/viewmodel/serch_viewmodel.dart';
import 'package:pinpoint/widget/search_box.dart';
import 'package:pinpoint/widget/search_result_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchViewModel _viewModel = SearchViewModel();

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
            child: StreamBuilder<List<User>>(
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
