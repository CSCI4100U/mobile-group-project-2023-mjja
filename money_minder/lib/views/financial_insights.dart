/// File: financial_insights.dart
/// Description: A Flutter Dart file containing the implementation of A StatefulWidget that
/// provides financial insights by visualizing transaction data

/// It displays two types of charts:
/// - A pie chart for expenses, categorized by the type of expense.
/// - A bar chart for income and expenses, grouped by week.

// ## Acknowledgments
// The code in this project was developed with the assistance of ChatGPT, an AI language model created by OpenAI.

// All imports
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/views/transactions_page.dart';
import 'custom_navigation.dart';
import '../models/transaction_model.dart';
import 'package:intl/intl.dart';

/// The main StatefulWidget class for the Financial Insights page.
class FinancialInsightsPage extends StatefulWidget {
  const FinancialInsightsPage({super.key});

  @override
  _FinancialInsightsState createState() => _FinancialInsightsState();
}

/// Global color definitions used for UI consistency.
final Color backgroundColor = Colors.black;
final Color purpleColor = Color(0xFF5E17EB);
final Color textColor = Colors.white;

/// A StatelessWidget that represents a single legend item in the pie chart.
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
              style: TextStyle(fontSize: 15, color: textColor)),
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

  //mode to view pie chart or bar graph
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

  /// Main build method for UI design
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Allows vertical scrolling if items overflow
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 28,
          ),
          //implement toggle button to switch between pie/bar chart
          Center(
            child: ToggleButtons(
              fillColor: Colors.white,
              selectedColor: purpleColor,
              color: textColor,
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
          Container(
            height: 500,
            child: showPieChart ? buildPieChart() : buildTransactionChart(),
          ),
        ],
      ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Set the current index to Financial Insights
        onTap: (index) { // Handle bottom navigation bar item taps
        },
      ),

    );
  }

  /// Builds the bar chart for income and expenses by month.
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
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

  ///widget to show legend of the pie chart
  Widget buildLegend() {
    Set<String> uniqueCategories = transactions
        .where((transaction) => transaction.category != "Income")
        .map((transaction) => transaction.category!)
        .toSet();

    //List the legend with the items side by side
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Allows horizontally scrolling through the legend
      child: Row(
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
          color: textColor,
          shadows: shadows,
        ),
      );
    });
  }

  /// method to calculate total amount of transactions
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

  /// Helper function to group transactions by month
  Map<int, List<Transaction_data>> groupTransactionsByMonth(
      List<Transaction_data> transactions) {
    return transactions.fold(
        <int, List<Transaction_data>>{}, (map, transaction) {
      int month = getMonthNumber(transaction.date!);
      if (!map.containsKey(month)) {
        map[month] = [];
      }
      map[month]!.add(transaction);
      return map;
    });
  }

  /// Helper function to get the month number from a DateTime
  int getMonthNumber(DateTime date) {
    return date.month;
  }

  /// Builds the bar chart for income and expenses by month.
  // Used the assistance of ChatGPT - OpenAI to organize
  // transactions visually using colours
  Widget buildTransactionChart() {
    // Group transactions by month
    Map<int, List<Transaction_data>> transactionsByMonth =
    groupTransactionsByMonth(transactions);

    //Logic to get the most recent months to display (3)
    DateTime now = DateTime.now();
    List<int> recentMonths = List.generate(3, (index) {
      int month = now.month - index;
      if (month <= 0) {
        month += 12;
      }
      return month;
    }).reversed.toList();

    // Filter the transactions to only include data from the recent three months
    List<BarChartGroupData> barGroups = recentMonths.map((month) {
      double totalExpenses = 0;
      double totalIncome = 0;

      transactionsByMonth[month]?.forEach((transaction) {
        if (transaction.category == "Income") {
          totalIncome += transaction.amount!;
        } else {
          totalExpenses += transaction.amount!;
        }
      });

      //develop data for double bar graph
      return BarChartGroupData(
        x: month,
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

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 30,
            child: Center(
              child: Text(
                'Transactions By Month',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
          ),
          Container(
            height: 400,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 0.0),
              // create bar chart
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
                              color: textColor,
                              fontSize: 12,
                            ),
                          );
                        },
                        interval: 500,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          String monthName = DateFormat.MMM().format(
                            DateTime(2023, value.toInt()),
                          );
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              monthName,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                        interval: 1,
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
          // Legend for the bar chart
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Expenses - Red bar
                LegendItem(color: Colors.redAccent, text: "Expenses"),
                SizedBox(width: 16), // Spacer
                // Income - Green bar
                LegendItem(color: Colors.greenAccent, text: "Income"),
              ],
            ),
          ),
        ],
      )
    );
  }
}
