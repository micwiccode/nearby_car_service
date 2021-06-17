import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_transaction.dart';

import 'transaction_tile.dart';

class TransactionsList extends StatelessWidget {
  final List<AppTransaction> appTransactions;

  const TransactionsList({required this.appTransactions});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: appTransactions.length < 1
            ? Center(child: Text('No transactions'))
            : ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: appTransactions.map((AppTransaction transaction) {
                  return TransactionTile(transaction: transaction);
                }).toList(),
              ));
  }
}
