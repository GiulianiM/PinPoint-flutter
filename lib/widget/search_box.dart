import 'package:flutter/material.dart';

/// Widget che mostra la barra di ricerca
class SearchBox extends StatefulWidget {
  final ValueChanged<String> onTextChanged;
  final VoidCallback onSearchCancelled;

  const SearchBox({
    Key? key,
    required this.onTextChanged,
    required this.onSearchCancelled,
  }) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey.shade200,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onSearchCancelled();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onTextChanged,
              decoration: const InputDecoration(
                hintText: 'Cerca utente...',
                border: InputBorder.none,
              ),
              onTap: () {
                setState(() {
                  _hasFocus = true;
                });
              },
              onSubmitted: (value) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ),
          if (_hasFocus)
            IconButton(
              onPressed: () {
                _searchController.clear();
                widget.onTextChanged('');
              },
              icon: const Icon(Icons.clear),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
