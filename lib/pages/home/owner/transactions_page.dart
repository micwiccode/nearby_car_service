import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:provider/provider.dart';

import 'transactions_view.dart';

class TransactionsMenuPage extends StatefulWidget {
  const TransactionsMenuPage({Key? key}) : super(key: key);

  @override
  _TransactionsMenuPageState createState() => _TransactionsMenuPageState();
}

class _TransactionsMenuPageState extends State<TransactionsMenuPage> {
  @override
  Widget build(BuildContext context) {
    final workshop = Provider.of<Workshop?>(context);

    if (workshop == null) {
      return Text('No transactions');
    }

    return Scaffold(
      body: TransactionsView(workshopUid: workshop.uid),
    );
  }
}
