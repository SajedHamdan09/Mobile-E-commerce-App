import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:project_flutter2/product_details.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_flutter2/product_details_cart.dart';

import 'SQLDB.dart';

List<dynamic> _myProducts = [];
Map<dynamic, bool> _items_in_wishlist = {};

Future<List<dynamic>> fetchData() async {
  final response = await http
      .get(Uri.parse('https://fakestoreapi.in/api/products?limit=10'));
  if (response.statusCode == 200) {
    return json.decode(response.body)['products'];
  } else {
    throw Exception('Failed to load data from API');
  }
}

final List<Widget> imageSliders = _myProducts
    .map((product) => Card(
          child: Column(
            children: <Widget>[
              Image.network(
                product['image'],
                fit: BoxFit.fitHeight,
                width: 400,
              ),
            ],
          ),
        ))
    .toList();

class ComplicatedImageDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 2.0,
          ),
          items: imageSliders,
        ),
      ),
    );
  }
}

class DisplayPage extends StatefulWidget {
  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  late PageController _pageController;

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Moved inside the build method

    sqlDB db = sqlDB();

    return Container(
      margin: EdgeInsets.only(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Image.asset("assets/cashback.webp"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(
                      "Top Selling Products",
                      style: TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 45,
                        color: Color(0xFFFF274C77),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // Other widgets
                      GestureDetector(
                        child: CarouselSlider(
                          items: _myProducts
                              .map(
                                (item) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsCartPage(
                                                    productInfo: item)));
                                  },
                                  child: Container(
                                    width: 300,
                                    child: Stack(
                                      children: <Widget>[
                                        SingleChildScrollView(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  onPressed: () async {

                                                    await db.insertData(
                                                      "INSERT INTO 'wishlist' ('product_title' , 'product_price', 'product_description' , 'product_image') VALUES ('" +
                                                          item["title"]
                                                              .toString() +
                                                          "', '" +
                                                          item["price"]
                                                              .toString() +
                                                          "', '" +
                                                          item["description"]
                                                              .toString()
                                                              .substring(
                                                                  0, 50) +
                                                          "', '" +
                                                          item["image"]
                                                              .toString() +
                                                          "')",
                                                    );
                                                    setState(() {
                                                      if (_items_in_wishlist.containsKey(item["id"])) {
                                                        _items_in_wishlist[item["id"]] = !_items_in_wishlist[item["id"]]!;
                                                      } else {
                                                        // If the item is not in the map, add it and set it to true
                                                        _items_in_wishlist[item["id"]] = true;
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    _items_in_wishlist[
                                                                item["id"]] ??
                                                            false
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: _items_in_wishlist[
                                                                item["id"]] ??
                                                            false
                                                        ? Colors.red
                                                        : Colors.black,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Image.network(
                                              item['image'],
                                              width: 400,
                                              height: 150,
                                              fit: BoxFit.contain,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text(
                                                "${item["title"]}",
                                                style: TextStyle(
                                                    fontFamily: 'PTSansCaption',
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.w600,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Color(0xFFFF274C77)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 13,
                                            ),
                                            Text(
                                              "\$${item["price"]}",
                                              style: TextStyle(
                                                  fontFamily: 'PTSansCaption',
                                                  fontSize: 17,
                                                  color: Color(0xFFFF274C77)),
                                            ),
                                            SizedBox(
                                              height: 13,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        'Add to Cart',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'PTSansCaption',
                                                          color: Color(
                                                              0xFFFF274C77),
                                                        ),
                                                      ),
                                                      content: RichText(
                                                        text: TextSpan(
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            color: Color(
                                                                0xFFFF274C77),
                                                            fontSize: 16,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    'Are you sure you want to add '),
                                                            TextSpan(
                                                              text:
                                                                  "${item['title']}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            TextSpan(
                                                                text:
                                                                    ' to your Cart?'),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Color(
                                                                    0xFFFF274C77),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
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
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();

                                                              int response = await db.insertData("INSERT INTO 'cart' ('product_title' , 'product_price', 'product_description' , 'product_image') VALUES ('" +
                                                                  item["title"]
                                                                      .toString() +
                                                                  "', '" +
                                                                  item["price"]
                                                                      .toString() +
                                                                  "', '" +
                                                                  item["description"]
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          50) +
                                                                  "', '" +
                                                                  item["image"]
                                                                      .toString() +
                                                                  "')");

                                                              if (response !=
                                                                  0) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                      "${item["title"]} added to your Cart!",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontFamily:
                                                                              'PTSansCaption',
                                                                          color:
                                                                              Color(0xFFF5F5F5))),
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xFFFF274C77),
                                                                  padding:
                                                                      EdgeInsets
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
                                              child: Icon(
                                                  color: Color(0xFFFF274C77),
                                                  Icons.shopping_cart),
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 1.2,
                            enlargeCenterPage: true,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40, bottom: 40),
                        child: Dash(
                          direction: Axis.horizontal,
                          length: MediaQuery.of(context).size.width * 0.9,
                          // This will make the Dash widget take the full width of the screen                        dashLength: 10,
                          dashThickness: 4,
                          dashGap: 7,
                          dashLength: 20,
                          dashColor: Color(0xFFFF274C77),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 0, left: 10, bottom: 0),
                        child: Text(
                          "Our Latest Products",
                          style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 45,
                            color: Color(0xFFFF274C77),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      CarouselSlider(
                        items: _myProducts
                            .map((item) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsCartPage(
                                                    productInfo: item)));
                                  },
                                  child: Container(
                                    width: 300,
                                    child: Stack(
                                      children: <Widget>[
                                        SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      await db.insertData(
                                                        "INSERT INTO 'wishlist' ('product_title' , 'product_price', 'product_description' , 'product_image') VALUES ('" +
                                                            item["title"]
                                                                .toString() +
                                                            "', '" +
                                                            item["price"]
                                                                .toString() +
                                                            "', '" +
                                                            item["description"]
                                                                .toString()
                                                                .substring(
                                                                    0, 50) +
                                                            "', '" +
                                                            item["image"]
                                                                .toString() +
                                                            "')",
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.favorite_border,
                                                      // color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Image.network(
                                                item['image'],
                                                width: 400,
                                                height: 150,
                                                fit: BoxFit.contain,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  "${item["title"]}",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'PTSansCaption',
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color:
                                                          Color(0xFFFF274C77)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 13,
                                              ),
                                              Text(
                                                "\$${item["price"]}",
                                                style: TextStyle(
                                                    fontFamily: 'PTSansCaption',
                                                    fontSize: 17,
                                                    color: Color(0xFFFF274C77)),
                                              ),
                                              SizedBox(
                                                height: 13,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Add to Cart',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'PTSansCaption',
                                                            color: Color(
                                                                0xFFFF274C77),
                                                          ),
                                                        ),
                                                        content: RichText(
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Inter',
                                                              color: Color(
                                                                  0xFFFF274C77),
                                                              fontSize: 16,
                                                            ),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                      'Are you sure you want to add '),
                                                              TextSpan(
                                                                text:
                                                                    "${item['title']}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              TextSpan(
                                                                  text:
                                                                      ' to your Cart?'),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Color(
                                                                      0xFFFF274C77),
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                              child: Text(
                                                                'Yes',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Color(
                                                                      0xFFFF274C77),
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();

                                                                int response = await db.insertData("INSERT INTO 'cart' ('product_title' , 'product_price', 'product_description' , 'product_image') VALUES ('" +
                                                                    item["title"]
                                                                        .toString() +
                                                                    "', '" +
                                                                    item["price"]
                                                                        .toString() +
                                                                    "', '" +
                                                                    item["description"]
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            50) +
                                                                    "', '" +
                                                                    item["image"]
                                                                        .toString() +
                                                                    "')");

                                                                if (response !=
                                                                    0) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        "${item["title"]} added to your Cart!",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                            fontFamily:
                                                                                'PTSansCaption',
                                                                            color:
                                                                                Color(0xFFF5F5F5))),
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xFFFF274C77),
                                                                    padding:
                                                                        EdgeInsets.all(
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 1.2,
                          enlargeCenterPage: true,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40, bottom: 40),
                        child: Dash(
                          direction: Axis.horizontal,
                          length: MediaQuery.of(context).size.width * 0.9,
                          // This will make the Dash widget take the full width of the screen                        dashLength: 10,
                          dashThickness: 4,
                          dashGap: 7,
                          dashLength: 20,
                          dashColor: Color(0xFFFF274C77),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 0, left: 10, bottom: 0),
                        child: Text(
                          "Products on Sale",
                          style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 45,
                            color: Color(0xFFFF274C77),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      CarouselSlider(
                        items: _myProducts
                            .map((item) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsCartPage(
                                                    productInfo: item)));
                                  },
                                  child: Container(
                                    width: 300,
                                    child: Stack(
                                      children: <Widget>[
                                        SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      await db.insertData(
                                                        "INSERT INTO 'wishlist' ('product_title' , 'product_price', 'product_description' , 'product_image') VALUES ('" +
                                                            item["title"]
                                                                .toString() +
                                                            "', '" +
                                                            item["price"]
                                                                .toString() +
                                                            "', '" +
                                                            item["description"]
                                                                .toString()
                                                                .substring(
                                                                    0, 50) +
                                                            "', '" +
                                                            item["image"]
                                                                .toString() +
                                                            "')",
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.favorite_border,
                                                      // color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Image.network(
                                                item['image'],
                                                width: 400,
                                                height: 150,
                                                fit: BoxFit.contain,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Text(
                                                  "${item["title"]}",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'PTSansCaption',
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color:
                                                          Color(0xFFFF274C77)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 13,
                                              ),
                                              Text(
                                                "\$${item["price"]}",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    decorationThickness: 3,
                                                    fontFamily: 'PTSansCaption',
                                                    fontSize: 17,
                                                    color: Color(0xFFFF274C77)),
                                              ),
                                              SizedBox(
                                                height: 13,
                                              ),
                                              Text(
                                                "\$${(((100 - (item["discount"] ?? 0)) / 100) * item["price"]).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontFamily: 'PTSansCaption',
                                                    fontSize: 17,
                                                    color: Color(0xFFFF274C77)),
                                              ),
                                              SizedBox(
                                                height: 13,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Add to Cart',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'PTSansCaption',
                                                            color: Color(
                                                                0xFFFF274C77),
                                                          ),
                                                        ),
                                                        content: RichText(
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Inter',
                                                              color: Color(
                                                                  0xFFFF274C77),
                                                              fontSize: 16,
                                                            ),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                      'Are you sure you want to add '),
                                                              TextSpan(
                                                                text:
                                                                    "${item['title']}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              TextSpan(
                                                                  text:
                                                                      ' to your Cart?'),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Color(
                                                                      0xFFFF274C77),
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                              child: Text(
                                                                'Yes',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Color(
                                                                      0xFFFF274C77),
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();

                                                                int response = await db.insertData("INSERT INTO 'cart' ('product_title' , 'product_price', 'product_description' , 'product_image') VALUES ('" +
                                                                    item["title"]
                                                                        .toString() +
                                                                    "', '" +
                                                                    item["price"]
                                                                        .toString() +
                                                                    "', '" +
                                                                    item["description"]
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            50) +
                                                                    "', '" +
                                                                    item["image"]
                                                                        .toString() +
                                                                    "')");

                                                                if (response !=
                                                                    0) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        "${item["title"]} added to your Cart!",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                17,
                                                                            fontFamily:
                                                                                'PTSansCaption',
                                                                            color:
                                                                                Color(0xFFF5F5F5))),
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xFFFF274C77),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            20),
                                                                  ));
                                                                }
                                                              }),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.shopping_cart,
                                                  color: Color(0xFFFF274C77),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 1.05,
                          enlargeCenterPage: true,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 35),
                        child: Text(
                          "In PartnerShip With",
                          style: TextStyle(
                              fontFamily: 'Jersey',
                              fontSize: 33,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFFF274C77)),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset('assets/apple-logo.png', width: 50),
                            Image.asset('assets/samsung.png', width: 75),
                            Image.asset('assets/xiaomi.png', width: 50),
                            Image.asset('assets/hp.png', width: 50),
                          ],
                        ),
                      )

                      // Other widgets
                      // Text("data")
                    ],
                  )
                ],
              ),
            ),
            // Text("data")
          ],
        ),
      ),
    );
  }
}
