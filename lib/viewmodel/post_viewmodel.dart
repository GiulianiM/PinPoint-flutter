import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/post.dart';
import '../repo/database_queries.dart';

class PostViewModel extends ChangeNotifier {
  late ImagePicker _imagePicker;
  ImageProvider<Object>? _imageProvider;
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseQueries _databaseQueries = DatabaseQueries();

  PostViewModel() {
    _imagePicker = ImagePicker();
    _imageProvider =
        const AssetImage('assets/images/default.png');
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
    //TODO Crea il post qui
    Post post = Post();
    await _databaseQueries.savePost(post);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
