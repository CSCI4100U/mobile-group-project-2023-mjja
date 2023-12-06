import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/views/transactions.dart';

import '../models/transaction_model.dart';

class FinancialInsightsPage extends StatefulWidget {
  const FinancialInsightsPage({super.key});

  @override
  _FinancialInsightsState createState() => _FinancialInsightsState();
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({Key? key, required this.color, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          SizedBox(width: 8),
          Text(text,
              style: TextStyle(fontSize: 7, color: Colors.white)),
        ],
      ),
    );
  }
}

class _FinancialInsightsState extends State<FinancialInsightsPage> {
  int touchedIndex = -1;
  List<Transaction_data> transactions = [];
  TransactionDatabase transactionDatabase = TransactionDatabase();

  // Map to associate each category with a color
  Map<String, Color> categoryColors = {
    'Food': Colors.cyanAccent,
    'Shopping': Colors.lightBlueAccent,
    'Travel': Colors.greenAccent,
    'Bills': Colors.lightBlueAccent,
    'Education': Colors.indigoAccent,
    'Subscriptions': Colors.redAccent,
    'Home': Colors.deepOrangeAccent,
    'Other': Colors.orangeAccent,
  };

  // Expense or Income mode
  bool showExpenses = true;

  @override
  void initState() {
    super.initState();
    // Fetch transactions when the widget is initialized
    fetchTransactions();
  }

  // Function to fetch transactions from Firebase
  void fetchTransactions() async {
    try {
      List<Transaction_data> fetchedTransactions = await transactionDatabase
          .readAllTransactions();
      print("the fetched transactions: ${fetchedTransactions}");
      setState(() {
        transactions = fetchedTransactions;
      });
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ToggleButtons(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Expenses',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Income',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            onPressed: (int index) {
              setState(() {
                showExpenses = index == 0;
              });
            },
            isSelected: [showExpenses, !showExpenses],
          ),
        ),
        Expanded(
          child: showExpenses ? buildExpenseChart() : buildIncomeChart(),
        ),
      ],
    );
  }


  Widget buildExpenseChart() {
    return AspectRatio(
        aspectRatio: 1.3,
        child: Row(
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse.touchedSection!
                                .touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 5,
                      centerSpaceRadius: 40,
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              buildLegend(),
            ]
        )
    );
  }

  //widget to shoe legend beside the pie chart
  Widget buildLegend() {
    Set<String> uniqueCategories = transactions
        .where((transaction) => transaction.category != "Income")
        .map((transaction) => transaction.category!)
        .toSet();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: uniqueCategories
          .map((category) =>
          LegendItem(
            color: categoryColors[category] ?? Colors.black,
            text: category,
          ))
          .toList(),
    );
  }

  //method to calculate the area of each section on pie chart based on category
  List<PieChartSectionData> showingSections() {
    Map<String, double> categoryAmounts = {};

    transactions.forEach((transaction) {
      if (transaction.category != null && transaction.amount != null &&
          transaction.category != "Income") {
        categoryAmounts.update(
            transaction.category!, (value) => value + transaction.amount!,
            ifAbsent: () => transaction.amount!);
      }
    });

    return List.generate(categoryAmounts.length, (i) {
      final category = categoryAmounts.keys.elementAt(i);
      final amount = categoryAmounts[category]!;
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: categoryColors[category] ?? Colors.black,
        value: amount,
        title: '${(amount / (getTotalAmount() - getTotalIncome()) * 100)
            .toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Adjust the color as needed
          shadows: shadows,
        ),
      );
    });
  }

  // method to calculate total amount
  double getTotalAmount() {
    double totalAmount = 0;
    transactions.forEach((transaction) {
      totalAmount += transaction.amount!;
    });
    return totalAmount;
  }

  //method to calculate total income
  double getTotalIncome() {
    double totalIncome = 0;
    transactions.where((transaction) => transaction.category == "Income")
        .forEach((transaction) {
      totalIncome += transaction.amount!;
    });
    return totalIncome;
  }

// Helper function to group transactions by week
  Map<int, List<Transaction_data>> groupTransactionsByWeek(
      List<Transaction_data> transactions) {
    return transactions.fold(
        <int, List<Transaction_data>>{}, (map, transaction) {
      int week = getWeekNumber(transaction.date!);
      if (!map.containsKey(week)) {
        map[week] = [];
      }
      map[week]!.add(transaction);
      return map;
    });
  }

// Helper function to get the week number from a DateTime
  int getWeekNumber(DateTime date) {
    return ((date
        .difference(DateTime(2023, 11, 1))
        .inDays) / 7).ceil();
  }

  Widget buildIncomeChart() {
    // Group transactions by week
    Map<int, List<Transaction_data>> transactionsByWeek =
    groupTransactionsByWeek(transactions);

    // Extract data for total expenses and total income for each week
    List<BarChartGroupData> barGroups =
    transactionsByWeek.keys.map((week) {
      double totalExpenses = 0;
      double totalIncome = 0;

      transactionsByWeek[week]!.forEach((transaction) {
        if (transaction.amount! < 0) {
          totalExpenses += transaction.amount!;
        } else {
          totalIncome += transaction.amount!;
        }
      });

      return BarChartGroupData(
        x: week.toInt(),
        barRods: [
          BarChartRodData(
            toY: totalExpenses.abs(),
            color: Colors.redAccent,
          ),
          BarChartRodData(
            toY: totalIncome,
            color: Colors.greenAccent,
          ),
        ],
      );
    }).toList();

    return Column(
      children: [
        // You can customize this container to add labels or any other information
        Container(
          height: 20, // Adjust the height as needed
          child: Center(
            child: Text(
              'Income Chart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              alignment: BarChartAlignment.spaceAround,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 10,
                    interval: 500,
                ),
              ),
              ),
              borderData: FlBorderData(show: true),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.blueAccent,
                ),
              ),
              gridData: FlGridData(show: false),
            ),
          ),
        ),
      ],
    );

  }

}
