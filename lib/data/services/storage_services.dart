import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  Future<String> uploadImageToStorge(File? imageFile, String imageId) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('image_$imageId');
    TaskSnapshot taskSnapshot = await ref.putFile(imageFile!);
    return await taskSnapshot.ref.getDownloadURL();
    //الفرق بين uploadTask و TaskSnapshot ال await
  }
}
