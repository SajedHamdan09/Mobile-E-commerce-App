import 'package:flutter/material.dart';
import 'package:project_flutter2/SQLDB.dart';

class ProductDetailsCartPage extends StatefulWidget {
  final Map<dynamic, dynamic> productInfo;

  ProductDetailsCartPage({required this.productInfo}) : super();

  @override
  _ProductDetailsCartPageState createState() =>
      _ProductDetailsCartPageState();
}

class _ProductDetailsCartPageState
    extends State<ProductDetailsCartPage> {
  sqlDB db = sqlDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: TextStyle(
              color: Color(0xFFF5F5F5), // Complete the color code
              fontFamily: 'Jersey',
              fontSize: 40),
        ),
        backgroundColor: Color(0xFF6096BA), // Complete the color code
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await db.insertData(
                          "INSERT INTO 'wishlist' ('product_title' , 'product_price', 'product_description' , 'product_image') VALUES ('" +
                              widget.productInfo["title"]
                                  .toString() +
                              "', '" +
                              widget.productInfo["price"]
                                  .toString() +
                              "', '" +
                              widget.productInfo["description"]
                                  .toString()
                                  .substring(
                                  0, 50) +
                              "', '" +
                              widget.productInfo["image"]
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
                Stack(
                  children: <Widget>[
                    Image.network(
                      widget.productInfo["image"],
                      // Use the correct key for image path
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                    // Positioned(
                    //   right: 0,
                    //   child: IconButton(
                    //     icon: Icon(
                    //       widget.productInfo["wishlist"]
                    //           ? Icons.favorite
                    //           : Icons.favorite_border_sharp,
                    //       color: widget.productInfo["wishlist"]
                    //           ? Colors.red
                    //           : null,
                    //     ),
                    //     onPressed: () {
                    //       setState(() {
                    //         widget.productInfo["wishlist"] =
                    //             !widget.productInfo["wishlist"];
                    //         if (widget.productInfo["wishlist"]) {
                    //           // Add the product to the wishlist
                    //         } else {
                    //           // Remove the product from the wishlist
                    //         }
                    //       });
                    //     },
                    //   ),
                    // )
                    // Add other widgets here if needed
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "${widget.productInfo["title"]}",
                  // Use the correct key for product name
                  style: TextStyle(
                    fontFamily: 'PTSansCaption',
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF274C77), // Complete the color code
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        "Description:",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF274C77), // Complete the color code
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${widget.productInfo["description"]}",
                        // Use the correct key for product description
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Color(0xFFFF274C77), // Complete the color code
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "\$${widget.productInfo["price"]}",
                  // Use the correct key for product price
                  style: TextStyle(
                    fontFamily: 'PTSansCaption',
                    fontSize: 19,
                    color: Color(0xFFFF274C77), // Complete the color code
                  ),
                ),
                SizedBox(height: 20),
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
                                      text: 'Are you sure you want to add '),
                                  TextSpan(
                                    text: "${widget.productInfo["title"]}",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: ' to your Cart?'),
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
                                      fontWeight: FontWeight.w500),
                                ),
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

                                    int response = await db.insertData(
                                        "INSERT INTO 'cart' ('product_title', 'product_price', 'product_description', 'product_image') VALUES ('" +
                                            widget.productInfo["title"].toString() + "', '" +
                                            widget.productInfo["price"].toString() + "', '" +
                                            widget.productInfo["description"].toString().substring(0, 100) + "', '" +
                                            widget.productInfo["image"].toString() + "')"
                                    );

                                    if(response != 0){
                                      ScaffoldMessenger
                                          .of(context)
                                          .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "${widget.productInfo["title"]} added to your Cart!",
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
                    child:
                    Icon(Icons.shopping_cart, color: Color(0xFFFF274C77))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
