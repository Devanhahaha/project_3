import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/UserScreen/Cart_Checkout.dart';
import 'package:flutter_application_1/utils/const.dart';
import '../../models/product.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<bool> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize the selection state for all items
    _selectedItems = List<bool>.filled(widget.cartItems.length, false);
  }

  void _onCheckboxChanged(int index, bool? value) {
    setState(() {
      _selectedItems[index] = value ?? false;
    });
  }

  void _checkoutSelectedItems() {
    final selectedItems = widget.cartItems
        .asMap()
        .entries
        .where((entry) => _selectedItems[entry.key])
        .map((entry) => entry.value)
        .toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih setidaknya satu produk untuk checkout.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartCheckout(
          products: selectedItems,
        ), // Halaman checkout
      ),
    );
  }

  double _calculateTotal() {
    double total = 0;
    for (int i = 0; i < widget.cartItems.length; i++) {
      if (_selectedItems[i]) {
        total += widget.cartItems[i].nominal;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
        backgroundColor: Colors.blueAccent,
      ),
      body: widget.cartItems.isEmpty
          ? Center(
              child: Text(
                'Keranjang kosong',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final product = widget.cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      Uri.encodeFull('$host/${product.gambar}'),
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(
                      product.namaProduct,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Rp ${product.nominal}\nStok: ${product.stok}',
                      style: TextStyle(color: Colors.black54),
                    ),
                    isThreeLine: true,
                    trailing: Checkbox(
                      value: _selectedItems[index],
                      onChanged: (value) => _onCheckboxChanged(index, value),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: _checkoutSelectedItems,
          icon: Icon(Icons.payment),
          label: Text('Checkout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 16),
            textStyle: TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
