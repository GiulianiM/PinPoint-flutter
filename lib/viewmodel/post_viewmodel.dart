import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';

import '../model/post.dart';
import '../repo/database_queries.dart';

class PostViewModel extends ChangeNotifier {
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseQueries _databaseQueries = DatabaseQueries();
  LocationData? currentLocation;
  Location location = Location();

  TextEditingController get descriptionController => _descriptionController;

  PostViewModel({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();
  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  Future<XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 50,
  }) async {
    final file = await _imagePicker.pickImage(
      source: source,
      imageQuality: imageQuality,
    );

    if (file != null) return file;
    return null;
  }

  Future<CroppedFile?> crop({
    required XFile file,
  }) async =>
      await _imageCropper.cropImage(
        sourcePath: file.path,
        cropStyle: CropStyle.rectangle,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            lockAspectRatio: true,
            hideBottomControls: true,
          ),
        ],
      );

  Future uploadPost(
    File image,
    String description,
  ) async {
    currentLocation = await location.getLocation();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd-hh-mm-ss').format(now);
    Post post = Post(
      userId: await _databaseQueries.getCurrentUserUid(),
      description: description,
      latitude: currentLocation!.latitude.toString(),
      longitude: currentLocation!.longitude.toString(),
      date: formattedDate,
    );

    String imageUrl = await uploadImage(image, post.userId!, formattedDate);
    post.imageUrl = imageUrl;

    await _databaseQueries.savePost(post);
  }

  Future<String> uploadImage(
      File image, String uid, String formattedDate) async {
    final storage = FirebaseStorage.instance;
    File imageFile = await convertImageToFile(image);
    String fileName = '$formattedDate.jpg';
    TaskSnapshot snapshot =
        await storage.ref().child('Post/$uid/$fileName').putFile(imageFile);
    String imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  Future<File> convertImageToFile(File image) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filePath = '$tempPath/temp.png';
    File imageFile = File(image.path);
    await imageFile.copy(filePath);
    return File(filePath);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
