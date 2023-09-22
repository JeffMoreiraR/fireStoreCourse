import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_alura/firestore/models/listin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListinServicie {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  void newListin({required Listin listin}) async {
    _fireStore.collection(uid).doc(listin.id).set(listin.toMap());
  }

  Future<List<Listin>> refresh() async {
    List<Listin> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _fireStore.collection(uid).get();

    for (var doc in snapshot.docs) {
      temp.add(Listin.fromMap(doc.data()));
    }

    return temp;
  }

  void removeListin({required Listin model}) async {
    _fireStore.collection(uid).doc(model.id).delete();
  }
}
