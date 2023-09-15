import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_alura/firestore_produtos/helpers/enum_order.dart';
import 'package:firebase_alura/firestore_produtos/model/produto.dart';
import 'package:flutter/material.dart';

class ProductServices {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  addProduct({
    required String listinId,
    required Produto prdouct,
  }) async {
    await fireStore
        .collection('listins')
        .doc(listinId)
        .collection('produtos')
        .doc(prdouct.id)
        .set(prdouct.toMap());
  }

  Future<List<Produto>> refresh({
    required String listinId,
    required OrdemProduto order,
    required bool isDecrescente,
  }) async {
    List<Produto> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await fireStore
        .collection('listins')
        .doc(listinId)
        .collection('produtos')
        .orderBy(order.name, descending: isDecrescente)
        .get();
    for (var doc in snapshot.docs) {
      Produto produto = Produto.fromMap(doc.data());
      if (produto.price != null) {}
      temp.add(produto);
    }

    return temp;
  }

  Future<void> changeProduct({
    required String listinId,
    required Produto product,
  }) async {
    return fireStore
        .collection('listins')
        .doc(listinId)
        .collection('produtos')
        .doc(product.id)
        .update({'isComprado': product.isComprado});
  }

  Future<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>> setupListen({
    required Function refresh,
    required Function showSnackBar,
    required String listinId,
    required OrdemProduto order,
    required bool isDecrescente,
  }) async {
    return fireStore
        .collection('listins')
        .doc(listinId)
        .collection('produtos')
        .orderBy(order.name, descending: isDecrescente)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docChanges.length == 1) {
        for (var change in snapshot.docChanges) {
          Produto product = Produto.fromMap(change.doc.data()!);
          switch (change.type) {
            case DocumentChangeType.added:
              showSnackBar(
                text: 'Produto adicionado: ',
                productName: product.name,
                color: Colors.green,
              );
              break;
            case DocumentChangeType.modified:
              showSnackBar(
                text: 'Produto alterado: ',
                productName: product.name,
                color: Colors.orange,
              );
              break;
            case DocumentChangeType.removed:
              showSnackBar(
                text: 'Produto removido: ',
                productName: product.name,
                color: Colors.red,
              );
              break;
          }
        }
      }

      refresh(snapshot: snapshot);
    });
  }

  Future<void> deleteProduct({
    required String listinId,
    required Produto product,
  }) async {
    return fireStore
        .collection('listins')
        .doc(listinId)
        .collection('produtos')
        .doc(product.id)
        .delete();
  }
}
