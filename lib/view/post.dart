import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pinpoint/utils/constants.dart';
import 'package:pinpoint/view/bottom_navigation.dart';
import 'package:pinpoint/viewmodel/post_viewmodel.dart';
import 'package:provider/provider.dart';

/// Classe che mostra la pagina di Aggiungi Post
class Post extends StatefulWidget {
  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late PostViewModel _viewModel;
  File? _imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _viewModel = PostViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            Constants.addPostViewTitle,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 400,
                width: 400,
                child: _imageFile != null
                    ? Image.file(_imageFile!)
                    : Image.asset('assets/images/default.png'),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _viewModel.descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Inserisci una descrizione',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _viewModel.descriptionController.clear();
                      },
                    ),
                  ),
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await selectImage(_viewModel);
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
                        await _viewModel.uploadPost(
                          _imageFile!,
                          _viewModel.descriptionController.text,
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

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
