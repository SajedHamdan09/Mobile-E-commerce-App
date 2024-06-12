import 'package:flutter/material.dart';
import 'package:project_flutter2/SQLDB.dart';
import 'package:project_flutter2/app_Bar.dart';
import 'package:project_flutter2/product_details_cart.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchData() async {
  final response = await http.get(Uri.parse(
      'https://fakestoreapi.in/api/products/category?type=mobile&sort=desc'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['products'];
  } else {
    throw Exception('Failed to load data from API');
  }
}

class Devices extends StatefulWidget {
  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {


  List<dynamic> _myProducts = [];
  Map<dynamic, bool> _items_in_wishlist = {};


  @override
  void initState() {
    super.initState();
    fetchData().then((fetchedProducts) {
      setState(() {
        _myProducts = fetchedProducts;

        for (var product in fetchedProducts) {
          _items_in_wishlist[product["id"]] = false;
        }
      });
    });
  }

  sqlDB db = sqlDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: My_AppBar(context),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: FutureBuilder<List<dynamic>>(
          future: fetchData(),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              _myProducts = snapshot.data!;
              return GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: _myProducts.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailsCartPage(
                                        productInfo: _myProducts[index])));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xFFecf2ea),
                            borderRadius: BorderRadius.circular(20)),
                        child: Stack(
                          children: <Widget>[
                            Positioned(child: IconButton(
                              onPressed: () async {
                                await db.insertData(
                                  "INSERT INTO 'wishlist' ('product_title' , 'product_price', 'product_description' , 'product_image') VALUES ('" +
                                      _myProducts[index]["title"]
                                          .toString() +
                                      "', '" +
                                      _myProducts[index]["price"]
                                          .toString() +
                                      "', '" +
                                      _myProducts[index]["description"]
                                          .toString()
                                          .substring(
                                          0, 50) +
                                      "', '" +
                                      _myProducts[index]["image"]
                                          .toString() +
                                      "')",
                                );setState(() {
                                  if (_items_in_wishlist.containsKey(_myProducts[index]["id"])) {
                                    _items_in_wishlist[_myProducts[index]["id"]] = !_items_in_wishlist[_myProducts[index]["id"]]!;
                                  } else {
                                    // If the item is not in the map, add it and set it to true
                                    _items_in_wishlist[_myProducts[index]["id"]] = true;
                                  }
                                });
                              },
                              icon: Icon(
                                _items_in_wishlist[
                                _myProducts[index]["id"]] ??
                                    false
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _items_in_wishlist[
                                _myProducts[index]["id"]] ??
                                    false
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),top: 0,right: -7),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: AspectRatio(
                                    aspectRatio: 1.5,
                                    child: Image.network(
                                      _myProducts[index]["image"],
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text("${_myProducts[index]["title"]}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'PTSansCaption',
                                          color: Color(0xFFFF274C77)),
                                      overflow: TextOverflow.ellipsis),
                                  subtitle: Text(
                                      "\t\t\$${_myProducts[index]["price"]}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'PTSansCaption',
                                          color: Color(0xFFFF274C77))),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Add to Cart',
                                            style: TextStyle(
                                              fontFamily: 'PTSansCaption',
                                              color: Color(0xFFFF274C77),
                                            ),
                                          ),
                                          content: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Color(0xFFFF274C77),
                                                fontSize: 16,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        'Are you sure you want to add '),
                                                TextSpan(
                                                    text:
                                                        '${_myProducts[index]["title"]}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: ' to your Cart?'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Cancel',
                                                  style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color:
                                                          Color(0xFFFF274C77),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                    fontFamily:
                                                    'Inter',
                                                    color: Color(
                                                        0xFFFF274C77),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  Navigator.of(
                                                      context)
                                                      .pop();

                                                  int response = await db.insertData("INSERT INTO 'cart' ('product_title' , 'product_price', 'product_description' , 'product_image') VALUES ('" +
                                                      _myProducts[index]["title"]
                                                          .toString() +
                                                      "', '" +
                                                      _myProducts[index]["price"]
                                                          .toString() +
                                                      "', '" +
                                                      _myProducts[index]["description"]
                                                          .toString()
                                                          .substring(
                                                          0,
                                                          50) +
                                                      "', '" +
                                                      _myProducts[index]["image"]
                                                          .toString() +
                                                      "')");
                                                  if(response != 0){
                                                    ScaffoldMessenger
                                                        .of(context)
                                                        .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "${_myProducts[index]["title"]} added to your Cart!",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontFamily:
                                                                  'PTSansCaption',
                                                                  color: Color(
                                                                      0xFFF5F5F5))),
                                                          backgroundColor:
                                                          Color(
                                                              0xFFFF274C77),
                                                          padding: EdgeInsets
                                                              .all(
                                                              20),
                                                        ));
                                                  }
                                                }),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(Icons.shopping_cart,
                                      color: Color(0xFFFF274C77)),
                                ),
                              ],
                            ),
                            // Positioned(
                            //   right: -5,
                            //   child: IconButton(
                            //     icon: Icon(
                            //       _wishlistProducts[index]["wishlist"] == true
                            //           ? Icons.favorite
                            //           : Icons.favorite_border_sharp,
                            //       color: _wishlistProducts[index]["wishlist"] == true
                            //           ? Colors.red
                            //           : null,
                            //     ),
                            //     onPressed: () {
                            //       setState(() {
                            //         _wishlistProducts[index]["wishlist"] = !_wishlistProducts[index]["wishlist"];
                            //         if (_wishlistProducts[index]["wishlist"] == true) {
                            //           _wishlistProducts.add(_wishlistProducts[index]);
                            //         } else {
                            //           _wishlistProducts.remove(_wishlistProducts[index]);
                            //         }
                            //       });
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
