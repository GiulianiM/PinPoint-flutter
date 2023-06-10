import 'package:flutter/material.dart';
import 'package:pinpoint/utils/constants.dart';

import '../model/utente.dart';
import '../viewmodel/search_viewmodel.dart';
import '../widget/search_box.dart';
import '../widget/search_result_item.dart';

/// Classe che mostra la pagina di ricerca
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late SearchViewModel _viewModel;

  @override
  void initState() {
    _viewModel = SearchViewModel();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            Constants.searchViewTitle,
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
                      child: const SizedBox.shrink(),
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
                  return const Center(
                    child: const SizedBox.shrink(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
