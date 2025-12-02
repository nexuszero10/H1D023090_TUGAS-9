import 'package:flutter/material.dart';
import 'package:pertemuan_10_toko_api/bloc/produk_bloc.dart';
import 'package:pertemuan_10_toko_api/model/produk.dart';
import 'package:pertemuan_10_toko_api/ui/produk_page.dart';
import 'package:pertemuan_10_toko_api/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;
  const ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String judul;
  late String tombolSubmit;

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      judul = "UBAH PRODUK";
      tombolSubmit = "UBAH";
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
      _namaProdukTextboxController.text = widget.produk!.namaProduk!;
      _hargaProdukTextboxController.text = widget.produk!.hargaProduk
          .toString();
    } else {
      judul = "TAMBAH PRODUK";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeProdukTextField(),
                _namaProdukTextField(),
                _hargaProdukTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Produk"),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "Kode Produk harus diisi";
        return null;
      },
    );
  }

  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "Nama Produk harus diisi";
        return null;
      },
    );
  }

  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) return "Harga harus diisi";
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        if (_formKey.currentState!.validate() && !_isLoading) {
          if (widget.produk != null) {
            _update();
          } else {
            _simpan();
          }
        }
      },
    );
  }

  void _simpan() {
    setState(() => _isLoading = true);

    Produk createProduk = Produk(
      id: null,
      kodeProduk: _kodeProdukTextboxController.text,
      namaProduk: _namaProdukTextboxController.text,
      hargaProduk: int.parse(_hargaProdukTextboxController.text),
    );

    ProdukBloc.addProduk(produk: createProduk)
        .then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProdukPage()),
          );
        })
        .catchError((error) {
          showDialog(
            context: context,
            builder: (context) => const WarningDialog(
              description: "Simpan gagal, silahkan coba lagi",
            ),
          );
        })
        .whenComplete(() {
          setState(() => _isLoading = false);
        });
  }

  void _update() {
    // nanti implementasi update produk di sini
  }
}
