import 'package:flutter/material.dart';
import './model/crypto.dart';
import './service/api.dart';

void main() {
  runApp(CryptoApp());
}

class CryptoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CryptoListPage(),
    );
  }
}

class CryptoListPage extends StatefulWidget {
  @override
  _CryptoListPageState createState() => _CryptoListPageState();
}

class _CryptoListPageState extends State<CryptoListPage> {
  late Future<List<Crypto>> futureCryptos;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureCryptos = apiService.fetchCryptos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Crypto>>(
        future: futureCryptos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<Crypto> cryptos = snapshot.data!;
            return ListView.builder(
              itemCount: cryptos.length,
              itemBuilder: (context, index) {
                Crypto crypto = cryptos[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Menambahkan margin
                  child: ListTile(
                    title: Text(
                      crypto.name,
                      style: TextStyle(fontWeight: FontWeight.bold), // Mengubah gaya teks
                    ),
                    subtitle: Text(crypto.symbol),
                    trailing: Text(
                      '\$${crypto.priceUsd.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.green, fontSize: 16), // Mengubah warna dan ukuran teks
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
