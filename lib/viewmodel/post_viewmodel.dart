import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostViewModel extends ChangeNotifier {
  late ImagePicker _imagePicker;
  ImageProvider<Object>? _imageProvider;
  final TextEditingController _descriptionController = TextEditingController();

  PostViewModel() {
    _imagePicker = ImagePicker();
    _imageProvider =
        const AssetImage('assets/images/default_profile_image.jpg');
  }

  ImageProvider<Object>? get imageProvider => _imageProvider;
  TextEditingController get descriptionController => _descriptionController;

  void pickImageFromGallery() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _imageProvider = FileImage(File(pickedImage.path));
      notifyListeners();
    }
  }

  void uploadPost() async {
    // Implementa l'azione di caricamento del post
    // Utilizza il testo nel campo di descrizione (_descriptionController.text)
    // e l'immagine selezionata (_imageProvider) per caricare il post sul profilo dell'utente
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
