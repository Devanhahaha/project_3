import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
import '../models/transaksi.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // late List<TransactionData> _transactionSummary;

  // @override
  // void initState() async {
  //   super.initState();
  //   _transactionSummary = await ApiService().fetchTransactionSummary();
  // }

  // List<charts.Series<TransactionData, String>> _createChartData(Map<String, dynamic> summary) {
  //   final List<TransactionData> data = [
  //     TransactionData('Pulsa', summary['pulsa_total'] ?? 0),
  //     TransactionData('Paket Data', summary['paketdata_total'] ?? 0),
  //     TransactionData('Bayar Tagihan', summary['bayartagihan_total'] ?? 0),
  //     TransactionData('Services', summary['services_total'] ?? 0),
  //     TransactionData('Pemesanan Product', summary['pemesananproduct_total'] ?? 0),
  //   ];

  //   return [
  //     charts.Series<TransactionData, String>(
  //       id: 'Transactions',
  //       domainFn: (TransactionData transactions, _) => transactions.type,
  //       measureFn: (TransactionData transactions, _) => transactions.total,
  //       data: data,
  //     ),
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false, // Hapus panah back
      ),
      body: FutureBuilder<List<TransactionData>>(
        future: ApiService().fetchTransactionSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Error: Exception: Failed to load transaction data'),
            );
          }

          // final List<charts.Series<TransactionData, String>> chartData = snapshot.data!;

          // return Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Column(
          //     children: <Widget>[
          //       Expanded(
          //         child: charts.BarChart(
          //           chartData,
          //           animate: true,
          //         ),
          //       ),
          //     ],
          //   ),
          // );

          return SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Grafik Transaksi Perbulan'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<TransactionData, String>>[
                LineSeries<TransactionData, String>(
                    dataSource: snapshot.data,
                    xValueMapper: (TransactionData sales, _) => sales.bulan,
                    yValueMapper: (TransactionData sales, _) => sales.total,
                    name: 'Transaksi',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]);
        },
      ),
    );
  }
}

// class TransactionData {
//   final String type;
//   final int total;

//   TransactionData(this.type, this.total);
// }
