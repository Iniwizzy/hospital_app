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
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: PasienHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PasienHomePage extends StatefulWidget {
  @override
  _PasienHomePageState createState() => _PasienHomePageState();
}

class _PasienHomePageState extends State<PasienHomePage>
    with TickerProviderStateMixin {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _kirimPermintaan(int nomorPasien) async {
    setState(() {
      _isLoading = true;
    });

    _rippleController.forward().then((_) {
      _rippleController.reset();
    });

    String id = "0$nomorPasien";
    String path = "pasien/$id";
    final DatabaseReference pasienRef = _dbRef.child(path);

    try {
      // Ambil data sebelumnya
      final snapshot = await pasienRef.get();
      int frekuensi = 1;

      if (snapshot.exists && snapshot.child("frekuensi").value != null) {
        frekuensi = (snapshot.child("frekuensi").value as int) + 1;
      }

      // Set data baru
      await pasienRef.set({
        "status": 1,
        "pesan": "Pasien $nomorPasien Meminta Bantuan",
        "frekuensi": frekuensi,
      });

      Fluttertoast.showToast(
        msg: "✅ Permintaan dari Pasien $nomorPasien dikirim (x$frekuensi)",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "❌ Gagal mengirim permintaan. Coba lagi!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildEmergencyButton(int nomorPasien) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFF5722),
                  Color(0xFFE53935),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFF6B6B).withOpacity(0.4),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Color(0xFFFF6B6B).withOpacity(0.2),
                  blurRadius: 40,
                  offset: Offset(0, 20),
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Ripple effect
                AnimatedBuilder(
                  animation: _rippleAnimation,
                  builder: (context, child) {
                    return Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withOpacity(
                              (1 - _rippleAnimation.value) * 0.8,
                            ),
                            width: 3 * _rippleAnimation.value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Main button content
                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Patient icon with pulse effect
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Patient number
                      Text(
                        "PASIEN $nomorPasien",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Subtitle
                      Text(
                        "Tekan untuk minta bantuan",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 24),

                      // Emergency button
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap:
                                _isLoading
                                    ? null
                                    : () => _kirimPermintaan(nomorPasien),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isLoading) ...[
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color(0xFFFF6B6B),
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Mengirim...",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFF6B6B),
                                      ),
                                    ),
                                  ] else ...[
                                    Icon(
                                      Icons.emergency,
                                      color: Color(0xFFFF6B6B),
                                      size: 28,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "MINTA BANTUAN",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFF6B6B),
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1ABC9C),
                      Color(0xFF16A085),
                      Color(0xFF0891B2),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.local_hospital,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sistem Emergency",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Bantuan Medis Cepat",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Instructions
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(24),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFF2196F3).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF1976D2), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Tekan tombol emergency untuk mengirim permintaan bantuan ke perawat",
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Emergency buttons
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildEmergencyButton(index + 1);
            }, childCount: 2),
          ),

          // Bottom spacing
          SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
