import 'package:bigsam_pos/models/user.dart';
import 'package:flutter/material.dart';

import '../utils/database.dart';

class UserPengguna extends StatefulWidget {
  const UserPengguna({Key? key}) : super(key: key);

  @override
  _UserPenggunaState createState() => _UserPenggunaState();
}

class _UserPenggunaState extends State<UserPengguna> {
  final _formKey = GlobalKey<FormState>();
  int? selectedId;
  TextEditingController namaUserController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User'),
        ),
        body: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.1,
                    height: MediaQuery.of(context).size.height - 110,
                    child: FutureBuilder<List<UserModel>>(
                        future: DatabaseHelper.instance.getUser(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<UserModel>> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Loading...'));
                          }

                          return ListView(
                            children: snapshot.data!.map((user) {
                              return Center(
                                child: Card(
                                  color: selectedId == user.id
                                      ? Colors.white70
                                      : Colors.white,
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Text(
                                          user.name,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        selectedId = user.id;
                                        await DatabaseHelper.instance
                                            .deleteUser(selectedId!);
                                        setState(() {});
                                      },
                                    ),
                                    onLongPress: () {
                                      setState(() {
                                        selectedId = user.id;
                                        namaUserController.text = user.name;
                                      });
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }),
                  ),
                ),
              ),
            ),
            Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.1,
                height: MediaQuery.of(context).size.height - 110,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: selectedId == null
                                ? const Text(
                                    'Tambah User',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    'Edit User',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Nama User",
                            ),
                            controller: namaUserController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Nama  Tidak Boleh Kosong';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                            obscureText: true,
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password  Tidak Boleh Kosong';
                              }
                              return null;
                            },
                          ),
                          Container(
                            color: Colors.blue,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 20.0),
                            child: TextButton(
                              child: Text(
                                selectedId == null ? "Tambah User" : "Simpan",
                                style: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    setState(() {});
                                    selectedId != null
                                        ? await DatabaseHelper.instance
                                            .updateUser(
                                            UserModel(
                                              id: selectedId,
                                              name: namaUserController.text,
                                              password: passwordController.text,
                                            ),
                                          )
                                        : await DatabaseHelper.instance
                                            .insertUser(
                                            UserModel(
                                              name: namaUserController.text,
                                              password: passwordController.text,
                                            ),
                                          );
                                    setState(() {
                                      selectedId = null;
                                      namaUserController.text = "";
                                      passwordController.text = "";
                                    });
                                  } catch (e) {
                                    setState(() {});
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
