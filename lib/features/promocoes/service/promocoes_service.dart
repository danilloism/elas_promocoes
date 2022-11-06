import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elas_promocoes/core/const.dart';
import 'package:elas_promocoes/features/promocoes/model/promocao_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PromocoesService {
  final CollectionReference<Map<String, dynamic>> _firestoreCollectionRef;
  final Reference _storageRef;

  const PromocoesService({
    required CollectionReference<Map<String, dynamic>> firestoreCollectionRef,
    required Reference storageRef,
  })  : _firestoreCollectionRef = firestoreCollectionRef,
        _storageRef = storageRef;

  Future<void> add(
    PromocaoModel promocao, {
    required Uint8List imageData,
    required String imageExtension,
  }) async {
    final savedDoc = await _firestoreCollectionRef.add(promocao.toJson());
    final uploadedImage = await _storageRef
        .child('$kImagensStorageRefName/${savedDoc.id}.$imageExtension')
        .putData(imageData);

    final imageUrl = await uploadedImage.ref.getDownloadURL();

    await _firestoreCollectionRef
        .doc(savedDoc.id)
        .update({'img_url': imageUrl});
  }

  Future<void> remove(String id) async {
    final refList =
        (await _storageRef.child(kImagensStorageRefName).listAll()).items;
    final imgRef =
        refList.singleWhere((reference) => reference.name.contains(id));
    await Future.wait([
      _firestoreCollectionRef.doc(id).delete(),
      imgRef.delete(),
    ]);
  }

  Future<void> update(
    PromocaoModel promocao, {
    Uint8List? imageData,
  }) async {
    assert(promocao.id != null);
    if (imageData != null) {
      final refList =
          (await _storageRef.child(kImagensStorageRefName).listAll()).items;
      var imgRef = refList
          .singleWhere((reference) => reference.name.contains(promocao.id!));
      await imgRef.putData(imageData);
    }

    await _firestoreCollectionRef.doc(promocao.id!).update(promocao.toJson());
  }

  Stream<List<PromocaoModel>> get stream {
    final snapshots = _firestoreCollectionRef.snapshots();
    return snapshots.map(
      (event) => event.docs
          .map((document) =>
              PromocaoModel.fromJson(data: document.data(), id: document.id))
          .toList()
        ..sort((a, b) => b.criadoEm!.compareTo(a.criadoEm!)),
    );
  }
}
