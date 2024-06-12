import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:project_flutter2/laptops.dart';
import 'package:project_flutter2/main.dart';
import 'package:project_flutter2/screens.dart';
import 'devices.dart';
import 'gadgets.dart'; // Import services

Future<List<dynamic>> fetchData() async {
  final response = await http.get(Uri.parse(
      'https://fakestoreapi.in/api/products?limit=10'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['products'];
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
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSearch(context: context, delegate: CitySearchDelegate(_myProducts))
          .then((value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
      )); // Navigate to Home when search is closed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CitySearchDelegate(_myProducts));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _myProducts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_myProducts[index]['name']),
            onTap: () {
              // Navigate to the specific widget when a product is selected
              Widget route;
              switch (_myProducts[index]["route"]) {
                case 'Devices()':
                  route = Devices();
                  break;
                case 'Gadgets()':
                  route = Gadgets();
                  break;
                case 'Laptops()':
                  route = Laptops();
                  break;
                case 'Screens()':
                  route = Screens();
                  break;
              // Add more cases for other routes...
                default:
                  route = HomeScreen(); // Default route
              }
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => route));
            },
          );
        },
      ),
    );
  }
}

class CitySearchDelegate extends SearchDelegate {
  final List<dynamic> _myProducts;

  CitySearchDelegate(this._myProducts);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.mic, color: Color(0xFFFF274C77)),
        onPressed: () {
          query = '';
        },
      ),
      IconButton(
        icon: Icon(Icons.clear, color: Color(0xFFFF274C77)),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        color: Color(0xFFFF274C77),
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? _myProducts
        : _myProducts
        .where(
            (p) => p['name'].toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          // Navigate to the specific widget when a product is selected
          Widget route;
          switch (_myProducts[index]["route"]) {
            case 'Devices()':
              route = Devices();
              break;
            case 'Gadgets()':
              route = Gadgets();
              break;
            case 'Laptops()':
              route = Laptops();
              break;
            case 'Screens()':
              route = Screens();
              break;
          // Add more cases for other routes...
            default:
              route = HomeScreen(); // Default route
          }
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => route));
        },
        leading: Image.asset("assets/search.png",
            color: Color(0xFFFF274C77), width: 35),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index]['name'].substring(0, query.length),
            style: TextStyle(
                color: Color(0xFFFF274C77), fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: suggestionList[index]['name'].substring(query.length),
                style: TextStyle(
                    color: Color(0xFFFF274C77),
                    fontFamily: 'Jersey',
                    fontSize: 27),
              ),
            ],
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
