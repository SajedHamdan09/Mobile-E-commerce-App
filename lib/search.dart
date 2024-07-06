import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_flutter2/devices.dart'; // Import necessary widgets
import 'package:project_flutter2/gadgets.dart';
import 'package:project_flutter2/laptops.dart';
import 'package:project_flutter2/screens.dart';
import 'package:project_flutter2/main.dart';

Future<List<dynamic>> fetchData() async {
  final response = await http
      .get(Uri.parse('https://fakestoreapi.in/api/products?limit=10'));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    if (responseData['products'] is List<dynamic>) {
      return responseData['products'];
    } else {
      throw Exception('Invalid data format from API');
    }
  } else {
    throw Exception('Failed to load data from API');
  }
}

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<dynamic> _myProducts = [];

  @override
  void initState() {
    super.initState();
    fetchData().then((fetchedProducts) {
      setState(() {
        _myProducts = fetchedProducts;
      });
    }).catchError((error) {
      print('Error fetching data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Product',
          style: TextStyle(
            color: Color(0xFFFF274C77),
            fontFamily: 'PTSansCaption',
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mic),
            color: Color(0xFFFF274C77),
            onPressed: () {
            },
          ),
          IconButton(
            icon: Icon(Icons.search_sharp),
            color: Color(0xFFFF274C77),
            onPressed: () {
              showSearch(
                  context: context, delegate: CitySearchDelegate(_myProducts));
            },
          ),
        ],
      ),
      body: _myProducts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _myProducts.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        _myProducts[index]['title'],
                        style: TextStyle(
                            fontSize: 18.0, overflow: TextOverflow.ellipsis),
                      ),
                      // subtitle: Text(
                      //   'Category: ${_myProducts[index]['category']}',
                      //   style: TextStyle(color: Colors.grey[600]),
                      // ),
                      leading: Image.network(
                        _myProducts[index]['image'],
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        // Navigate to the specific widget when a product is selected
                        Widget route;
                        switch (_myProducts[index]["category"]) {
                          case 'electronics':
                            route = Devices();
                            break;
                          case 'gadgets':
                            route = Gadgets();
                            break;
                          case 'laptops':
                            route = Laptops();
                            break;
                          case 'screens':
                            route = Screens();
                            break;
                          // Add more cases for other categories...
                          default:
                            route = HomeScreen(); // Default route
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => route),
                        );
                      },
                    ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                );
              },
            ),
    );
  }
}

class CitySearchDelegate extends SearchDelegate<String> {
  final List<dynamic> _myProducts;

  CitySearchDelegate(this._myProducts);

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
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<dynamic> filteredProducts = _myProducts
        .where((product) =>
            product['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _buildProductList(filteredProducts);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> suggestionList = query.isEmpty
        ? _myProducts
        : _myProducts
            .where((product) =>
                product['title'].toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return _buildProductList(suggestionList);
  }

  Widget _buildProductList(List<dynamic> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            // Print debug info
            print('Navigating to ${product['category']}');

            // Navigate to the specific widget when a product is selected
            Widget route;
            switch (product['category']) {
              case 'electronics':
                route = Devices();
                break;
              case 'gadgets':
                route = Gadgets();
                break;
              case 'laptops':
                route = Laptops();
                break;
              case 'screens':
                route = Screens();
                break;
              default:
                route = HomeScreen(); // Default route
            }

            // Navigate to the selected route
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route),
            );
          },
          child: Column(
            children: [
              ListTile(
                title: Text(
                  product['title'],
                  style: TextStyle(fontSize: 18.0),
                  overflow: TextOverflow.ellipsis,
                ),
                // subtitle: Text(
                //   'Category: ${product['category']}',
                //   style: TextStyle(color: Colors.grey[600]),
                // ),
                leading: Image.network(
                  product['image'],
                  width: 60.0,
                  height: 60.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 25,
              )
            ],
          ),
        );
      },
    );
  }
}
