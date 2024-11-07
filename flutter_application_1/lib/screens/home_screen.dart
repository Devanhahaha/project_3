import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/preferences_helper.dart';
import 'pulsa_screen.dart';
import 'paket_data_screen.dart';
import 'bayar_tagihan_screen.dart';
import 'services_screen.dart';
import 'product_screen.dart';
import 'login_screen.dart';
import 'laporan_pulsa_screen.dart';
import 'laporan_paketdata_screen.dart';
import 'laporan_bayartagihan_screen.dart';
import 'laporan_services_screen.dart';
import 'laporan_pemesananproduct_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    DashboardScreen(),
    PulsaScreen(),
    PaketDataScreen(),
    BayarTagihanScreen(),
    ServicesScreen(),
    LaporanPulsaScreen(),
    LaporanPaketdataScreen(),
    LaporanBayarTagihanScreen(),
    LaporanServicesScreen(),
    LaporanPemesananProductScreen(),
    ProductScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DEVAN CELL'),
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ExpansionTile(
              leading: Icon(Icons.mobile_friendly),
              title: const Text('Layanan'),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.phone_android),
                  title: const Text('Pulsa'),
                  onTap: () {
                    _onItemTapped(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.wifi),
                  title: const Text('Paket Data'),
                  onTap: () {
                    _onItemTapped(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.receipt),
                  title: const Text('Bayar Tagihan'),
                  onTap: () {
                    _onItemTapped(3);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.build),
                  title: const Text('Services'),
                  onTap: () {
                    _onItemTapped(4);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.insert_drive_file),
              title: const Text('Laporan'),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.phone_iphone),
                  title: const Text('Laporan Pulsa'),
                  onTap: () {
                    _onItemTapped(5);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.data_usage),
                  title: const Text('Laporan Paket Data'),
                  onTap: () {
                    _onItemTapped(6);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.payment),
                  title: const Text('Laporan Bayar Tagihan'),
                  onTap: () {
                    _onItemTapped(7);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.build_circle),
                  title: const Text('Laporan Services'),
                  onTap: () {
                    _onItemTapped(8);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: const Text('Laporan Pemesanan Product'),
                  onTap: () {
                    _onItemTapped(9);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: const Text('Produk'),
              onTap: () {
                _onItemTapped(10);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () async {
                 await PreferencesHelper.instance.clearLoginData();
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.blue,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            '© 2024 DEVAN CELL - All Rights Reserved',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
