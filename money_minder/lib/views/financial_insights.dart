//Acknowledgments
//The code in this project was developed with the assistance of an AI tool (cited below)
//OpenAI. (2023). ChatGPT [Large language model]. https://chat.openai.com

/// File: financial_insights.dart
/// Description: A Flutter Dart file containing the implementation of A StatefulWidget that
/// provides financial insights by visualizing transaction data
/// in the form of charts.

/// It displays two types of charts:
/// - A pie chart for expenses, categorized by the type of expense.
/// - A bar chart for income and expenses, grouped by week.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/views/transactions_page.dart';
import 'custom_navigation.dart';
import '../models/transaction_model.dart';

class FinancialInsightsPage extends StatefulWidget {
  const FinancialInsightsPage({super.key});

  @override
  _FinancialInsightsState createState() => _FinancialInsightsState();
}

final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB);
final Color textColor = Colors.white;

/// A StatelessWidget that represents a single legend item in the pie chart.
/// each colour represents a different category of expenses
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
              style: TextStyle(fontSize: 15, color: Colors.white)),
        ],
      ),
    );
  }
}

/// The State class for the financial insights page which manages the state
/// of the charts and handles the fetching and displaying of transaction data.
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

///mode to view pie chart or bar graph
  bool showPieChart = true;

  @override
  void initState() {
    super.initState();
    // Fetch transactions when the widget is initialized
    fetchTransactions();
  }

  /// Function to fetch transactions from Firebase
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
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 28,
          ),
          //implement toggle button to change view for type of chart
          Center(
            child: ToggleButtons(
              fillColor: Colors.white,
              selectedColor: purpleColor,
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Text(
                    'Expenses breakdown',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Transactions in-and-out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),

                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  showPieChart = index == 0;
                });
              },
              isSelected: [showPieChart, !showPieChart],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: showPieChart ? buildPieChart() : buildTransactionChart(),
          ),
        ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Set the current index to Financial Insights
        onTap: (index) { // Handle bottom navigation bar item taps
      },
    ),

    );
  }

  /// Builds the bar chart for income and expenses by week.
  ///
  /// The chart is created with grouped bars representing income and expenses side by side
  /// for each week to compare the two values visually.
  Widget buildPieChart() {
    double chartAspectRatio = 1;
    return AspectRatio(
        aspectRatio: 1.3,
        child: Column(
          children: [
          Container(
          height: 20,
          child: Center(
            child: Text(
              'Expenses by Category',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      Expanded(
        child: Column(
            children: <Widget>[
              const SizedBox(
                height: 28,
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
                      centerSpaceRadius: 60,
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: buildLegend(),
              ),
            ]
          )
          )
        ]
      )
    );
  }

  ///widget to show legend beside the pie chart
  Widget buildLegend() {
    Set<String> uniqueCategories = transactions
        .where((transaction) => transaction.category != "Income")
        .map((transaction) => transaction.category!)
        .toSet();

    ///ensures that our legend is aligned to the left
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: uniqueCategories
            .map((category) =>
            LegendItem(
              color: categoryColors[category] ?? Colors.black,
              text: category,
            ))
            .toList(),
      ),
    );
  }

  ///method to calculate the area of each section on pie chart based on category
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
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  /// method to calculate total amount
  double getTotalAmount() {
    double totalAmount = 0;
    transactions.forEach((transaction) {
      totalAmount += transaction.amount!;
    });
    return totalAmount;
  }

  ///method to calculate total income
  double getTotalIncome() {
    double totalIncome = 0;
    transactions.where((transaction) => transaction.category == "Income")
        .forEach((transaction) {
      totalIncome += transaction.amount!;
    });
    return totalIncome;
  }

/// Helper function to group transactions by week
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

/// Helper function to get the week number from a DateTime
  int getWeekNumber(DateTime date) {
    return ((date
        .difference(DateTime(2023, 11, 1))
        .inDays) / 7).ceil();
  }

  /// Builds the bar chart for income and expenses by week.
  Widget buildTransactionChart() {
    // Group transactions by week
    Map<int, List<Transaction_data>> transactionsByWeek =
    groupTransactionsByWeek(transactions);

    // Extract data for total expenses and total income for each week
    List<BarChartGroupData> barGroups =
    transactionsByWeek.keys.map((week) {
      double totalExpenses = 0;
      double totalIncome = 0;

      //Used assistance of ChatGPT - OpenAI to debug logic
      transactionsByWeek[week]!.forEach((transaction) {
        if (transaction.category == "Income") {
          totalIncome += transaction.amount!;
        } else {
          totalExpenses += transaction.amount!;
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
            rodStackItems: [
              BarChartRodStackItem(0, totalIncome, Colors.greenAccent),
            ],
          ),
        ],
      );
    }).toList();

    return Column(
      children: [
        Container(
          height: 30,
          child: Center(
            child: Text(
              'Transactions This Month',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        Container(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),

          child: BarChart(
              BarChartData(
                barGroups: barGroups,
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          '\$${value.toInt()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        );
                      },
                      interval: 500,
                    ),
                ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 10,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          'Week ${value.toInt()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        );
                      },
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
          ),
        ],
    );
  }
}
