import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/const.dart';
import '../../models/cartitem.dart';

class UserCart extends StatefulWidget {
  final List<CartItem> cartItems;

  UserCart({required this.cartItems});

  @override
  _UserCartState createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  // List untuk menyimpan status checkbox
  List<bool> selectedItems = [];

  // Fungsi untuk menghitung total harga
  double getTotalPrice() {
    double total = 0;
    for (var i = 0; i < widget.cartItems.length; i++) {
      if (selectedItems[i]) {
        total += widget.cartItems[i].price * widget.cartItems[i].quantity;
      }
    }
    return total;
  }

  // Fungsi untuk memperbarui status checkbox
  void toggleCheckbox(int index) {
    setState(() {
      selectedItems[index] = !selectedItems[index];
    });
  }

  // Fungsi untuk memperbarui quantity
  void updateQuantity(int index, int newQuantity) {
    setState(() {
      widget.cartItems[index].quantity = newQuantity;
    });
  }

  @override
  void initState() {
    super.initState();
    // Inisialisasi status checkbox untuk setiap item
    selectedItems = List.generate(widget.cartItems.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja'),
        backgroundColor: Colors.blueAccent,
      ),
      body: widget.cartItems.isEmpty
          ? Center(child: Text('Keranjang Anda Kosong'))
          : Column(
              children: [
                // Header Total Harga
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Harga: Rp ${getTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                // Daftar Item dalam Keranjang
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              Uri.encodeFull('$host/${item.imageUrl}'),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            item.productName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: [
                              Text('Rp ${item.price} x ${item.quantity}'),
                              SizedBox(width: 10),
                              // Input quantity with Expanded
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(
                                      text: item.quantity.toString()),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      updateQuantity(index, int.parse(value));
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Qty',
                                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                                    border: OutlineInputBorder(),
                                    counterText: '',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Logika untuk menghapus item
                              print('Item ${item.productName} dihapus');
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Card untuk Checkbox dan Tombol Checkout
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Checkbox untuk memilih item
                            for (int i = 0; i < widget.cartItems.length; i++)
                              Row(
                                children: [
                                  Checkbox(
                                    value: selectedItems[i],
                                    onChanged: (_) => toggleCheckbox(i),
                                  ),
                                  Text(widget.cartItems[i].productName),
                                ],
                              ),
                          ],
                        ),
                        // Tombol Checkout
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Logika Checkout
                              print('Proses Checkout');
                            },
                            child: Text('Proses Checkout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
