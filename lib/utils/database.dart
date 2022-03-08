import 'dart:io';

import 'package:bigsam_pos/models/detail_laporan.dart';
import 'package:bigsam_pos/models/update_stock.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:bigsam_pos/models/kontak.dart';
import 'package:bigsam_pos/models/produk.dart';
import 'package:bigsam_pos/models/transaksi.dart';
import 'package:bigsam_pos/models/cart.dart';
import 'package:bigsam_pos/models/outlet.dart';
import 'package:bigsam_pos/models/printer.dart';
import 'package:bigsam_pos/models/user.dart';
import 'package:bigsam_pos/models/laporan.dart';
import 'package:bigsam_pos/models/beban.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'bigsam.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY,
        name VARCHAR(100) NOT NULL UNIQUE,
        password VARCHAR(100) NOT NULL
      )''',
    );

    await db.execute(
      '''
      CREATE TABLE outlet (
        id INTEGER PRIMARY KEY,
        nama_toko VARCHAR(100) NOT NULL,
        alamat_toko TEXT,
        no_hp TEXT
      )''',
    );

    await db.execute(
      '''
      CREATE TABLE kontak (
        id INTEGER PRIMARY KEY,
        nama VARCHAR NOT NULL,
        nomor VARCHAR NOT NULL,
        alamat VARCHAR NOT NULL,
        email VARCHAR,
        foto VARCHAR
      )
      ''',
    );

    await db.execute(
      '''
      CREATE TABLE produk (
        id INTEGER PRIMARY KEY,
        kode_produk VARCHAR NOT NULL UNIQUE,
        nama_produk VARCHAR NOT NULL,
        harga_produk VARCHAR NOT NULL,
        modal_produk VARCHAR NOT NULL,
        stock_produk VARCHAR NOT NULL,
        satuan_produk VARCHAR
      )
      ''',
    );

    await db.execute('''
      CREATE TABLE cart (
        kode_transaksi VARCHAR NOT NULL,
        kode_produk VARCHAR NOT NULL,
        jumlah INTEGER NOT NULL,
        satuan VARCHAR(10) NOT NULL,
        total_harga VARCHAR NOT NULL,
        kontak_id INTEGER ,
        customer_name VARCHAR,
        FOREIGN KEY(kontak_id) REFERENCES kontak(id),
        FOREIGN KEY(kode_produk) REFERENCES produk(kode_produk)
      )
      ''');

    await db.execute('''
      CREATE TABLE printer (
        id INTEGER NOT NULL UNIQUE,
        name VARCHAR NOT NULL,
        address VARCHAR NOT NULL,
        type INTEGER NOT NULL
      )
      ''');

    await db.execute('''
        CREATE TABLE laporan (
          id INTEGER PRIMARY KEY,
          kode_transaksi VARCHAR NOT NULL,
          kode_produk VARCHAR NOT NULL,
          jumlah INTEGER NOT NULL,
          kasir VARCHAR NOT NULL,
          total_harga VARCHAR NOT NULL,
          tanggal_transaksi VARCHAR NOT NULL,
          diskon VARCHAR NOT NULL,
          total_bayar VARCHAR NOT NULL,
          waktu VARCHAR NOT NULL,
          FOREIGN KEY(kode_produk) REFERENCES produk(kode_produk)
        )
        ''');

    await db.execute('''
        CREATE TABLE beban (
          id INTEGER PRIMARY KEY,
        harga_listrik VARCHAR NOT NULL,
        harga_sewa VARCHAR NOT NULL,
        harga_lain VARCHAR NOT NULL,
        gaji VARCHAR NOT NULL,
        harga_internet VARCHAR NOT NULL,
        harga_pulsa VARCHAR NOT NULL
        )
        ''');
  }

  Future<List<UserModel>> getUser() async {
    Database db = await instance.database;
    var user = await db.query('user');
    List<UserModel> userList =
        user.isNotEmpty ? user.map((c) => UserModel.fromMap(c)).toList() : [];
    return userList;
  }

  Future<List<UserModel>> getUserbyUsername(String name) async {
    Database db = await instance.database;
    var user = await db.query('user', where: 'name = ?', whereArgs: [name]);
    List<UserModel> userList =
        user.isNotEmpty ? user.map((c) => UserModel.fromMap(c)).toList() : [];
    return userList;
  }

  Future<int> insertUser(UserModel user) async {
    final Database db = await database;
    return await db.insert('user', user.toMap());
  }

  Future<int> updateUser(UserModel user) async {
    final Database db = await database;
    return await db
        .update('user', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    final Database db = await database;
    return await db.delete('user', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertOutlet(OutletModel outlet) async {
    final Database db = await database;
    return await db.insert('outlet', outlet.toMap());
  }

  Future<int> updateOutlet(OutletModel outlet) async {
    final db = await database;
    return await db.update('outlet', outlet.toMap(),
        where: 'id = ?', whereArgs: [outlet.id]);
  }

  Future<List<OutletModel>> getOutlet() async {
    Database db = await instance.database;
    var outlet = await db.query('outlet');
    List<OutletModel> outletlist = outlet.isNotEmpty
        ? outlet.map((c) => OutletModel.fromMap(c)).toList()
        : [];
    return outletlist;
  }

  Future<int> insertKontak(KontakModel kontak) async {
    final Database db = await database;
    return await db.insert('kontak', kontak.toMap());
  }

  Future<List<KontakModel>> getKontak() async {
    Database db = await instance.database;
    var kontak = await db.query('kontak', orderBy: 'nama');
    List<KontakModel> kontakList = kontak.isNotEmpty
        ? kontak.map((c) => KontakModel.fromMap(c)).toList()
        : [];
    return kontakList;
  }

  Future<int> updateKontak(KontakModel kontak) async {
    final db = await database;
    return await db.update('kontak', kontak.toMap(),
        where: 'id = ?', whereArgs: [kontak.id]);
  }

  Future<int> deleteKontak(int id) async {
    final db = await database;
    return await db.delete('kontak', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertProduk(ProdukModel produk) async {
    final Database db = await database;
    return await db.insert('produk', produk.toMap());
  }

  Future<List<ProdukModel>> getProduk() async {
    Database db = await instance.database;
    var produk = await db.query('produk', orderBy: 'nama_produk');
    List<ProdukModel> produkList = produk.isNotEmpty
        ? produk.map((c) => ProdukModel.fromMap(c)).toList()
        : [];
    return produkList;
  }

  Future<int> updateProduk(ProdukModel produk) async {
    final db = await database;
    return await db.update('produk', produk.toMap(),
        where: 'kode_produk = ?', whereArgs: [produk.kodeProduk]);
  }

  Future<int> updateStock(UpdateStock produk) async {
    final db = await database;
    return await db.update('produk', produk.toMap(),
        where: 'kode_produk = ?', whereArgs: [produk.kodeProduk]);
  }

  Future<int> deleteProduk(int id) async {
    final db = await database;
    return await db.delete('produk', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<ProdukModel>> getProdukByKode(String kode) async {
    Database db = await instance.database;
    var produk = await db.query('produk',
        where: 'kode_produk = ?', whereArgs: [kode], orderBy: 'nama_produk');
    List<ProdukModel> produkList = produk.isNotEmpty
        ? produk.map((c) => ProdukModel.fromMap(c)).toList()
        : [];
    return produkList;
  }

  Future<List<ProdukModel>> getProdukByNama(String nama) async {
    Database db = await instance.database;
    var produk = await db.query('produk',
        where: 'nama_produk = ?', whereArgs: [nama], orderBy: 'nama_produk');
    List<ProdukModel> produkList = produk.isNotEmpty
        ? produk.map((c) => ProdukModel.fromMap(c)).toList()
        : [];
    return produkList;
  }

  Future<int> insertTransaksi(TransaksiModel transaksi) async {
    final Database db = await database;
    return await db.insert('transaksi', transaksi.toMap());
  }

  Future<List<TransaksiModel>> getTransaksi() async {
    Database db = await instance.database;
    var transaksi = await db.query('transaksi', orderBy: 'tanggal_transaksi');
    List<TransaksiModel> transaksiList = transaksi.isNotEmpty
        ? transaksi.map((c) => TransaksiModel.fromMap(c)).toList()
        : [];
    return transaksiList;
  }

  Future<List<TransaksiModel>> getTransaksiByKode(String kode) async {
    Database db = await instance.database;
    var transaksi = await db.query('transaksi',
        where: 'kode_transaksi = ?',
        whereArgs: [kode],
        orderBy: 'tanggal_transaksi');
    List<TransaksiModel> transaksiList = transaksi.isNotEmpty
        ? transaksi.map((c) => TransaksiModel.fromMap(c)).toList()
        : [];
    return transaksiList;
  }

  Future<List<TransaksiModel>> getTransaksiByKontak(int id) async {
    Database db = await instance.database;
    var transaksi = await db.query('transaksi',
        where: 'kontak_id = ?', whereArgs: [id], orderBy: 'tanggal_transaksi');
    List<TransaksiModel> transaksiList = transaksi.isNotEmpty
        ? transaksi.map((c) => TransaksiModel.fromMap(c)).toList()
        : [];
    return transaksiList;
  }

  Future<int> updateTransaksi(TransaksiModel transaksi) async {
    final db = await database;
    return await db.update('transaksi', transaksi.toMap(),
        where: 'id = ?', whereArgs: [transaksi.id]);
  }

  Future<int> deleteTransaksi(int id) async {
    final db = await database;
    return await db.delete('transaksi', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertCart(CartModel cart) async {
    final Database db = await database;
    return await db.insert('cart', cart.toMap());
  }

  Future<List<CartModel>> getCart() async {
    Database db = await instance.database;
    var cart = await db.rawQuery(
        'SELECT * FROM cart, produk WHERE cart.kode_produk = produk.kode_produk');
    List<CartModel> cartList =
        cart.isNotEmpty ? cart.map((c) => CartModel.fromMap(c)).toList() : [];
    return cartList;
  }

  Future<List<CartModel>> getCartByKode(String kode) async {
    Database db = await instance.database;
    var cart =
        await db.query('cart', where: 'kode_produk = ?', whereArgs: [kode]);
    List<CartModel> cartList =
        cart.isNotEmpty ? cart.map((c) => CartModel.fromMap(c)).toList() : [];
    return cartList;
  }

  Future<int> updateCart(CartModel cart) async {
    final db = await database;
    return await db.update('cart', cart.toMap(),
        where: 'kode_produk = ?', whereArgs: [cart.kode_produk]);
  }

  Future<int> deleteCartByKodeTransaksi(String kodeTransaksi) async {
    final db = await database;
    return await db.delete('cart',
        where: 'kode_transaksi = ?', whereArgs: [kodeTransaksi]);
  }

  Future<int> deleteCartByKodeProduk(String kodeProduk) async {
    final db = await database;
    return await db
        .delete('cart', where: 'kode_produk = ?', whereArgs: [kodeProduk]);
  }

  Future<int> insertPrinter(PrinterModel priter) async {
    final Database db = await database;
    return await db.insert('printer', priter.toMap());
  }

  Future<List<PrinterModel>> getPrinter() async {
    Database db = await instance.database;
    var printer = await db.query('printer');
    List<PrinterModel> printerList = printer.isNotEmpty
        ? printer.map((c) => PrinterModel.fromMap(c)).toList()
        : [];
    return printerList;
  }

  Future<int> updatePrinter(PrinterModel printer) async {
    final db = await database;
    return await db.update('printer', printer.toMap(),
        where: 'id = ?', whereArgs: [printer.id]);
  }

  Future<int> deletePrinter(int id) async {
    final db = await database;
    return await db.delete('printer', where: 'id = ?', whereArgs: [1]);
  }

  Future<int> insertLaporan(LaporanModel laporan) async {
    final Database db = await database;
    return await db.insert('laporan', laporan.toMap());
  }

  Future<List<LaporanModel>> getLaporanByTanggal(
      String startDate, String endDate) async {
    Database db = await instance.database;
    var laporan = await db.rawQuery(
        "SELECT * FROM laporan WHERE tanggal_transaksi BETWEEN ? AND ? GROUP BY kode_transaksi ORDER BY tanggal_transaksi ASC",
        [startDate, endDate]);
    List<LaporanModel> laporanList = laporan.isNotEmpty
        ? laporan.map((c) => LaporanModel.fromMap(c)).toList()
        : [];
    return laporanList;
  }

  Future<List<LaporanModel>> getLaporanByKode(String kode) async {
    Database db = await instance.database;
    var laporan = await db
        .query('laporan', where: 'kode_transaksi = ?', whereArgs: [kode]);
    List<LaporanModel> laporanList = laporan.isNotEmpty
        ? laporan.map((c) => LaporanModel.fromMap(c)).toList()
        : [];
    return laporanList;
  }

  Future<List<DetailLaporanModel>> getDetailLaporan(
      String kodeTransaksi) async {
    Database db = await instance.database;
    var laporan = await db.rawQuery(
        "SELECT * FROM laporan INNER JOIN produk ON laporan.kode_produk = produk.kode_produk WHERE kode_transaksi = ?",
        [kodeTransaksi]);
    List<DetailLaporanModel> laporanList = laporan.isNotEmpty
        ? laporan.map((c) => DetailLaporanModel.fromMap(c)).toList()
        : [];
    return laporanList;
  }

  Future<List<DetailLaporanModel>> getDetailLaporanByTanggal(
      String startData, endDate) async {
    Database db = await instance.database;
    var laporan = await db.rawQuery(
        "SELECT * FROM laporan INNER JOIN produk ON laporan.kode_produk = produk.kode_produk WHERE tanggal_transaksi BETWEEN ? AND ? ORDER BY tanggal_transaksi ASC",
        [startData, endDate]);
    List<DetailLaporanModel> laporanList = laporan.isNotEmpty
        ? laporan.map((c) => DetailLaporanModel.fromMap(c)).toList()
        : [];
    return laporanList;
  }

  Future<int> updateLaporan(LaporanModel laporan) async {
    final db = await database;
    return await db.update('laporan', laporan.toMap(),
        where: 'id = ?', whereArgs: [laporan.id]);
  }

  Future<int> deleteLaporan(int id) async {
    final db = await database;
    return await db.delete('laporan', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertBeban(BebanModel beban) async {
    final Database db = await database;
    return await db.insert('beban', beban.toMap());
  }

  Future<List<BebanModel>> getBeban() async {
    Database db = await instance.database;
    var beban = await db.query('beban');
    List<BebanModel> bebanList = beban.isNotEmpty
        ? beban.map((c) => BebanModel.fromMap(c)).toList()
        : [];
    return bebanList;
  }

  Future<int> updateBeban(BebanModel beban) async {
    final db = await database;
    return await db
        .update('beban', beban.toMap(), where: 'id = ?', whereArgs: [beban.id]);
  }

  Future<int> deleteBeban(int id) async {
    final db = await database;
    return await db.delete('beban', where: 'id = ?', whereArgs: [id]);
  }
}
