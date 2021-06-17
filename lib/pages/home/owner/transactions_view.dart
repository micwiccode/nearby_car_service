import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_transaction.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/transactions_service.dart';

import 'transactions_list.dart';

class TransactionsView extends StatelessWidget {
  final String workshopUid;

  const TransactionsView({required this.workshopUid, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppTransaction>>(
      stream: AppTransactionsDatabaseService(workshopUid: workshopUid)
          .workshopAppTransactions,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }

        if (snapshot.data == null) {
          return Text('Transaction snapshot errror');
        }

        List<AppTransaction> appTransactions = snapshot.data!;

        return TransactionsList(appTransactions: appTransactions);
      },
    );
  }
}
