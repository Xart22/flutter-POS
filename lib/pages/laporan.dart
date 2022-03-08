import 'package:bigsam_pos/models/beban.dart';
import 'package:bigsam_pos/models/detail_laporan.dart';
import 'package:bigsam_pos/pages/detail_laporan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/laporan.dart';
import '../utils/database.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({Key? key}) : super(key: key);

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  var counter = 0;
  void getPdf() async {
    final List<DetailLaporanModel> data = await DatabaseHelper.instance
        .getDetailLaporanByTanggal(startDate.text, endDate.text);

    final List<LaporanModel> countData = await DatabaseHelper.instance
        .getLaporanByTanggal(startDate.text, endDate.text);

    final List<BebanModel> bebanData = await DatabaseHelper.instance.getBeban();
    late double totalDiskon;
    for (var item in data) {
      totalDiskon = double.parse(item.diskon.replaceAll('.', ''));
    }
    _formating(double value) {
      final formatter =
          NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');
      String newText = formatter.format(value).replaceAll('Rp. ', '');
      return newText;
    }

    _calculatePendapatanKotor(data) {
      double total = 0;
      for (var item in data) {
        total += double.parse(item.total_harga.replaceAll('.', ''));
      }
      return _formating(total);
    }

    _cakculateTotalTransaksi(String subtotal, String diskon) {
      double total = 0;
      total += double.parse(subtotal.replaceAll('.', ''));
      total -= double.parse(diskon.replaceAll('.', ''));
      return _formating(total);
    }

    _calculateModal(data) {
      double total = 0;
      for (var item in data) {
        total +=
            double.parse(item.hargaModal.replaceAll('.', '')) * item.jumlah;
      }
      return _formating(total);
    }

    _calculateTotal(String kotor, modal, beban) {
      double total = 0;
      total += double.parse(kotor.replaceAll('.', ''));
      total -= double.parse(modal.replaceAll('.', ''));
      total -= double.parse(beban.replaceAll('.', ''));
      return _formating(total);
    }

    _calculateBeban(List data) {
      double total = 0;
      double listrik = double.parse(data[0].hargaListrik.replaceAll('.', ''));
      double sewaGedung = double.parse(data[0].hargaSewa.replaceAll('.', ''));
      double gaji = double.parse(data[0].gaji.replaceAll('.', ''));
      double internet = double.parse(data[0].hargaInternet.replaceAll('.', ''));
      double lain = double.parse(data[0].hargaLain.replaceAll('.', ''));
      double pulsa = double.parse(data[0].hargaPulsa.replaceAll('.', ''));
      total += listrik + sewaGedung + gaji + internet + lain + pulsa;
      return _formating(total);
    }

    final pendapatanKotor = _calculatePendapatanKotor(data);

    final totalTransaksi =
        _cakculateTotalTransaksi(pendapatanKotor, _formating(totalDiskon));

    final totalModal = _calculateModal(data);

    final totalBeban = _calculateBeban(bebanData);

    final total = _calculateTotal(pendapatanKotor, totalModal, totalBeban);

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(build: (pw.Context context) {
        return pw.Center(
            child: pw.Column(children: [
          pw.Text(
            'Laporan Penjualan',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            'Periode ${startDate.text.isEmpty ? 'Semua' : startDate.text} - ${endDate.text.isEmpty ? 'Semua' : endDate.text}',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            children: [
              pw.TableRow(children: [
                pw.Text('No'),
                pw.Text('Tanggal'),
                pw.Text('Kode Transaksi'),
                pw.Text('Kode Produk'),
                pw.Text('Nama Produk'),
                pw.Text('Jumlah'),
                pw.Text('Total'),
              ]),
              ...data.map((e) {
                counter++;
                return pw.TableRow(children: [
                  pw.Text((counter).toString()),
                  pw.Text(e.tanggal_transaksi),
                  pw.Text(e.kode_transaksi),
                  pw.Text(e.kode_produk),
                  pw.Text(e.namaProduk),
                  pw.Text(e.jumlah.toString()),
                  pw.Text(e.total_harga.toString()),
                ]);
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text('Total Jumlah Transaksi :${countData.length}'),
          pw.Text('Total Transaksi : $pendapatanKotor'),
          pw.Text('Total diskon : Rp.  ${_formating(totalDiskon)} '),
          pw.Text('Total Pendatapatan Kotor : Rp. $totalTransaksi'),
          pw.Text('Total Pengeluaran Modal : Rp. $totalModal'),
          pw.Text('Sewa Gedung : Rp. ${bebanData[0].hargaSewa}'),
          pw.Text('Listrik : Rp. ${bebanData[0].hargaListrik}'),
          pw.Text('Internet : Rp. ${bebanData[0].hargaInternet}'),
          pw.Text('Pulsa : Rp. ${bebanData[0].hargaPulsa}'),
          pw.Text('Total Gajih Karyawan : Rp. ${bebanData[0].gaji}'),
          pw.Text('Lain - Lain : Rp. ${bebanData[0].hargaLain}'),
          pw.Text('Total Pendatapatan bersih : Rp.  $total'),
        ]));
      }),
    );

    Uint8List bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/pdf.pdf');

    await file.writeAsBytes(bytes);

    await OpenFile.open(file.path);
  }

  @override
  void initState() {
    startDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    endDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    super.initState();
  }

  int? selectedId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Transaksi'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(children: [
              TextField(
                controller: startDate, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Dari Tanggal" //label text of field
                    ),
                readOnly:
                    true, //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(
                          2000), //DateTime.now() / not to allow to choose before today.
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                    //formatted date output using intl package =>  2021/03/16
                    //you can implement different kind of Date Format here according to your requirement

                    setState(() {
                      startDate.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              ),
              TextField(
                controller: endDate, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Sampai Tanggal" //label text of field
                    ),
                readOnly:
                    true, //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(
                          2000), //DateTime.now() / not to allow to choose before today.
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    //pickedDate output format => 2021/03/10 00:00:00.000
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                    //formatted date output using intl package =>  2021/03/16
                    //you can implement different kind of Date Format here according to your requirement

                    setState(() {
                      endDate.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {}
                },
              ),
              const Divider(
                height: 5,
              ),
              const Center(
                child: Text('Laporan Transaksi',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              )
            ]),
          ),
          Expanded(
              flex: 2,
              child: FutureBuilder<List<LaporanModel>>(
                  future: DatabaseHelper.instance
                      .getLaporanByTanggal(startDate.text, endDate.text),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<LaporanModel>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('Loading...'));
                    }
                    return snapshot.data!.isEmpty
                        ? const Center(child: Text('Belum Ada Transaksi'))
                        : ListView(
                            children: snapshot.data!.map((laporan) {
                              return Center(
                                child: Card(
                                  color: selectedId == laporan.id
                                      ? Colors.white70
                                      : Colors.white,
                                  child: ListTile(
                                    title: Text(laporan.kode_transaksi),
                                    subtitle: Row(children: [
                                      Text(laporan.tanggal_transaksi),
                                      const SizedBox(width: 10),
                                      Text('Kasir : ' + laporan.kasir),
                                      const SizedBox(width: 10),
                                      Text('Jumlah Item : ' +
                                          laporan.jumlah.toString()),
                                      const SizedBox(width: 10),
                                      Text('Rp. ' +
                                          laporan.total_harga.toString()),
                                    ]),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.arrow_right),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailLaporanPage(
                                                    kasir: laporan.kasir,
                                                    kodeTransaksi:
                                                        laporan.kode_transaksi,
                                                    tanggal: laporan
                                                            .tanggal_transaksi +
                                                        ' ' +
                                                        laporan.waktu,
                                                  )),
                                        );
                                      },
                                    ),
                                    leading: const Icon(Icons.receipt_long),
                                    onLongPress: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailLaporanPage(
                                                  kasir: laporan.kasir,
                                                  kodeTransaksi:
                                                      laporan.kode_transaksi,
                                                  tanggal: laporan
                                                          .tanggal_transaksi +
                                                      ' ' +
                                                      laporan.waktu,
                                                )),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                  })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          setState(() {
            counter = 0;
          });
          getPdf();
        },
        child: const Icon(Icons.note),
      ),
    );
  }
}
