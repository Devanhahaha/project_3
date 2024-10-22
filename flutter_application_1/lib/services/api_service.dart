import 'dart:convert';
import 'package:flutter_application_1/models/paketdata.dart';
import 'package:flutter_application_1/models/productcust.dart';
import 'package:flutter_application_1/models/pulsa.dart';
import 'package:flutter_application_1/models/bayartagihan.dart';
import 'package:flutter_application_1/models/services.dart';
import 'package:flutter_application_1/models/transaksi.dart';
import 'package:flutter_application_1/utils/const.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class ApiService {
  static const String baseUrl = '$host/api';

  Future<List<TransactionData>> fetchTransactionSummary() async {
    final response =
        await http.get(Uri.parse('$baseUrl/transaksi'));

    if (response.statusCode == 200) {
       List<dynamic> data = json.decode(response.body);
        return data.map((json) => TransactionData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transaction data');
    }
  }

  // Method to fetch products from the server
  Future<List<Product>> fetchProduct() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        log('Failed to load product: ${response.statusCode}');
        throw Exception('Failed to load product');
      }
    } catch (e) {
      log('Error fetching product: $e');
      throw Exception('Error fetching product');
    }
  }

  // Method to handle user login
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: json.encode({
          'username': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Login failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error during login: $e');
      return false;
    }
  }

  // Method to submit pulsa order
  Future<bool> submitPulsaOrder(
      String name, String phone, double amount, String provider) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pulsa'),
        body: json.encode({
          'name': name,
          'phone': phone,
          'amount': amount,
          'provider': provider,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Failed to submit pulsa order: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error submitting pulsa order: $e');
      return false;
    }
  }

  // Method to submit paket data order
  Future<bool> submitPaketdataOrder(
      String name, String phone, double amount, String provider) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/paketdata'),
        body: json.encode({
          'name': name,
          'phone': phone,
          'amount': amount,
          'provider': provider,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Failed to submit paket data order: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error submitting paket data order: $e');
      return false;
    }
  }

  // Method to fetch paketdata orders for reports
  Future<List<Paketdata>> fetchPaketdataOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/paketdata'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log('Paketdata orders loaded successfully: ${data.length} items');
        return Paketdata.fromJsonList(data['data']);
      } else {
        log('Failed to load paketdata orders: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load Paketdata orders');
      }
    } catch (e) {
      log('Error fetching Paketdata orders: $e');
      throw Exception('Error fetching Paketdata orders');
    }
  }

  Future<List<Pulsa>> fetchPulsaOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pulsa'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log('Pulsa orders loaded successfully: ${data.length} items');
        return Pulsa.fromJsonList(data['data']);
      } else {
        log('Failed to load pulsa orders: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load pulsa orders');
      }
    } catch (e) {
      log('Error fetching pulsa orders: $e');
      throw Exception('Error fetching pulsa orders');
    }
  }

  Future<List<Bayartagihan>> fetchBayartagihanOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bayartagihan'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log('Bayartagihan orders loaded successfully: ${data.length} items');
        return Bayartagihan.fromJsonList(data['data']);
      } else {
        log('Failed to load Bayartagihan orders: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load bayartagihan orders');
      }
    } catch (e) {
      log('Error fetching bayartagihan orders: $e');
      throw Exception('Error fetching bayartagihan orders');
    }
  }

  Future<List<Services>> fetchServicesOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log('services orders loaded successfully: ${data.length} items');
        return Services.fromJsonList(data['data']);
      } else {
        log('Failed to load Services orders: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load Services orders');
      }
    } catch (e) {
      log('Error fetching Services orders: $e');
      throw Exception('Error fetching Services orders');
    }
  }

  Future<List<ProductCust>> fetchProductCustOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/productcust'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log('productcust orders loaded successfully: ${data.length} items');
        return ProductCust.fromJsonList(data['data']);
      } else {
        log('Failed to load ProductCust orders: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load ProductCust orders');
      }
    } catch (e) {
      log('Error fetching ProductCust orders: $e');
      throw Exception('Error fetching ProductCust orders');
    }
  }
}

// Product model class to map JSON data
class Product {
  final int id;
  final String name;
  final String deskripsi;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.deskripsi,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      deskripsi: json['deskripsi'],
      price: json['price'].toDouble(), // Ensure double type for price
    );
  }
}

// PulsaOrder model class to map JSON data
class PulsaOrder {
  final String name;
  final String phone;
  final double amount;
  final String provider;

  PulsaOrder({
    required this.name,
    required this.phone,
    required this.amount,
    required this.provider,
  });

  factory PulsaOrder.fromJson(Map<String, dynamic> json) {
    return PulsaOrder(
      name: json['name'],
      phone: json['phone'],
      amount: json['amount'].toDouble(),
      provider: json['provider'],
    );
  }
}
