import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'custom_navigation.dart';

enum TimePeriod { week, month, year }

class FinancialInsightsPage extends StatefulWidget {

  @override
  _FinancialInsightsPageState createState() => _FinancialInsightsPageState();
}

class _FinancialInsightsPageState extends State<FinancialInsightsPage> {
  // New state variable to track if we're showing Expense or Income
  bool showExpense = true;
  final Color purpleColor =
  Color(0xFF5E17EB);
  TimePeriod selectedPeriod = TimePeriod.month;  // Default to month


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // show balance
            Card(
              color: purpleColor, // Purple color for the card
              elevation: 4.0,
              margin: const EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White color for the text
                      ),
                    ),
                    SizedBox(height: 8), // Provides spacing between text elements
                    Text(
                      '\$13,250', // This should be a variable holding the balance value
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White color for the balance figure
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 4.0,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            child: Text('Expense'),
                            style: ElevatedButton.styleFrom(primary: showExpense ? Colors.blue : Colors.grey),
                            onPressed: () {
                              setState(() {
                                showExpense = true;
                              });
                            },
                          ),
                          ElevatedButton(
                            child: Text('Income'),
                            style: ElevatedButton.styleFrom(primary: showExpense ? Colors.grey : Colors.green),
                            onPressed: () {
                              setState(() {
                                showExpense = false;
                              });
                            },
                          ),

                          // Removed the 'Budgets' button for clarity
                        ],
                      ),
                      // Toggle buttons for Week/Month/Year
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            child: Text('Week'),
                            style: ElevatedButton.styleFrom(
                              primary: selectedPeriod == TimePeriod.week ? Colors.purple : Colors.grey,
                              onPrimary: Colors.white, // Text Color
                            ),
                            onPressed: () {
                              setState(() {
                                selectedPeriod = TimePeriod.week;
                              });
                            },
                          ),
                          ElevatedButton(
                            child: Text('Month'),
                            style: ElevatedButton.styleFrom(
                              primary: selectedPeriod == TimePeriod.month ? Colors.purple : Colors.grey,
                              onPrimary: Colors.white, // Text Color
                            ),
                            onPressed: () {
                              setState(() {
                                selectedPeriod = TimePeriod.month;
                              });
                            },
                          ),
                          ElevatedButton(
                            child: Text('Year'),
                            style: ElevatedButton.styleFrom(
                              primary: selectedPeriod == TimePeriod.year ? Colors.purple : Colors.grey,
                              onPrimary: Colors.white, // Text Color
                            ),
                            onPressed: () {
                              setState(() {
                                selectedPeriod = TimePeriod.year;
                              });
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      Container(
                        height: 200,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: LineChart(
                          generateChartData(),
                        ),
                      ),

                      // Additional UI elements can be added here
                    ],
                  ),
                ),
              ),
            ),
            // Continue with other UI elements as needed
          ],
        ),
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation bar item taps
        },
      ),
    );
  }
  LineChartData generateChartData() {
    List<LineChartBarData> chartData = getChartData();

    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              String text = '';
              switch (selectedPeriod) {
                case TimePeriod.week:
                  final labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                  text = labels[value.toInt() % labels.length];
                  break;
                case TimePeriod.month:
                  final labels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
                  text = labels[value.toInt() % labels.length];
                  break;
                case TimePeriod.year:
                  final labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                  text = labels[value.toInt() % labels.length];
                  break;
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8.0,
                child: Text(text, style: style),
              );
            },
            reservedSize: 30,
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 4.0,
                child: Text(
                  '${value.toInt()}',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              );
            },
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: chartData,
    );
  }

  List<LineChartBarData> getChartData() {
    switch (selectedPeriod) {
      case TimePeriod.week:
        return [weeklyData()];
      case TimePeriod.month:
        return [monthlyData()];
      case TimePeriod.year:
        return [yearlyData()];
      default:
        return [monthlyData()];
    }
  }

  LineChartBarData weeklyData() {
    return LineChartBarData(
      spots: showExpense ? weeklyExpenseSpots : weeklyIncomeSpots,
      isCurved: true,
      color: showExpense ? Colors.red : Colors.green,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  LineChartBarData monthlyData() {
    return LineChartBarData(
      spots: showExpense ? monthlyExpenseSpots : monthlyIncomeSpots,
      isCurved: true,
      color: showExpense ? Colors.red : Colors.green,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  LineChartBarData yearlyData() {
    return LineChartBarData(
      spots: showExpense ? yearlyExpenseSpots : yearlyIncomeSpots,
      isCurved: true,
      color: showExpense ? Colors.red : Colors.green,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  // Helper method to create expense data
  LineChartBarData expenseData() {
    return LineChartBarData(
      spots: [
        FlSpot(0, 8000),
        FlSpot(1, 8500),
        FlSpot(2, 9000),
        FlSpot(3, 8700),
        FlSpot(4, 8600),
      ],
      isCurved: true,
      color: Colors.blue,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
    );
  }

  // Helper method to create income data
  LineChartBarData incomeData() {
    return LineChartBarData(
      spots: [
        FlSpot(0, 12000),
        FlSpot(1, 12500),
        FlSpot(2, 13000),
        FlSpot(3, 12800),
        FlSpot(4, 13200),
      ],
      isCurved: true,
      color: Colors.green,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
    );
  }
  // Define your data points here. In a real app, these would come from your data source.
  final List<FlSpot> weeklyExpenseSpots = [
    FlSpot(0, 150), // Saturday
    FlSpot(1, 120), // Sunday
    FlSpot(2, 170), // Monday
    FlSpot(3, 100), // Tuesday
    FlSpot(4, 200), // Wednesday
    FlSpot(5, 90),  // Thursday
    FlSpot(6, 160), // Friday
  ];

  final List<FlSpot> weeklyIncomeSpots = [
    FlSpot(0, 180), // Saturday
    FlSpot(1, 200), // Sunday
    FlSpot(2, 220), // Monday
    FlSpot(3, 210), // Tuesday
    FlSpot(4, 230), // Wednesday
    FlSpot(5, 250), // Thursday
    FlSpot(6, 240), // Friday
  ];

  final List<FlSpot> monthlyExpenseSpots = [
    FlSpot(0, 800),  // Week 1
    FlSpot(1, 900),  // Week 2
    FlSpot(2, 750),  // Week 3
    FlSpot(3, 950),  // Week 4
  ];

  final List<FlSpot> monthlyIncomeSpots = [
    FlSpot(0, 1000), // Week 1
    FlSpot(1, 1200), // Week 2
    FlSpot(2, 1100), // Week 3
    FlSpot(3, 1300), // Week 4
  ];

  final List<FlSpot> yearlyExpenseSpots = [
    FlSpot(0, 10000),  // January
    FlSpot(1, 10500),  // February
    FlSpot(2, 9800),   // March
    FlSpot(3, 11000),  // April
    FlSpot(4, 9500),   // May
    FlSpot(5, 10500),  // June
    FlSpot(6, 12000),  // July
    FlSpot(7, 11500),  // August
    FlSpot(8, 11000),  // September
    FlSpot(9, 10800),  // October
    FlSpot(10, 11200), // November
    FlSpot(11, 9500),  // December
  ];

  final List<FlSpot> yearlyIncomeSpots = [
    FlSpot(0, 12000),  // January
    FlSpot(1, 12300),  // February
    FlSpot(2, 12700),  // March
    FlSpot(3, 13000),  // April
    FlSpot(4, 12500),  // May
    FlSpot(5, 13200),  // June
    FlSpot(6, 13800),  // July
    FlSpot(7, 13500),  // August
    FlSpot(8, 14000),  // September
    FlSpot(9, 13600),  // October
    FlSpot(10, 13900), // November
    FlSpot(11, 13000), // December
  ];

// Weekly expense data
  LineChartBarData weeklyExpenseData() {
    return LineChartBarData(
      spots: weeklyExpenseSpots,
      isCurved: true,
      color: Colors.red,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

// Weekly income data
  LineChartBarData weeklyIncomeData() {
    return LineChartBarData(
      spots: weeklyIncomeSpots,
      isCurved: true,
      color: Colors.green,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

// Monthly expense data
  LineChartBarData monthlyExpenseData() {
    return LineChartBarData(
      spots: monthlyExpenseSpots,
      isCurved: true,
      color: Colors.red,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

// Monthly income data
  LineChartBarData monthlyIncomeData() {
    return LineChartBarData(
      spots: monthlyIncomeSpots,
      isCurved: true,
      color: Colors.green,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

// Yearly expense data
  LineChartBarData yearlyExpenseData() {
    return LineChartBarData(
      spots: yearlyExpenseSpots,
      isCurved: true,
      color: Colors.red,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

// Yearly income data
  LineChartBarData yearlyIncomeData() {
    return LineChartBarData(
      spots: yearlyIncomeSpots,
      isCurved: true,
      color: Colors.green,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }


}

