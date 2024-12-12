import 'dart:convert';
import 'package:flutter_application_1/utils/const.dart';
import 'package:flutter_application_1/utils/preferences_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class ApiServiceCust {
  static const String baseUrl = '$host/api';

   Future<String?> createTokenPulsa({
    required String name,
    required String phone,
    required int nominal,
  }) async {
    try {
      // Kirim data ke API Laravel untuk mendapatkan snapToken
      final response = await http.post(
        Uri.parse('$baseUrl/pulsa/createTransaction'),
        body: json.encode({
          'name': name,
          'phone': phone,
          'nominal': nominal,
          'email': 'test@domain.com',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${PreferencesHelper.instance.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['token'];
      } else {
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: ($e)');
      return null;
    }
  }

    // Method to submit pulsa order
  Future<bool> submitPulsaOrderCust(
      String name, String phone, double nominal, String provider) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pulsaCust'),
        body: json.encode({
          'nama': name,
          'no_telp': phone,
          'harga': nominal + 2000,
          'tipe_kartu': provider,
          'nominal': nominal,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${PreferencesHelper.instance.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Failed to submit pulsa order: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error submitting pulsa order: $e');
      return false;
    }
  }


   // Method to submit paket data order
  Future<bool> submitPaketdataOrderCust(
      String name, String phone, String nominal, String provider) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/paketdataCust'),
        body: json.encode({
          'nama': name,
          'no_telp': phone,
          'tipe_kartu': provider,
          'nominal': nominal,
          'harga': nominal,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${PreferencesHelper.instance.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Failed to submit paket data order: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error submitting paket data order: $e');
      return false;
    }
  }

   Future<String?> createTokenPaketData(
      {required String name,
      required String number,
      required String jenis,
      required String nominal}) async {
    try {
      // Kirim data ke API Laravel untuk mendapatkan snapToken
      final response = await http.post(
        Uri.parse('$baseUrl/paketdata/createTransaction'),
        body: json.encode({
          'name': name,
          'number': number,
          'jenis': jenis,
          'nominal': nominal,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${PreferencesHelper.instance.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['token'];
      } else {
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: ($e)');
      return null;
    }
  }

   Future<String?> createTokenBayarTagihan(
      {required int nominal,
      required String name,
      required String number,
      required String jenisTagihan}) async {
    try {
      // Kirim data ke API Laravel untuk mendapatkan snapToken
      final response = await http.post(
        Uri.parse('$baseUrl/pulsa/createTransaction'),
        body: json.encode({
          'nominal': nominal,
          'name': name,
          'number': number,
          'jenis_Tagihan': jenisTagihan,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${PreferencesHelper.instance.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['token'];
      } else {
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: ($e)');
      return null;
    }
  }

   Future<bool> submitBayartagihanOrder(
    String nama,
    String noTagihan,
    String tipeTagihan,
    double nominal,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bayartagihan'),
        body: json.encode({
          'nama': nama,
          'no_tagihan': noTagihan,
          'tipe_tagihan': tipeTagihan,
          'nominal': nominal,
          'harga': nominal + 3000,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${PreferencesHelper.instance.accessToken}'
        },
      );

      if (response.statusCode == 200) {
        log('Bayartagihan order created successfully');
        return true; // Tambahkan return true jika berhasil
      } else {
        log('Failed to create Bayartagihan order: ${response.body}');
        return false; // Return false jika gagal
      }
    } catch (e) {
      log('Error creating bayartagihan order: $e');
      return false; // Return false jika terjadi error
    }
  }

}