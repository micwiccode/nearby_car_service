import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/app_transaction.dart';

class AppTransactionsDatabaseService {
  final String workshopUid;
  AppTransactionsDatabaseService({required this.workshopUid});
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('transactions');

  Future createAppTransaction(AppTransaction transaction) async {
    return collection.add({
      'orderUid': transaction.orderUid,
      'workshopUid': transaction.workshopUid,
      'price': transaction.price,
    });
  }

  Stream<List<AppTransaction>> get workshopAppTransactions {
    return collection
        .where("workshopUid", isEqualTo: workshopUid)
        .snapshots()
        .map(_transactionsFromSnapshot);
  }

  List<AppTransaction> _transactionsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((order) {
      return _mapAppTransaction(order);
    }).toList();
  }

  AppTransaction _mapAppTransaction(order) {
    return AppTransaction(
      uid: order.id,
      workshopUid: order.data()!['workshopUid'] ?? '',
      orderUid: order.data()!['orderUid'] ?? '',
      price: order.data()!['price'] ?? '',
    );
  }
}
