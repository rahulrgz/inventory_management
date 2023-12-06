import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../failure.dart';
import '../type_def.dart';
import 'firebase_providers.dart';

final storageRepositoryProvider = Provider((ref) {
  return StorageRepository(firebaseStorage: ref.watch(storageProvider));
});

class StorageRepository {
  final FirebaseStorage _firebaseStorage;
  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required Uint8List? file,
    required File? androidFile,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      final metaData = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(file!, metaData);
      } else {
        uploadTask = ref.putFile(androidFile!, metaData);
      }
      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
