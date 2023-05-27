import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:vigenesia/Screens/login.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String baseurl = url;

  Future postRegister(
    String nama,
    String profesi,
    String email,
    String password,
  ) async {
    var dio = Dio();

    dynamic data = {
      "nama": nama,
      "profesi": profesi,
      "email": email,
      "password": password,
    };

    try {
      print(baseurl);
      final response = await dio.post("$baseurl/vigenesia/api/registrasi/",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));
      print("Respon -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        return response.data;
      }
      print(baseurl);
    } catch (e) {
      print("Failed to Load $e");
      // return data;
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController profesiController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/img/register.png', width: 400,height: 400,fit:BoxFit.fill),  
                  Text(
                    "Register Area",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(
                    height: 25,
                  ),
                  FormBuilderTextField(
                    name: "name",
                    controller: nameController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_box),
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(),
                        labelText: "Nama"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    name: "profesi",
                    controller: profesiController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_box),
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(),
                        labelText: "Profesi"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    name: "email",
                    controller: emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(),
                        labelText: "Email"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    obscureText: true,
                    name: "password",
                    controller: passwordController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(),
                        labelText: "Password"),
                  ),
                  
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        await postRegister(
                                nameController.text,
                                profesiController.text,
                                emailController.text,
                                passwordController.text)
                            .then((value) => {
                                  if (value != null)
                                    {
                                      Flushbar(
                                        message: "Berhasil Registrasi",
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.greenAccent,
                                        flushbarPosition: FlushbarPosition.TOP,
                                      ).show(context)
                                    }
                                  else
                                    {
                                      // print(value)
                                      Flushbar(
                                        title: "Failed",
                                        message:
                                            "Check Your Field Before Register => ${nameController.text}",
                                        duration: Duration(seconds: 5),
                                        backgroundColor: Colors.red[400],
                                        flushbarPosition: FlushbarPosition.TOP,
                                        leftBarIndicatorColor: Colors.redAccent,
                                      ).show(context)
                                    }
                                });
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
                          "Daftar",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Kamu Sudah Punya akun  ? ',
                        style: TextStyle(color: Colors.black54),
                      ),
                      TextSpan(
                          text: 'Login',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new Login(),
                                ),
                              );
                            })
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
