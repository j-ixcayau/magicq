import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

class UploadImage {
  static Future<List<String>> uploadImages(
      List<(XFile, Uint8List)> photos) async {
    List<String> uploadedImageUrls = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    for (var photo in photos) {
      try {
        final newBytes = await FlutterImageCompress.compressWithList(
          photo.$2,
          quality: 45,
        );

        final mime = lookupMimeType(photo.$1.name, headerBytes: newBytes);
        final ext = extensionFromMime(mime ?? '');

        final fileName = '${const Uuid().v1()}.$ext';

        Reference ref = storage.ref().child('uploads/$fileName');

        // Upload the image to Firebase Storage
        UploadTask uploadTask = ref.putData(
          newBytes,
          SettableMetadata(
            contentType: mime,
          ),
        );

        // Get the download URL after the upload completes
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        uploadedImageUrls.add(downloadUrl);
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    return uploadedImageUrls;
  }
}
