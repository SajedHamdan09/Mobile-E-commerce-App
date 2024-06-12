import 'package:flutter/material.dart';
import 'package:project_flutter2/SQLDB.dart';
import 'package:project_flutter2/product_details_wishlist.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {

  sqlDB db = sqlDB();

  Future<List<Map>> fetchData() async {
    // Replace the following line with your actual database query
    List<Map> response = await db.readData("SELECT * FROM wishlist");
   return response;
  }

  List<dynamic> _products = [];
  @override
  void initState() {
    super.initState();
    fetchData().then((fetchedProducts) {
      setState(() {
        _products = fetchedProducts;
      });
    }).catchError((error) {
      // Handle any errors here
      print(error);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My WishList",
          style: TextStyle(
            color: Color(0xFFF5F5F5),
            fontFamily: 'Jersey',
            fontSize: 40,
          ),
        ),
        backgroundColor: Color(0xFF6096BA),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsWishlistPage(
                    productInfo: _products[index],
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(
                right: 40,
                left: 40,
                top: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFecf2ea),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2,
                      child: ClipRRect(
                        child: Image.network(
                          _products[index]["product_image"],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            _products[index]["product_title"],
                            style: TextStyle(
                              fontFamily: 'PTSansCaption',
                              color: Color(0xFFFF274C77),
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Remove Product',
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
                                            'Are you sure you want to remove ',
                                          ),
                                          TextSpan(
                                            text:
                                            '${_products[index]["product_title"]}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' from the Wishlist?',
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFFFF274C77),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFFFF274C77),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onPressed: () async {
                                          int productId =
                                          _products[index]["id"];
                                          await db.deleteData(
                                              "DELETE FROM wishlist WHERE id = $productId");
                                          setState(() {
                                            _products = List.from(_products);
                                            _products.removeAt(index);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Color(0xFFFF274C77),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
