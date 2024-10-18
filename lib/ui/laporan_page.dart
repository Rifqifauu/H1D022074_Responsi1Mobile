import 'package:flutter/material.dart';
import 'package:responsi1/bloc/logout_bloc.dart';
import 'package:responsi1/bloc/laporan_bloc.dart';
import 'package:responsi1/models/laporan.dart';
import 'package:responsi1/ui/login_page.dart';
import 'package:responsi1/ui/laporan_detail.dart';
import 'package:responsi1/ui/laporan_form.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Laporan'),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: const Icon(Icons.add, size: 26.0),
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LaporanForm()));
                },
              ))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile( 
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false)
                    });
              },
            )
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: LaporanBloc.getLaporans(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListLaporan(
                  list: snapshot.data,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class ListLaporan extends StatelessWidget {
  final List? list;

  const ListLaporan({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list!.length,
        itemBuilder: (context, i) {
          return ItemLaporan(
            Laporan: list![i], 
          );
        });
  }
}

class ItemLaporan extends StatelessWidget {
  final  Laporan;

  const ItemLaporan({Key? key, required this.Laporan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LaporanDetail(
                      Laporan: Laporan,
                    )));
      },
      child: Card(
        child: ListTile(
          title: Text(Laporan.namaLaporan!),
          subtitle: Text(Laporan.hargaLaporan.toString()),
        ),
      ),
    );
  }
}
