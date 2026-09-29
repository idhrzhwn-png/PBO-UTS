import 'package:flutter/material.dart';

void main() {
  runApp(const GadgetApp());
}

// ================= ABSTRACT CLASS =================

abstract class Perangkat {
  String nama;
  int garansi;
  String fitur;
  String urlGambar;

  Perangkat(this.nama, this.garansi, this.fitur, this.urlGambar);

  String fiturUnggulan() {
    return fitur;
  }

  String kegunaan();

  String informasi() {
    return "Nama : $nama\nGaransi : $garansi tahun";
  }

}

// ================= CLASS TURUNAN =================

class Laptop extends Perangkat {
  String prosesor;

  Laptop(String nama, int garansi, String fitur, String urlGambar, this.prosesor)
      : super(nama, garansi, fitur, urlGambar);

  @override
  String kegunaan() {
    return "$nama siap dipakai kerja berat dengan prosesor $prosesor";
  }
}

class Ponsel extends Perangkat {
  double ukuranLayar;

  Ponsel(String nama, int garansi, String fitur, String urlGambar, this.ukuranLayar)
      : super(nama, garansi, fitur, urlGambar);

  @override
  String kegunaan() {
    return "$nama nyaman dipakai sehari-hari dengan layar $ukuranLayar inci";
  }
}

class Tablet extends Perangkat {
  String konektivitas;

  Tablet(String nama, int garansi, String fitur, String urlGambar, this.konektivitas)
      : super(nama, garansi, fitur, urlGambar);

  @override
  String kegunaan() {
    return "$nama terhubung lewat $konektivitas";
  }
}

// ================= FLUTTER UI =================

class GadgetApp extends StatelessWidget {
  const GadgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechVault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.blueGrey[50],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.indigo,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: const DaftarPerangkatScreen(),
    );
  }
}

// ================= HALAMAN UTAMA =================

class DaftarPerangkatScreen extends StatefulWidget {
  const DaftarPerangkatScreen({super.key});

  @override
  State<DaftarPerangkatScreen> createState() => _DaftarPerangkatScreenState();
}

class _DaftarPerangkatScreenState extends State<DaftarPerangkatScreen> {
  // Disimpan di memori, selalu kosong saat program start
  final List<Perangkat> _daftarPerangkat = [];

  void _tambahPerangkat(Perangkat perangkatBaru) {
    setState(() {
      _daftarPerangkat.add(perangkatBaru);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TechVault"),
      ),
      body: _daftarPerangkat.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.devices, size: 80, color: Colors.blueGrey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada data perangkat.",
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _daftarPerangkat.length,
              itemBuilder: (context, index) {
                Perangkat perangkat = _daftarPerangkat[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min, // Memperbaiki error infinite layout
                    children: [
                      // Bagian Gambar
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: perangkat.urlGambar.isNotEmpty
                            ? Image.network(
                                perangkat.urlGambar,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: 180,
                                  color: Colors.blueGrey[100],
                                  child: const Icon(Icons.broken_image,
                                      size: 50, color: Colors.blueGrey),
                                ),
                              )
                            : Container(
                                height: 180,
                                color: Colors.indigo[100],
                                child: const Icon(Icons.devices,
                                    size: 50, color: Colors.indigo),
                              ),
                      ),
                      // Bagian Informasi
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              perangkat.nama,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(perangkat.informasi(),
                                style: TextStyle(color: Colors.blueGrey[700])),
                            const Divider(height: 24),
                            _buildInfoRow(Icons.bolt, "Fitur", perangkat.fiturUnggulan()),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.tips_and_updates, "Kegunaan", perangkat.kegunaan()),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () async {
          final Perangkat? perangkatBaru = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormTambahPerangkat()),
          );

          if (perangkatBaru != null) {
            _tambahPerangkat(perangkatBaru);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah Data"),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.indigo),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              children: [
                TextSpan(
                    text: "$title: ",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ================= HALAMAN FORM =================

class FormTambahPerangkat extends StatefulWidget {
  const FormTambahPerangkat({super.key});

  @override
  State<FormTambahPerangkat> createState() => _FormTambahPerangkatState();
}

class _FormTambahPerangkatState extends State<FormTambahPerangkat> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _garansiController = TextEditingController();
  final _fiturController = TextEditingController();
  final _gambarController = TextEditingController();
  final _atributKhususController = TextEditingController();

  String _jenisPerangkat = 'Laptop';

  @override
  void dispose() {
    _namaController.dispose();
    _garansiController.dispose();
    _fiturController.dispose();
    _gambarController.dispose();
    _atributKhususController.dispose();
    super.dispose();
  }

  void _simpanData() {
    if (_formKey.currentState!.validate()) {
      Perangkat perangkatBaru;
      String nama = _namaController.text;
      int garansi = int.parse(_garansiController.text);
      String fitur = _fiturController.text;
      String gambar = _gambarController.text;
      String atributKhusus = _atributKhususController.text;

      if (_jenisPerangkat == 'Laptop') {
        perangkatBaru = Laptop(nama, garansi, fitur, gambar, atributKhusus);
      } else if (_jenisPerangkat == 'Ponsel') {
        double layar = double.tryParse(atributKhusus) ?? 0.0;
        perangkatBaru = Ponsel(nama, garansi, fitur, gambar, layar);
      } else {
        perangkatBaru = Tablet(nama, garansi, fitur, gambar, atributKhusus);
      }

      Navigator.pop(context, perangkatBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Perangkat"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _jenisPerangkat,
                decoration: _inputStyle("Jenis Perangkat", Icons.category),
                items: ['Laptop', 'Ponsel', 'Tablet']
                    .map((jenis) => DropdownMenuItem(
                          value: jenis,
                          child: Text(jenis),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _jenisPerangkat = value!;
                    _atributKhususController.clear();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: _inputStyle("Nama Perangkat", Icons.badge),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _garansiController,
                keyboardType: TextInputType.number,
                decoration: _inputStyle("Garansi (Tahun)", Icons.verified_user),
                validator: (value) {
                  if (value!.isEmpty) return 'Garansi tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fiturController,
                decoration: _inputStyle("Fitur Unggulan (Contoh: Layar 120Hz)", Icons.bolt),
                validator: (value) =>
                    value!.isEmpty ? 'Fitur tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gambarController,
                decoration: _inputStyle("URL Gambar", Icons.image),
                validator: (value) =>
                    value!.isEmpty ? 'URL tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _atributKhususController,
                keyboardType: _jenisPerangkat == 'Ponsel'
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.text,
                decoration: _inputStyle(
                  _jenisPerangkat == 'Laptop'
                      ? "Prosesor (Contoh: Intel Core i7)"
                      : _jenisPerangkat == 'Ponsel'
                          ? "Ukuran Layar (inci)"
                          : "Konektivitas (Contoh: WiFi + Cellular)",
                  Icons.memory,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Atribut ini wajib diisi' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _simpanData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.indigo,
                ),
                child: const Text(
                  "SIMPAN DATA",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.indigo),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueGrey.shade200, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.indigo, width: 2),
      ),
    );
  }
}
