import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadServices {
  static Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      // Firebase Storage referansını oluştur
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');

      // Dosyayı Firebase Storage'a yükle
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Yüklenen dosyanın indirme URL'sini al
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      print('Image uploaded to Firebase Storage, download URL: $downloadURL');
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
