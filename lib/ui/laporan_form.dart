import 'package:flutter/material.dart';
import 'package:responsi1/bloc/laporan_bloc.dart'; // Pastikan LaporanBloc sudah benar
import 'package:responsi1/models/laporan.dart'; // Pastikan model sudah benar
import 'package:responsi1/ui/laporan_page.dart'; // Pastikan Laporan page sudah benar
import 'package:responsi1/widget/warning_dialog.dart'; // Pastikan warning dialog sudah benar

// ignore: must_be_immutable
class LaporanForm extends StatefulWidget {
  Laporan? laporan; // Optional Laporan object for editing
  LaporanForm({Key? key, this.laporan}) : super(key: key);

  @override
  _LaporanFormState createState() => _LaporanFormState();
}

class _LaporanFormState extends State<LaporanForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH LAPORAN";
  String tombolSubmit = "SIMPAN";
  
  final _monthController = TextEditingController();
  final _incomeController = TextEditingController();
  final _expensesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  void isUpdate() {
    if (widget.laporan != null) {
      setState(() {
        judul = "UBAH LAPORAN";
        tombolSubmit = "UBAH";
        _monthController.text = widget.laporan?.month ?? ""; 
        _incomeController.text = widget.laporan?.income.toString() ?? "";
        _expensesController.text = widget.laporan?.expenses.toString() ?? "";
      });
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
                _monthTextField(),
                _incomeTextField(),
                _expensesTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _monthTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Bulan"),
      controller: _monthController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Bulan harus diisi";
        }
        return null;
      },
    );
  }

  Widget _incomeTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Pendapatan"),
      keyboardType: TextInputType.number,
      controller: _incomeController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Pendapatan harus diisi";
        }
        return null;
      },
    );
  }

  Widget _expensesTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Pengeluaran"),
      keyboardType: TextInputType.number,
      controller: _expensesController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Pengeluaran harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return OutlinedButton(
      child: Text(tombolSubmit),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (!_isLoading) {
            if (widget.laporan != null) {
              // Update laporan
              ubah();
            } else {
              // Add new laporan
              simpan();
            }
          }
        }
      },
    );
  }

  void simpan() {
    setState(() {
      _isLoading = true;
    });

    Laporan createLaporan = Laporan(
      id: null, 
      month: _monthController.text,
      income: int.tryParse(_incomeController.text) ?? 0,
      expenses: int.tryParse(_expensesController.text) ?? 0,
    );

    LaporanBloc.addLaporan(
      month: createLaporan.month ?? "", 
      income: createLaporan.income, 
      expenses: createLaporan.expenses,
      laporanData: createLaporan,
    ).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => const LaporanPage(),
      ));
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Simpan gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void ubah() {
    setState(() {
      _isLoading = true;
    });

    String month = _monthController.text.isNotEmpty ? _monthController.text : "Unknown"; 

    Laporan updateLaporan = Laporan(
      id: widget.laporan!.id,
      month: month, 
      income: int.tryParse(_incomeController.text) ?? 0,
      expenses: int.tryParse(_expensesController.text) ?? 0,
    );

    LaporanBloc.updateLaporan(
      laporan: updateLaporan,
      id: updateLaporan.id!,
      month: updateLaporan.month ?? "",
      income: updateLaporan.income,
      expenses: updateLaporan.expenses,
    ).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => const LaporanPage(),
      ));
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Permintaan ubah data gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
