import 'package:flutter/material.dart';
import 'package:project_flutter2/SQLDB.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<dynamic, dynamic> productInfo;


  ProductDetailsPage({required this.productInfo})
      : super();

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  sqlDB db = sqlDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: TextStyle(
              color: Color(0xFFF5F5F5), fontFamily: 'Jersey', fontSize: 40),
        ),
        backgroundColor: Color(0xFF6096BA),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child:
      Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.network(
                    widget.productInfo["product_image"],
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () async {
                        await db.insertData(
                          "INSERT INTO 'wishlist' ('product_title' , 'product_price', 'product_description' , 'product_image') VALUES ('" +
                              widget.productInfo["product_title"]
                                  .toString() +
                              "', '" +
                              widget.productInfo["product_price"]
                                  .toString() +
                              "', '" +
                              widget.productInfo["product_description"]
                                  .toString()
                                  .substring(
                                  0, 50) +
                              "', '" +
                              widget.productInfo["product_image"]
                                  .toString() +
                              "')",
                        );
                      },
                      icon: Icon(
                        Icons.favorite_border,
                        // color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "${widget.productInfo["product_title"]}",
                style: TextStyle(
                  fontFamily: 'PTSansCaption',
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF274C77),
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.only(top: 10, left: 20, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Description:",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF274C77),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${widget.productInfo["product_description"]}",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Color(0xFFFF274C77),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )
              ,
              SizedBox(height: 30),
              Text(
                "\$${widget.productInfo["product_price"]}",
                style: TextStyle(
                  fontFamily: 'PTSansCaption',
                  fontSize: 17,
                  color: Color(0xFFFF274C77),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      )
        ,),
    );
  }
}
