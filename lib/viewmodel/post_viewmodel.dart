import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';

import '../model/post.dart';
import '../repo/database_queries.dart';

class PostViewModel extends ChangeNotifier {
  late ImagePicker _imagePicker;
  ImageProvider<Object>? _imageProvider;
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseQueries _databaseQueries = DatabaseQueries();
  LocationData? currentLocation;
  Location location = Location();

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

  void uploadPost(
      ImageProvider<Object> image,
      String description,
      ) async {
    currentLocation = await location.getLocation();
    Post post = Post(
      userId: await _databaseQueries.getCurrentUserUid(),
      description: description,
      latitude: currentLocation!.latitude.toString(),
      longitude: currentLocation!.longitude.toString(),
      date: DateTime.now().toString(),
    );

    // Carica l'immagine su Firebase Storage
    String imageUrl = await uploadImage(image, post.userId!);

    // Imposta l'URL dell'immagine come parametro 'immagine' del post
    post.imageUrl = imageUrl;

    await _databaseQueries.savePost(post);
  }

  Future<String> uploadImage(ImageProvider<Object> image, String uid) async {
    final storage = FirebaseStorage.instance;

    // Converti l'ImageProvider in un'istanza di File
    File imageFile = await convertImageToFile(image);

    // Genera un nome univoco per l'immagine
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Carica l'immagine su Firebase Storage
    TaskSnapshot snapshot = await storage
        .ref()
        .child('Post/$uid/$fileName')
        .putFile(imageFile);

    // Ottieni l'URL dell'immagine caricata
    String imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  Future<File> convertImageToFile(ImageProvider<Object> image) async {
    // Ottieni il percorso temporaneo per salvare l'immagine
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    // Crea il percorso del file temporaneo
    String filePath = '$tempPath/temp.png';

    // Ottieni il file dell'immagine dal percorso dell'ImageProvider
    File imageFile = File((image as FileImage).file.path);

    // Copia l'immagine nel file temporaneo
    await imageFile.copy(filePath);

    return File(filePath);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
