import 'package:flutter/material.dart';
import 'package:pinpoint/viewmodel/post_viewmodel.dart';
import 'package:provider/provider.dart';

class Post extends StatelessWidget {
  const Post({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostViewModel(),
      child: _PostState(),
    );
  }
}

class _PostState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PostViewModel>(context);

    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text('Carica Post',
                  style: TextStyle(fontWeight: FontWeight.bold)))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image(
                image: viewModel.imageProvider ??
                    const AssetImage('assets/images/default.png'),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: TextFormField(
                controller: viewModel.descriptionController,
                decoration: InputDecoration(
                  hintText: 'Inserisci una descrizione',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      viewModel.descriptionController.clear();
                    },
                  ),
                ),
                maxLines: 2,
              ),

            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: viewModel.pickImageFromGallery,
                    child: const Text('Sfoglia'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.uploadPost(
                        viewModel.imageProvider!,
                        viewModel.descriptionController.text
                      );
                    },
                    child: const Text('Carica'),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
