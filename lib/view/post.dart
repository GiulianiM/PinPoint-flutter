import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pinpoint/view/bottom_navigation.dart';
import 'package:pinpoint/viewmodel/post_viewmodel.dart';
import 'package:provider/provider.dart';

/// Classe che mostra la pagina di Aggiungi Post
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

class _PostState extends StatefulWidget {
  @override
  State<_PostState> createState() => _PostStateState();
}

class _PostStateState extends State<_PostState> {
  File? _imageFile;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PostViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Carica Post',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.fill,
                child: _imageFile != null
                    ? Image.file(_imageFile!)
                    : Image.asset('assets/images/default.png'),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: TextFormField(
                  controller: viewModel.descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Inserisci una descrizione',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
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
                      onPressed: () async {
                        await selectImage(viewModel);
                      },
                      child: const Text('Sfoglia'),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: isLoading ? null : () async {
                        if (_imageFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Seleziona un\'immagine'),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        try {
                          await viewModel.uploadPost(
                            _imageFile!,
                            viewModel.descriptionController.text,
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const BottomNavigation(),
                            ),
                          );
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Errore durante il caricamento del post'),
                            ),
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator() // Mostra la ProgressBar
                          : const Text('Carica'), // Mostra il testo "Carica"
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Metodo che permette di selezionare un'immagine dalla galleria.
  /// [viewModel] ViewModel che gestisce la pagina
  selectImage(PostViewModel viewModel) async {
    final files = await viewModel.pickImage();
    if (files != null) {
      final cropperFile = await viewModel.crop(file: files);
      if (cropperFile != null) {
        setState(() {
          _imageFile = File(cropperFile.path);
        });
      }
    }
  }
}
