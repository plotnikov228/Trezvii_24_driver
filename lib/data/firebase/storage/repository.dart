import 'dart:io';

import 'package:trezvii_24_driver/domain/firebase/storage/models/cloud_storage_result.dart';

import '../../../domain/firebase/storage/repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageRepositoryImpl extends FirebaseStorageRepository {

  @override
  Future<CloudStorageResult> uploadImageToCloudStorage(File file, String fileName, String folder) async {
    var imageFileName = '$folder/$fileName';
    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child(imageFileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(file);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
    var downloadUrl = await storageSnapshot.ref.getDownloadURL();
    var url = downloadUrl.toString();
    return CloudStorageResult(
      imageUrl: url,
      imageFileName: imageFileName,
    );
  }

  @override
  Future<String?> getPhotoById({required String id}) async {
    try {
      return await FirebaseStorage.instance.ref(
          '$id/photo')
          .getDownloadURL();
    } catch (_) {
    }
  }

}