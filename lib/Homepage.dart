import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; 

class Product {
  final int id;
  final String productName;
  final String productImage;
  final String category;
  final double productPrice;
  final bool isOff;
  final int offPercentage;
  final bool isAvailable;

  Product({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.category,
    required this.productPrice,
    this.isOff = false,
    this.offPercentage = 0,
    this.isAvailable = false,
  });

  // Convert a Product object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'productImage': productImage,
      'category': category,
      'productPrice': productPrice,
      'isOff': isOff,
      'offPercentage': offPercentage,
      'isAvailable': isAvailable,
    };
  }

  // Create a Product object from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['productName'],
      productImage: json['productImage'],
      category: json['category'],
      productPrice: json['productPrice'],
      isOff: json['isOff'],
      offPercentage: json['offPercentage'],
      isAvailable: json['isAvailable'],
    );
  }
}

List<Product> initialItems = [
  Product(
    id: 1,
    productName: "AKG N700NCM2 Wireless Headphones",
    productImage: "assets/AKG.png",
    category: "product",
    productPrice: 199.00,
    isOff: true,
    offPercentage: 20,
    isAvailable: true,
  ),
  Product(
    id: 2,
    productName: "AIAIAI TMA-2 Modular Headphones",
    productImage: "assets/boat3.png",
    category: "product",
    productPrice: 299.00,
    isOff: false,
    isAvailable: true,
  ),
  Product(
    id: 3,
    productName: "AIAIAI 3.5mm jack 2m",
    productImage: "assets/AKG.png",
    category: "accessory",
    productPrice: 25.00,
    isOff: false,
    isAvailable: true,
  ),
  Product(
    id: 4,
    productName: "AIAIAI 3.5MM Jack 1.5M",
    productImage: "assets/boatbassheads3.png",
    category: "accessory",
    productPrice: 15.00,
    isOff: true,
    offPercentage: 10,
    isAvailable: false,
  ),
];


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> products = [];
  List<Product> accessories = [];
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  bool isSearchExpanded = false;
  


  @override
  void initState() {
    super.initState();
    loadDataFromSharedPreferences(); 
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
        getDataFromDB();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> saveDataToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productList = products.map((item) => jsonEncode(item.toJson())).toList();
    prefs.setStringList('productList', productList);
    
    List<String> accessoryList = accessories.map((item) => jsonEncode(item.toJson())).toList();
    prefs.setStringList('accessoryList', accessoryList);
  }

  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedProductList = prefs.getStringList('productList');
    List<String>? savedAccessoryList = prefs.getStringList('accessoryList');

    if (savedProductList != null) {
      List<Product> loadedProducts = savedProductList
          .map((item) => Product.fromJson(jsonDecode(item)))
          .toList();

      setState(() {
        products = loadedProducts;
      });
    } else {
      setState(() {
        products = initialItems.where((item) => item.category == 'product').toList(); // Load initial products
      });
    }

    if (savedAccessoryList != null) {
      List<Product> loadedAccessories = savedAccessoryList
          .map((item) => Product.fromJson(jsonDecode(item)))
          .toList();

      setState(() {
        accessories = loadedAccessories;
      });
    } else {
      setState(() {
        accessories = initialItems.where((item) => item.category == 'accessory').toList(); // Load initial accessories
      });
    }
  }

  void getDataFromDB() {
    if (searchQuery.isEmpty) {
      setState(() {
        accessories.clear();
        products = initialItems.where((item) => item.category == 'product').toList();
        accessories = initialItems.where((item) => item.category == 'accessory').toList();
      });
      return;
    }

    List<Product> productList = [];
    List<Product> accessoryList = [];

    for (var item in products) {
      if (item.productName.toLowerCase().contains(searchQuery.toLowerCase())) {
        productList.add(item);
      }
    }

    for (var item in accessories) {
      if (item.productName.toLowerCase().contains(searchQuery.toLowerCase())) {
        accessoryList.add(item);
      }
    }

    setState(() {
      products = productList;
      accessories = accessoryList;
    });
  }

  void addProduct(Product newProduct) {
    setState(() {
      if (newProduct.category == 'product') {
        products.add(newProduct);
      } else {
        accessories.add(newProduct);
      }
      saveDataToSharedPreferences();
    });
  }
  void deleteProduct(Product product) {
    setState(() {
      if (product.category == 'product') {
        products.remove(product); 
      } else {
        accessories.remove(product);
      }
      saveDataToSharedPreferences(); 
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.white,
              ),
              child: Container(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: () {
                               SystemNavigator.pop();
                            },
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: isSearchExpanded ? 250 : 60, // Transition width
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    size: 24, // Initial size
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isSearchExpanded = !isSearchExpanded;
                                    });
                                  },
                                ),
                                if (isSearchExpanded)
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: "Search products...",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Hi-Fi Shop & Service',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Audio shop on Rustaveli Ave 57.\nThis shop offers both products and services',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.7),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildSectionTitle('Products', products.length),
                      SizedBox(height: 20),
                      _buildProductGrid(products),
                      SizedBox(height: 20),
                      _buildSectionTitle('Accessories', accessories.length),
                      SizedBox(height: 20),
                      _buildProductGrid(accessories),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var newProduct = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
          if (newProduct != null) {
            setState(() {
              initialItems.add(newProduct);
              getDataFromDB();
            });
          }
        },
        tooltip: 'Add Product',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionTitle(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ],
        ),
        Text(
          'Show All',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color.fromARGB(255, 5, 134, 239),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid(List<Product> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 14,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return _buildProductCard(items[index]);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        // Navigate to product detail page here
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.asset(
                    product.productImage,
                    height: 120,
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              if (product.isOff)
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      '${product.offPercentage}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                 Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: Icon(Icons.delete_forever_outlined, color: Colors.grey),
                        onPressed: () {
                          deleteProduct(product);
                        },
                      ),
                    ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            product.productName,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '\$${product.productPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
           SizedBox(height: 4),
           if (product.category == 'accessory')
             Row(
               children: [
                 Icon(
                   Icons.circle,
                   color: product.isAvailable ? Colors.green : Colors.red,
                   size: 12,
                 ),
                 SizedBox(width: 5),
                 Text(
                   product.isAvailable ? 'Available' : 'Unavailable',
                   style: TextStyle(
                     fontSize: 10,
                     fontWeight: FontWeight.w500,
                     color: Colors.black.withOpacity(0.7),
                   ),
                 ),
               ],
             ),
               ],
          
        
      ),
    );
  }
}


class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: productPriceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Product newProduct = Product(
                  id: DateTime.now().millisecondsSinceEpoch,
                  productName: productNameController.text,
                  productImage: 'assets/AKG.png',
                  category: 'product',
                  productPrice: double.parse(productPriceController.text),
                );

                _saveProduct(newProduct);
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProduct(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? savedProducts = prefs.getStringList('products') ?? [];
    savedProducts.add(jsonEncode(product.toJson()));

    await prefs.setStringList('products', savedProducts);
    Navigator.of(context).pop(product);
  }
}