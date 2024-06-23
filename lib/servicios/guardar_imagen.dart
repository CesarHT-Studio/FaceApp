import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<bool> uploadImage(File image) async{
  print(image.path);
  final String namefile = image.path.split("/").last;

  Reference ref = storage.ref().child("images").child(namefile);
  final UploadTask uploadTask = ref.putFile(image);
  print(uploadTask);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  print(snapshot);

  final String url = await snapshot.ref.getDownloadURL();
  print(url);
  //funcion que se conecte con el api, que envie 2 variables: primero que ya quenga foto y segunfdo enviar la url
  return false;
}

Future<String?> uploadImageAndGetUrl(File imageFile) async {
    try {
      final Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().toString()}.png');
      final UploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() {});

      final String downloadUrl = await storageReference.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error al subir la imagen: $e');
      return null;
    }
  }