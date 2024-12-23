import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cartitem.dart';
import 'package:flutter_application_1/providers/cart_provider.dart';
import 'package:flutter_application_1/screens/UserScreen/Cart_Checkout.dart';
import 'package:flutter_application_1/utils/const.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<bool> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _selectedItems = List<bool>.filled(widget.cartItems.length, false);
  }

  // Handle the checkbox state change
  void _onCheckboxChanged(int index, bool? value) {
    setState(() {
      _selectedItems[index] = value ?? false;
    });
  }

  // Handle checkout for selected items
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

    double totalAmount = _calculateTotal(); // Menghitung total harga yang dipilih

    // Menampilkan dialog konfirmasi checkout
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Konfirmasi Checkout'),
        content: Text('Total yang harus dibayar: Rp ${totalAmount.toString()}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartCheckout(
                    products: selectedItems,
                    totalAmount: totalAmount.toInt(), // Passing total amount to CartCheckout
                  ),
                ),
              );
            },
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }

  // Calculate the total for selected items
  double _calculateTotal() {
    return widget.cartItems.asMap().entries.fold(0.0, (total, entry) {
      if (_selectedItems[entry.key]) {
        total += entry.value.price * entry.value.quantity; // Menghitung total berdasarkan kuantitas
      }
      return total;
    });
  }

  // Increase quantity of item in cart
  void _increaseQuantity(int index) {
    setState(() {
      widget.cartItems[index].quantity++;
    });
  }

  // Decrease quantity of item in cart
  void _decreaseQuantity(int index) {
    setState(() {
      if (widget.cartItems[index].quantity > 1) {
        widget.cartItems[index].quantity--;
      }
    });
  }

  void _deleteItem(int index) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    String productId = widget.cartItems[index].productId.toString();

    cart.removeItem(productId);

    setState(() {
      widget.cartItems.removeAt(index);
      _selectedItems.removeAt(index); // Remove selection for the deleted item
    });
  }

  // Build the product card widget for each item
  Widget _buildProductCard(int index, CartItem product) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Image.network(
              Uri.encodeFull('$host/${product.imageUrl}'),
              fit: BoxFit.cover,
              width: 70,
              height: 70,
            ),
            SizedBox(width: 12), // Space between image and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rp ${product.price}\nStok: ${product.product.stok}',
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity controls
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => _decreaseQuantity(index),
                          ),
                          Text('${product.quantity}', style: TextStyle(fontSize: 16)),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => _increaseQuantity(index),
                          ),
                        ],
                      ),
                      // Delete button
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(index),
                      ),
                      // Checkbox for selection
                      Checkbox(
                        value: _selectedItems[index],
                        onChanged: (value) => _onCheckboxChanged(index, value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                return _buildProductCard(index, product);
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
