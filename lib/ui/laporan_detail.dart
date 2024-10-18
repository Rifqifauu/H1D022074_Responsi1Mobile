import 'package:flutter/material.dart';
import 'package:responsi1/bloc/laporan_bloc.dart';
import 'package:responsi1/models/laporan.dart';
import 'package:responsi1/ui/laporan_form.dart';
import 'package:responsi1/ui/laporan_page.dart';
import 'package:responsi1/widget/warning_dialog.dart';
 
// ignore: must_be_immutable
class LaporanDetail extends StatefulWidget {
  final Laporan? laporan;

  LaporanDetail({Key? key, this.laporan, required Laporan}) : super(key: key);

  @override
  _LaporanDetailState createState() => _LaporanDetailState();
}

class _LaporanDetailState extends State<LaporanDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan Bulanan'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "ID: ${widget.laporan!.id}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text( 
              "Month: ${widget.laporan!.month}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Income: Rp. ${widget.laporan!.income.toString()}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Expenses: Rp. ${widget.laporan!.expenses.toString()}",
              style: const TextStyle(fontSize: 18.0),
            ),
            _tombolHapusEdit()
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LaporanForm(
                  laporan: widget.laporan!,
                ),
              ),
            );
          },
        ),
        // Tombol Hapus
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() { 
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        // Tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
  // Attempt to convert the ID from String? to int
  int? id = int.tryParse(widget.laporan!.id ?? "");

  if (id != null) {
    // Proceed to delete if the id is valid
    LaporanBloc.deleteLaporan(id: id).then(
      (value) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LaporanPage(),
        ));
      },
      onError: (error) {
        // Handle the error case
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Hapus gagal, silahkan coba lagi",
          ),
        );
      },
    );
  } else {
    // Handle the case where ID is not valid
    showDialog(
      context: context,
      builder: (BuildContext context) => const WarningDialog(
        description: "ID tidak valid, silakan coba lagi.",
      ),
    );
  }
},        ),
        // Tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
