import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter2/SQLDB.dart';
import 'package:project_flutter2/product_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  sqlDB db = sqlDB();

  Future<List<Map>> fetchData() async {
    List<Map> response = await db.readData("SELECT * FROM cart");
    return response;
  }

  double _totalPrice = 0;
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    fetchData().then((fetchedProducts) {
      setState(() {
        _products = fetchedProducts;
        _calculateTotalPrice();
      });
    }).catchError((error) {
      print(error);
    });
  }

  void _calculateTotalPrice() {
    double total = 0;
    for (var item in _products) {
      total += double.tryParse(item["product_price"]) ?? 0.0;
    }
    setState(() {
      _totalPrice = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: TextStyle(
            color: Color(0xFFF5F5F5),
            fontFamily: 'Jersey',
            fontSize: 40,
          ),
        ),
        backgroundColor: Color(0xFF6096BA),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
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
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  _products[index]["product_title"].toString(),
                                  style: TextStyle(
                                      fontFamily: 'PTSansCaption',
                                      color: Color(0xFFFF274C77),
                                      fontSize: 20,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '\$${_products[index]["product_price"].toString()}',
                                  style: TextStyle(
                                      fontFamily: 'PTSansCaption',
                                      color: Color(0xFFFF274C77),
                                      fontSize: 20,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.remove)),
                                    Text(
                                      "1",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.add)),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
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
                                                  text: ' from the Cart?',
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
                                                    "DELETE FROM cart WHERE id = $productId");
                                                setState(() {
                                                  _products =
                                                      List.from(_products);
                                                  _products.removeAt(index);
                                                  _calculateTotalPrice(); // Recalculate total price after removing product
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
          ),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFFF274C77)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Total Price: ',
                      style: TextStyle(
                          color: Color(0xFFE7ECEF),
                          fontSize: 22,
                          fontFamily: 'PTSansCaption'),
                    ),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Color(0xFFE7ECEF),
                          fontSize: 22,
                          fontFamily: 'PTSansCaption'),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckoutPage()),
                      );
                    },
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                          color: Color(0xFFFF274C77),
                          fontSize: 22,
                          fontFamily: 'PTSansCaption'),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? _selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(
            color: Color(0xFFF5F5F5),
            fontFamily: 'Jersey',
            fontSize: 40,
          ),
        ),
        backgroundColor: Color(0xFF6096BA),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Delivery Information',
                style: TextStyle(
                  fontFamily: 'PTSansCaption',
                  fontSize: 24,
                  color: Color(0xFFFF274C77),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: _selectedAddress),
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () async {
                      final address = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectAddressPage(),
                        ),
                      );
                      if (address != null) {
                        setState(() {
                          _selectedAddress = address;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Postal Code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Payment Information',
                style: TextStyle(
                  fontFamily: 'PTSansCaption',
                  fontSize: 24,
                  color: Color(0xFFFF274C77),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Confirm Order',
                            style: TextStyle(
                              fontFamily: 'PTSansCaption',
                              color: Color(0xFFFF274C77),
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to place this order?',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFF000000),
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
                              onPressed: () {
                                // Implement order placement functionality here
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Place Order',
                    style: TextStyle(
                      color: Color(0xFFE7ECEF),
                      fontSize: 22,
                      fontFamily: 'PTSansCaption',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF274C77),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectAddressPage extends StatefulWidget {
  @override
  _SelectAddressPageState createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  GoogleMapController? _mapController;
  LatLng _initialPosition =
      LatLng(37.7749, -122.4194); // Default to San Francisco
  LatLng? _selectedLocation;
  String? _selectedAddress;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onTap(LatLng location) async {
    setState(() {
      _selectedLocation = location;
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      setState(() {
        _selectedAddress =
            "${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Delivery Address",
          style: TextStyle(
            color: Color(0xFFF5F5F5),
            fontFamily: 'Jersey',
            fontSize: 40,
          ),
        ),
        backgroundColor: Color(0xFF6096BA),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 12.0,
              ),
              onTap: _onTap,
              markers: _selectedLocation == null
                  ? {}
                  : {
                      Marker(
                        markerId: MarkerId('selected-location'),
                        position: _selectedLocation!,
                      ),
                    },
            ),
          ),
          if (_selectedAddress != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Selected Address: $_selectedAddress",
                style: TextStyle(
                  fontFamily: 'PTSansCaption',
                  fontSize: 16,
                  color: Color(0xFFFF274C77),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _selectedAddress);
              },
              child: Text(
                'Confirm Address',
                style: TextStyle(
                  color: Color(0xFFFF274C77),
                  fontSize: 22,
                  fontFamily: 'PTSansCaption',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6096BA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
