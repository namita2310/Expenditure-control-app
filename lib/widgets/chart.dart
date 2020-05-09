import "package:flutter/material.dart";
import '../widgets/chart_bar.dart';
import '../models/transaction.dart';
import "package:intl/intl.dart";

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalsum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.year == weekday.year &&
            recentTransactions[i].date.month == weekday.month) {
          totalsum += recentTransactions[i].amount;
        }
      }
      print(totalsum);
      print(DateFormat.E().format(weekday));
      return {
        "day": DateFormat.E().format(weekday).substring(0, 1),
        "amount": totalsum
      };
    }).reversed.toList();
  }

  double get totSpending {
    return groupedTransactionValues.fold(
      0.0,
      (sum, item) {
        return sum + item["amount"];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:MediaQuery.of(context).size.height*0.3,
      child: Card(
          elevation: 6,
          margin: EdgeInsets.all(20),
          child: Container(
            padding:EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: groupedTransactionValues.map(
              (data) {
                return Flexible(
                  fit: FlexFit.tight,
                              child: ChartBar(label: data['day'],spendingAmount: data["amount"],
                      spendingPctOfTotal:totSpending==0.0?0.0:(data["amount"] as double) / totSpending),
                );
              },
            ).toList()),
          )),
    );
  }
}
