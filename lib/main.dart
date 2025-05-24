import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(PasienApp());
}

class PasienApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasien - Minta Bantuan',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: PasienHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PasienHomePage extends StatelessWidget {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  void _kirimPermintaan(int nomorPasien) async {
    String id = "0$nomorPasien";
    String path = "pasien/$id";
    final DatabaseReference pasienRef = _dbRef.child(path);

    // Ambil data sebelumnya
    final snapshot = await pasienRef.get();
    int frekuensi = 1;

    if (snapshot.exists && snapshot.child("frekuensi").value != null) {
      frekuensi = (snapshot.child("frekuensi").value as int) + 1;
    }

    // Set data baru
    pasienRef
        .set({
          "status": 1,
          "pesan": "Pasien $nomorPasien Meminta Bantuan",
          "frekuensi": frekuensi,
        })
        .then((_) {
          Fluttertoast.showToast(
            msg: "Permintaan dari Pasien $nomorPasien dikirim (x$frekuensi)",
          );
        });
  }

  Widget _buildTombol(int nomorPasien) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.person, size: 48, color: Colors.teal),
            SizedBox(height: 10),
            Text("Pasien $nomorPasien", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _kirimPermintaan(nomorPasien),
              icon: Icon(Icons.call),
              label: Text("Minta Bantuan"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
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
      appBar: AppBar(title: Text("Aplikasi Pasien")),
      body: GridView.count(
        crossAxisCount: 1,
        padding: EdgeInsets.all(16),
        mainAxisSpacing: 16,
        children: [_buildTombol(1), _buildTombol(2)],
      ),
    );
  }
}
