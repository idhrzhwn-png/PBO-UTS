import 'package:flutter/material.dart';

void main() {
  runApp(const ZooApp());
}

// ================= ABSTRACT CLASS =================

abstract class Hewan {
  String nama;
  int umur;
  String suaraHewan;
  String urlGambar;

  Hewan(this.nama, this.umur, this.suaraHewan, this.urlGambar);

  String suara() {
    return suaraHewan;
  }

  String aksi();

  String informasi() {
    return "Nama : $nama\nUmur : $umur tahun";
  }

}

// ================= CLASS TURUNAN =================

class Singa extends Hewan {
  String habitat;

  Singa(String nama, int umur, String suaraHewan, String urlGambar, this.habitat)
      : super(nama, umur, suaraHewan, urlGambar);

  @override
  String aksi() {
    return "$nama sedang berburu di $habitat";
  }
}

class Burung extends Hewan {
  double panjangSayap;

  Burung(String nama, int umur, String suaraHewan, String urlGambar, this.panjangSayap)
      : super(nama, umur, suaraHewan, urlGambar);

  @override
  String aksi() {
    return "$nama terbang dengan sayap selebar $panjangSayap cm";
  }
}

class Ikan extends Hewan {
  String jenisAir;

  Ikan(String nama, int umur, String suaraHewan, String urlGambar, this.jenisAir)
      : super(nama, umur, suaraHewan, urlGambar);

  @override
  String aksi() {
    return "$nama berenang di $jenisAir";
  }
}

// ================= FLUTTER UI =================

class ZooApp extends StatelessWidget {
  const ZooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Zoo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.teal,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: const DaftarHewanScreen(),
    );
  }
}

// ================= HALAMAN UTAMA =================

class DaftarHewanScreen extends StatefulWidget {
  const DaftarHewanScreen({super.key});

  @override
  State<DaftarHewanScreen> createState() => _DaftarHewanScreenState();
}

class _DaftarHewanScreenState extends State<DaftarHewanScreen> {
  // Disimpan di memori, selalu kosong saat program start
  final List<Hewan> _daftarHewan = [];

  void _tambahHewan(Hewan hewanBaru) {
    setState(() {
      _daftarHewan.add(hewanBaru);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zoo Explorer"),
      ),
      body: _daftarHewan.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada data hewan.",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _daftarHewan.length,
              itemBuilder: (context, index) {
                Hewan hewan = _daftarHewan[index];
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
                        child: hewan.urlGambar.isNotEmpty
                            ? Image.network(
                                hewan.urlGambar,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: 180,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image,
                                      size: 50, color: Colors.grey),
                                ),
                              )
                            : Container(
                                height: 180,
                                color: Colors.teal[100],
                                child: const Icon(Icons.pets,
                                    size: 50, color: Colors.teal),
                              ),
                      ),
                      // Bagian Informasi
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hewan.nama,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(hewan.informasi(),
                                style: TextStyle(color: Colors.grey[700])),
                            const Divider(height: 24),
                            _buildInfoRow(Icons.volume_up, "Suara", hewan.suara()),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.directions_run, "Aksi", hewan.aksi()),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final Hewan? hewanBaru = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormTambahHewan()),
          );

          if (hewanBaru != null) {
            _tambahHewan(hewanBaru);
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
        Icon(icon, size: 20, color: Colors.teal),
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

class FormTambahHewan extends StatefulWidget {
  const FormTambahHewan({super.key});

  @override
  State<FormTambahHewan> createState() => _FormTambahHewanState();
}

class _FormTambahHewanState extends State<FormTambahHewan> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _umurController = TextEditingController();
  final _suaraController = TextEditingController();
  final _gambarController = TextEditingController();
  final _atributKhususController = TextEditingController();

  String _jenisHewan = 'Singa';

  @override
  void dispose() {
    _namaController.dispose();
    _umurController.dispose();
    _suaraController.dispose();
    _gambarController.dispose();
    _atributKhususController.dispose();
    super.dispose();
  }

  void _simpanData() {
    if (_formKey.currentState!.validate()) {
      Hewan hewanBaru;
      String nama = _namaController.text;
      int umur = int.parse(_umurController.text);
      String suara = _suaraController.text;
      String gambar = _gambarController.text;
      String atributKhusus = _atributKhususController.text;

      if (_jenisHewan == 'Singa') {
        hewanBaru = Singa(nama, umur, suara, gambar, atributKhusus);
      } else if (_jenisHewan == 'Burung') {
        double sayap = double.tryParse(atributKhusus) ?? 0.0;
        hewanBaru = Burung(nama, umur, suara, gambar, sayap);
      } else {
        hewanBaru = Ikan(nama, umur, suara, gambar, atributKhusus);
      }

      Navigator.pop(context, hewanBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Hewan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _jenisHewan,
                decoration: _inputStyle("Jenis Hewan", Icons.category),
                items: ['Singa', 'Burung', 'Ikan']
                    .map((jenis) => DropdownMenuItem(
                          value: jenis,
                          child: Text(jenis),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _jenisHewan = value!;
                    _atributKhususController.clear();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: _inputStyle("Nama Hewan", Icons.badge),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _umurController,
                keyboardType: TextInputType.number,
                decoration: _inputStyle("Umur (Tahun)", Icons.calendar_today),
                validator: (value) {
                  if (value!.isEmpty) return 'Umur tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _suaraController,
                decoration: _inputStyle("Suara (Contoh: Roar!)", Icons.volume_up),
                validator: (value) =>
                    value!.isEmpty ? 'Suara tidak boleh kosong' : null,
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
                keyboardType: _jenisHewan == 'Burung'
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.text,
                decoration: _inputStyle(
                  _jenisHewan == 'Singa'
                      ? "Habitat (Contoh: Sabana)"
                      : _jenisHewan == 'Burung'
                          ? "Panjang Sayap (cm)"
                          : "Jenis Air (Contoh: Air Tawar)",
                  Icons.star,
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
                  backgroundColor: Colors.teal,
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
      prefixIcon: Icon(icon, color: Colors.teal),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.teal, width: 2),
      ),
    );
  }
}