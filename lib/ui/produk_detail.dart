import 'package:flutter/material.dart';
import 'package:pertemuan_10_toko_api/model/produk.dart';
import 'package:pertemuan_10_toko_api/ui/produk_form.dart';

// ignore: must_be_immutable
class ProdukDetail extends StatefulWidget {
  Produk? produk;

  ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk Tansah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: produk == null
            ? const Center(child: Text('Produk tidak ditemukan'))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kode : ${produk.kodeProduk}",
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Nama : ${produk.namaProduk}",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Harga : Rp. ${produk.hargaProduk}",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20),
                  _tombolHapusEdit(),
                ],
              ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () async {
            // buka form edit dan tunggu hasil (mis. produk terupdate)
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(produk: widget.produk),
              ),
            );

            // jika form mengembalikan produk yang diupdate, perbarui tampilan
            if (result is Produk) {
              setState(() {
                widget.produk = result;
              });
            }
          },
        ),
        const SizedBox(width: 10),
        // Tombol Hapus
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("Yakin ingin menghapus data ini?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text("Ya"),
              onPressed: () {
                // Tutup dialog dan kirim true untuk menandakan konfirmasi hapus
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        // Kembalikan hasil ke halaman sebelumnya supaya halaman list bisa menjalankan penghapusan nyata (API / local)
        Navigator.of(context).pop(true);
        // Opsional: tampilkan SnackBar sementara sebelum kembali
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data dihapus (konfirmasi dikirim).')),
        );
      }
    });
  }
}
