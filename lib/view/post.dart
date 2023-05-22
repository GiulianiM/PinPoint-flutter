import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pinpoint/viewmodel/post_viewmodel.dart';

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
            Image(
                image: viewModel.imageProvider ??
                    const AssetImage(
                        'assets/images/default_profile_image.jpg')),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: viewModel.descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Inserisci una descrizione',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: viewModel.pickImageFromGallery,
                  child: const Text('Sfoglia'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: viewModel.uploadPost,
                  child: const Text('Carica'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
