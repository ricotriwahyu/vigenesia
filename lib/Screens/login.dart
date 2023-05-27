import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:vigenesia/Models/login_model.dart';
import 'package:vigenesia/Screens/mainscreens.dart';
import 'register.dart';
// import 'dart:convert';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String nama;
  String iduser;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Future<LoginModels> postLogin(String email, String password) async {
    var dio = Dio();
    String baseurl = url;

    Map<String, dynamic> data = {
      "email": email,
      "password": password,
    };

    try {
      final response = await dio.post("$baseurl/vigenesia/api/login/",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));

      print("Respon -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        final loginModel = LoginModels.fromJson(response.data);

        return loginModel;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset('assets/img/login.png', width: 400,height: 400,fit:BoxFit.fill),  
              Text(
                "Login Area",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                "Log in dengan akun anda yang sudah didaftarkan",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: Form(
                  key: _fbKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Column(children: [
                      FormBuilderTextField(
                        name: "email",
                        controller: emailController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
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
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            await postLogin(emailController.text,
                                    passwordController.text)
                                .then(
                              (value) => {
                                if (value != null)
                                  {
                                    setState(
                                      () {
                                        nama = value.data.nama;
                                        iduser = value.data.iduser;
                                        // id_user = value.data.iduser;
                                        Navigator.pushReplacement(
                                            context,
                                            new MaterialPageRoute(
                                              builder: (context) =>
                                                  new MainScreens(
                                                nama: nama,
                                                idUser: iduser,
                                              ),
                                            ));
                                      },
                                    )
                                  }
                                else
                                  {
                                    Flushbar(
                                      message: "Check Your Email / Password",
                                      duration: Duration(seconds: 5),
                                      backgroundColor: Colors.redAccent,
                                      flushbarPosition: FlushbarPosition.TOP,
                                    ).show(context)
                                  }
                              },
                            );
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
                              "Sign In",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: 'Kamu Belum Punya akun  ? ',
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextSpan(
                              text: 'Daftar',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          new Register(),
                                    ),
                                  );
                                })
                        ]),
                      ),
                    ]),
                    
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
