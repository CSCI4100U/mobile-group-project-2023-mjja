
// make it so that the view is monthly

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InsightsPage extends StatelessWidget {
  final TabController tabController;

  InsightsPage({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Total Balance',
                                  style: TextStyle(color: Colors.black)),
                              Text('\$13,250',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.upload, color: Colors.black),
                                onPressed: () {
                                  // Implement the export & share functionality
                                },
                              ),
                              Text('Export and Share',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black)),
                            ],
                          ),
                        ],
                      ),
                      // Add more UI elements similar to the above for the complete design
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4.0,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            child: Text('Expense'),
                            style: ElevatedButton.styleFrom(primary: Colors.purple),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text('Income'),
                            style: ElevatedButton.styleFrom(primary: Colors.green),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text('Budgets'),
                            style: ElevatedButton.styleFrom(primary: Colors.blue),
                            onPressed: () {},

                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (double value, TitleMeta meta) {
                                    const style = TextStyle(
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    );
                                    String text;
                                    switch (value.toInt()) {
                                      case 0:
                                        text = 'Jun';
                                        break;
                                      case 1:
                                        text = 'Jul';
                                        break;
                                      case 2:
                                        text = 'Aug';
                                        break;
                                      case 3:
                                        text = 'Sep';
                                        break;
                                      case 4:
                                        text = 'Oct';
                                        break;
                                      default:
                                        text = '';
                                    }
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 8.0,
                                      child: Text(text, style: style),
                                    );
                                  },
                                  reservedSize: 40,
                                ),
                              ),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
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
                              ),
                              LineChartBarData(
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
                              ),
                            ],
                          ),
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

    );
  }
}
