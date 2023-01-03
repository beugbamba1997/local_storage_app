import 'package:local_storage_app/data/sembast_db_codec.dart';
import 'package:local_storage_app/model/password.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:async';
import 'package:path/path.dart';

class SembastDB {
  DatabaseFactory dbFactory = databaseFactoryIo;
  late Database _db;
  final store = intMapStoreFactory
      .store('passwords'); //magazin pour le stockage de la base nosql
  var codec = getEncryptSembastCodec(password: 'PassWord');
  static final SembastDB _singleton = SembastDB._internal();

  //constructeur private
  SembastDB._internal() {}
  //fabrication

  factory SembastDB() {
    return _singleton;
  }

  //init
  Future<Database> init() async {
    _db = await _openDB();
    return _db;
  }

  //open db
  Future _openDB() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docsDir.path, 'pass.db');
    final db = await dbFactory.openDatabase(dbPath , codec: codec);
    return db;
  }

  //ajout

  Future<int> addPasswword(Password password) async {
    int id = await store.add(_db, password.toMap());
    print(id);
    return id;
  }

  //select * password

  Future getPasswords() async {
    await init();
    final finder = Finder(sortOrders: [SortOrder('name')]);
    final snapshot = await store.find(_db, finder: finder);

    return snapshot.map((e) {
      final pwd = Password.fromMap(e.value);
      pwd.id = e.key;
      return pwd;
    }).toList();
  }

  //modifier
  Future updatePassword(Password pwd) async {
    final finder = Finder(filter: Filter.byKey(pwd.id));
    await store.update(_db, pwd.toMap(), finder: finder);
  }

  //delere
  Future deletePassword(Password pwd) async {
    final finder = Finder(filter: Filter.byKey(pwd.id));
    await store.delete(_db, finder: finder);
  }

  //delete All
  Future deleteAll() async {
    await store.delete(_db);
  }
}
