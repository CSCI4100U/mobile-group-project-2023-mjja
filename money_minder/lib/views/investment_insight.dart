/// Displays the live stock prices(10 minutes delay) using an API.
/// The stocks of some companies are already provided
/// The user can also add any new stock they want.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'custom_navigation.dart';

final Color backgroundColor = Colors.black;
final Color purpleColor =
    Color(0xFF5E17EB); // Replace with your exact color code
final Color textColor = Colors.white;

class InsightsPage extends StatefulWidget {
  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  List<Stock> allStocks = [];
  List<Stock> displayedStocks = [];
  bool stockNotFound = false;

  TextEditingController stockSymbolController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Fetch initial stock data for GOOG, AAPL, and TSLA
    fetchStockData('GOOG');
    fetchStockData('AAPL');
    fetchStockData('TSLA');
    fetchStockData('AMZN');
    fetchStockData('NVDA');
    fetchStockData('META');
    fetchStockData('HSBC');
    fetchStockData('SHEL');
    fetchStockData('AVGO');
    fetchStockData('ADBE');
  }

  Future<void> fetchStockData(String symbol) async {
    final apiKey = 'sk_bf99b81898b649bb84952d702e939384'; // IEX Cloud Key
    final apiUrl =
        'https://cloud.iexapis.com/stable/stock/$symbol/quote?token=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);

        final price = data['latestPrice'].toDouble();
        final previousClose = data['previousClose'].toDouble();
        final percentageChange =
            ((price - previousClose) / previousClose) * 100;

        final stock = Stock(
          symbol: data['symbol'],
          name: data['companyName'],
          price: price,
          percentageChange: percentageChange,
        );

        setState(() {
          allStocks.add(stock);
          displayedStocks.add(stock);
          print("stocks saved on the screen");
        });
      } else {
        throw Exception(
            'Failed to load stock data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void filterStocks(String query) {
    final lowercaseQuery = query.toLowerCase();
    setState(() {
      final filteredStocks = allStocks;
      displayedStocks = allStocks
          .where((stock) =>
              stock.name.toLowerCase().contains(lowercaseQuery) ||
              stock.symbol.toLowerCase().contains(lowercaseQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterStocks,
              decoration: InputDecoration(
                hintText: 'Search Stocks',
                labelStyle: TextStyle(color: Colors.blueGrey),
                // labelText: 'Search Stocks',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedStocks.length,
              itemBuilder: (context, index) {
                final stock = displayedStocks[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    title: Text(
                      stock.name,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      stock.symbol,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${stock.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${stock.percentageChange >= 0 ? '+' : ''}${stock.percentageChange.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: stock.percentageChangeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: purpleColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('Add Stock'),
                content: TextField(
                  controller: stockSymbolController,
                  decoration: InputDecoration(
                      labelText: 'Stock Symbol or Full company name'),
                  style: TextStyle(color: Colors.black),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () {
                      fetchStockData(stockSymbolController.text);
                      stockSymbolController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Add', style: TextStyle(color: Colors.black)),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // Handle bottom navigation bar item taps
        },
      ),
    );
  }
}

class StockSearch extends SearchDelegate<Stock> {
  final List<Stock> allStocks;

  StockSearch(this.allStocks);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(
            context,
            Stock(
                symbol: '',
                name: '',
                price: 0.0,
                percentageChange: 0.0)); // Placeholder Stock instance
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final lowercaseQuery = query.toLowerCase();
    final filteredStocks = allStocks
        .where((stock) =>
            stock.name.toLowerCase().contains(lowercaseQuery) ||
            stock.symbol.toLowerCase().contains(lowercaseQuery))
        .toList();

    return ListView.builder(
      itemCount: filteredStocks.length,
      itemBuilder: (context, index) {
        final stock = filteredStocks[index];
        return ListTile(
          title: Text('${stock.name} (${stock.symbol})'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('\$${stock.price.toStringAsFixed(2)}'),
              Text(
                'Daily Change: ${stock.percentageChange >= 0 ? '+' : ''}${stock.percentageChange.toStringAsFixed(2)}%',
                style: TextStyle(color: stock.percentageChangeColor),
              ),
            ],
          ),
          onTap: () {
            close(context, stock);
          },
        );
      },
    );
  }
}

class Stock {
  final String symbol;
  final String name;
  double price;
  double percentageChange;

  Stock({
    required this.symbol,
    required this.name,
    required this.price,
    this.percentageChange = 0.0,
  });

  Color get percentageChangeColor =>
      percentageChange >= 0 ? Colors.green : Colors.red;
}
