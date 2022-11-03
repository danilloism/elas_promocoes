import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elas_promocoes/promocao.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PromocoesService {
  final CollectionReference _firestoreCollectionRef;
  final Reference _storageRef;

  const PromocoesService({
    required CollectionReference firestoreCollectionRef,
    required Reference storageRef,
  })  : _firestoreCollectionRef = firestoreCollectionRef,
        _storageRef = storageRef;

  Future<void> add({
    required Promocao promocao,
    required Uint8List imageData,
    required String imageExtension,
  }) async {
    final savedDoc = await _firestoreCollectionRef.add(promocao.toJson());

    final uploadedImage = await _storageRef
        .child('imagens/${savedDoc.id}.$imageExtension')
        .putData(imageData);

    final imageUrl = await uploadedImage.ref.getDownloadURL();

    await _firestoreCollectionRef
        .doc(savedDoc.id)
        .update({'img_url': imageUrl});
  }

  Future<void> remove(String id) async {
    final refList = (await _storageRef.child('imagens').listAll()).items;
    final imgRef =
        refList.singleWhere((reference) => reference.name.contains(id));
    await _firestoreCollectionRef.doc(id).delete();
    await imgRef.delete();
  }
}
