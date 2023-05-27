import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:vigenesia/Models/motivasi_model.dart';
import 'package:vigenesia/Screens/edit_page.dart';
import 'package:vigenesia/Screens/login.dart';

class MainScreens extends StatefulWidget {
  final String idUser;
  final String nama;
  const MainScreens({Key key, this.nama, this.idUser}) : super(key: key);

  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  String baseurl = url;
  String id;
  var dio = Dio();

  List<MotivasiModel> ass = [];
  TextEditingController titleController = TextEditingController();

  Future<dynamic> sendMotivasi(String isi) async {
    Map<String, dynamic> body = {
      "isi_motivasi": isi,
      "iduser": widget.idUser,
    };

    try {
      Response response = await dio.post(
          "$baseurl/vigenesia/api/dev/POSTmotivasi",
          data: body,
          options: Options(contentType: Headers.formUrlEncodedContentType));

      print("Respon -> ${response.data} + ${response.statusCode}");
      return response;
    } catch (e) {
      print("Error di -> $e");
    }
  }

  List<MotivasiModel> listproduk = [];

  Future<List<MotivasiModel>> getData() async {
    var response = await dio
        .get("$baseurl/vigenesia/api/Get_motivasi?iduser=${widget.idUser}");
    print(" ${response.data}");

    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception("Failed to load");
    }
  }

  Future<dynamic> deletePost(String id) async {
    dynamic data = {
      "id": id,
    };

    try {
      Response response = await dio.delete(
          '$baseurl/vigenesia/api/dev/DELETEmotivasi',
          data: data,
          options: Options(
              contentType: Headers.formUrlEncodedContentType,
              headers: {"Content-type": "application/json"}));
      return response;
    } catch (e) {
      print("Error di -> $e");
    }
  }

  Future<List<MotivasiModel>> getData2() async {
    var response = await dio.get('$baseurl/vigenesia/api/Get_motivasi');
    print(" ${response.data}");

    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();

      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<void> _getData() async {
    setState(() {
      getData();
      listproduk.clear();
      return CircularProgressIndicator();
    });
  }

  TextEditingController isiController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
    getData2();
    _getData();
  }

  String trigger;
  String triggerUser;

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                left: 30.0,
                right: 30.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hallo ${widget.nama}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        child: Icon(Icons.logout),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new Login(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    controller: isiController,
                    name: "isi_motivasi",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        await sendMotivasi(
                          isiController.text.toString(),
                        ).then((value) => {
                              if (value != null)
                                {
                                  Flushbar(
                                    title: "Success",
                                    message: "Berhasil Submit",
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.black54,
                                    flushbarPosition: FlushbarPosition.TOP,
                                    leftBarIndicatorColor: Colors.greenAccent,
                                  ).show(context),
                                  _getData()
                                }
                            });
                        print("Sukses");
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 15.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    child: Icon(Icons.refresh),
                    onPressed: () {
                      _getData();
                    },
                  ),
                  FormBuilderRadioGroup(
                    onChanged: (value) {
                      setState(() {
                        trigger = value;
                        print("HASILNYA ---> $trigger");
                      });
                    },
                    name: "_",
                    options: ["Motivasi by All", "Motivasi by User"]
                        .map((e) => FormBuilderFieldOption(
                              value: e,
                              child: Text("$e"),
                            ))
                        .toList(),
                  ),
                  trigger == "Motivasi by All"
                      ? FutureBuilder(
                          future: getData2(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<MotivasiModel>> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                child: Column(
                                  children: [
                                    for (var item in snapshot.data)
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Motivasi yang ke ${item.id}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Card(
                                              child: ListTile(
                                                title: Text(item.isiMotivasi),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data.isEmpty) {
                              return Text("No Data");
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        )
                      : Container(),
                  trigger == "Motivasi by User"
                      ? FutureBuilder(
                          future: getData(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<MotivasiModel>> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    SizedBox(height: 20),
                                    Center(
                                      child: Text(
                                        'DAFTAR MOTIVASI',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    DataTable(
                                      columns: [
                                        DataColumn(
                                          label: Text(
                                            "ID",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Isi Motivasi",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Action",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                      rows: [
                                        for (var item in snapshot.data)
                                          DataRow(cells: [
                                            DataCell(Text(item.id)),
                                            DataCell(Text(item.isiMotivasi)),
                                            DataCell(
                                              Row(
                                                children: [
                                                  TextButton(
                                                    child: Icon(Icons.edit),
                                                    onPressed: () {
                                                      // String id;
                                                      // String isi_motivasi;

                                                      Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                EditPage(
                                                                    id: item.id,
                                                                    isiMotivasi:
                                                                        item.isiMotivasi)),
                                                      );
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Icon(Icons.delete),
                                                    onPressed: () {
                                                      deletePost(item.id)
                                                          .then((value) => {
                                                                if (value !=
                                                                    null)
                                                                  {
                                                                    Flushbar(
                                                                            title:
                                                                                "Success",
                                                                            message:
                                                                                "Berhasil Delete",
                                                                            duration:
                                                                                Duration(seconds: 2),
                                                                            backgroundColor: Colors.black54,
                                                                            flushbarPosition: FlushbarPosition.TOP,
                                                                            leftBarIndicatorColor: Colors.redAccent)
                                                                        .show(context),
                                                                  }
                                                              });
                                                      _getData();
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ]),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data.isEmpty) {
                              return Text("No Data");
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
