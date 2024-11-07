import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/const.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_application_1/utils/preferences_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import '../models/product.dart';
import 'addproduct_screen.dart';
import 'editproduct_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<Product>> futureProduct;

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

  Future<void> deleteProduct(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$host/api/product/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${PreferencesHelper.instance.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          futureProduct = fetchProduct();
        });
        log('Product deleted successfully');
        Alert(
          context: context,
          title: "Success",
          desc: "Product deleted successfully!",
          type: AlertType.success,
        ).show();
      } else {
        log('Failed to delete Product: ${response.statusCode}');
        Alert(
          context: context,
          title: "Error",
          desc: "Failed to delete product.",
          type: AlertType.error,
        ).show();
        throw Exception('Failed to delete Product');
      }
    } catch (e) {
      log('Error deleting Product: $e');
      throw Exception('Error deleting Product');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        automaticallyImplyLeading: false, // Hapus panah back
        backgroundColor: Colors.blueAccent, // Warna AppBar
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No product found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                String imageUrl = Uri.encodeFull(
                    '$host/${product.gambar}'); // Contoh path gambar
                return ListTile(
                  leading: Image.network(imageUrl), // Menggunakan URL gambar
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama: ${product.namaProduct}'), // Nama Produk
                      Text('Jenis: ${product.jenis}'), // Jenis Produk
                      Text('Merk: ${product.merk}'), // Merek Produk
                      Text('Stok: ${product.stok}'), // Menampilkan Stok
                      Text('Harga: ${product.nominal}'), // Menampilkan Nominal
                    ],
                  ),
                  subtitle: Text(
                      'Deskripsi: ${product.deskripsi}'), // Deskripsi Produk
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Arahkan ke halaman edit product
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProductScreen(product: product),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Hapus produk
                          deleteProduct(product.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Arahkan ke halaman tambah product
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
