import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/const.dart';
import 'package:flutter_application_1/utils/preferences_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import '../../models/product.dart';
import 'productdetail_screen.dart'; // Halaman detail produk
import 'cart_screen.dart'; // Import halaman cart jika ada
import 'package:shared_preferences/shared_preferences.dart';

class UserProduct extends StatefulWidget {
  const UserProduct({super.key});

  @override
  _UserProductState createState() => _UserProductState();
}

class _UserProductState extends State<UserProduct> {
  late Future<List<Product>> futureProduct;
  List<Product> cartItems = [];

  @override
  void initState() {
    super.initState();
    futureProduct = fetchProduct();
  }

  Future<List<Product>> fetchProduct() async {
    try {
      final response = await http.get(
        Uri.parse('$host/api/product'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${PreferencesHelper.instance.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log('Product orders loaded successfully: ${data['data'].length} items');
        return Product.fromJsonList(data['data']);
      } else {
        log('Failed to load Product: ${response.statusCode}');
        throw Exception('Failed to load Product');
      }
    } catch (e) {
      log('Error fetching Product: $e');
      throw Exception('Error fetching Product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Produk Kami',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
        actions: [
          // Menambahkan Icon Keranjang
          IconButton(
            icon: Stack(
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: 28,
                  color: Colors.white,
                ),
                if (cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${cartItems.length}', // Menampilkan jumlah item dalam keranjang
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              // Navigasi ke halaman keranjang
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cartItems: cartItems),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Produk Tersedia',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),

            // Grid Produk
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: futureProduct,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    var products = snapshot.data!;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _buildProductCard(product);
                      },
                    );
                  } else {
                    return Center(child: Text('No products available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk kartu produk
  Widget _buildProductCard(Product product) {
    return InkWell(
      onTap: () {
        // Navigasi ke halaman detail produk
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Agar elemen di kiri
          children: [
            // Gambar produk
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  Uri.encodeFull('$host/${product.gambar}'),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            
            // Nama produk dan jenis produk di bawah gambar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Untuk rata kiri
                children: [
                  Text(
                    product.namaProduct, // Menampilkan nama produk
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    product.jenis, // Menampilkan jenis produk
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Ketersediaan di kiri bawah
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: product.stok > 0 ? Colors.green : Colors.red,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text(
                    product.stok > 0 ? 'Available' : 'Not Available',
                    style: TextStyle(
                      fontSize: 12,
                      color: product.stok > 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Harga di kanan bawah
            Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Rp ${product.nominal}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menambahkan produk ke keranjang
  void addToCart(Product product) {
    setState(() {
      cartItems.add(product); // Menambahkan produk ke dalam keranjang
    });
  }
}
