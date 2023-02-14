import 'dart:convert';

import 'package:appshop/api_connection/api_connection.dart';
import 'package:appshop/users/authentication/login_screen.dart';
import 'package:appshop/users/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget
{

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}



class _SignUpScreenState extends State<SignUpScreen>
{
  var formkey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  validateUserEmail() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'user_email': emailController.text.trim(),
        },
      );

      if(res.statusCode == 200) // connection with api to server - success
      {
        var resBodyOfValidateEmail = jsonDecode(res.body);

        if(resBodyOfValidateEmail['emailFound'] == true)
        {
          Fluttertoast.showToast(msg: "Email is already in someone else use. Try another email.");
        }
        else
        {
          //register & save new user record to database
          registerAndSaveUserRecord();
        }
      }
    }
    catch(e)
    {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  registerAndSaveUserRecord() async
  {
    User userModel = User(
      1,
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    try
    {
      var res = await http.post(
        Uri.parse(API.signUp),
        body: userModel.toJson(),
      );
      if(res.statusCode == 200) // connection with api to server - success
      {
        var resBodyOfSignUp = jsonDecode(res.body);

        if(resBodyOfSignUp['success'] == true)
        {
          Fluttertoast.showToast(msg: "Congratulation, you are SignUp Successfully.");

          setState(() {
            nameController.clear();
            emailController.clear();
            passwordController.clear();
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Error Occurred, Try again.");
        }
      }

    }
    catch(e)
    {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white70,
              Colors.lightBlueAccent,
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, cons)
          {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: cons.maxHeight,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    const SizedBox(height: 30,),

                    //Signup Screen header
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 285,
                      child: Image.asset(
                          "images/laptoplogo.png"
                      ),
                    ),

                    //Signup Screen sign-up form
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.all(
                            Radius.circular(60),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.white70,
                              offset: Offset(0, -3),
                            ),
                          ],
                        ),
                        child:  Padding(
                          padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                          child: Column(
                            children: [

                              //name-email-password-signup btn
                              Form(
                                key: formkey,
                                child: Column(
                                  children: [

                                    //name
                                    TextFormField(
                                      controller: nameController,
                                      validator: (val) => val == "" ? "Please write name": null,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.person,
                                          color: Colors.black,
                                        ),
                                        hintText: "name...",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),

                                    const SizedBox(height: 18,),

                                    //email
                                    TextFormField(
                                      controller: emailController,
                                      validator: (val) => val == "" ? "Please write email": null,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.email,
                                          color: Colors.black,
                                        ),
                                        hintText: "email...",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),

                                    const SizedBox(height: 18,),
                                    //password
                                    Obx(
                                          ()=> TextFormField(
                                        controller: passwordController,
                                        obscureText: isObsecure.value,
                                        validator: (val) => val == "" ? "Please write password": null,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.vpn_key_sharp,
                                            color: Colors.black,
                                          ),
                                          suffixIcon: Obx(
                                                ()=> GestureDetector(
                                              onTap: ()
                                              {
                                                isObsecure.value = !isObsecure.value;
                                              },
                                              child: Icon(
                                                isObsecure.value ? Icons.visibility_off : Icons.visibility,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          hintText: "password...",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          contentPadding:const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 18,),

                                    //Button
                                    Material(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        onTap: ()
                                        {
                                          if(formkey.currentState!.validate())
                                          {
                                            //validate the email
                                            validateUserEmail();
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 28,
                                          ),
                                          child: Text(
                                            "Đăng Ký",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16,),

                              //Already have account btn
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                      "Bạn Đã Có Tài Khoản?"
                                  ),
                                  TextButton(
                                    onPressed: ()
                                    {
                                      Get.to(LoginScreen());
                                    },
                                    child: const Text(
                                      "Đăng Nhập Ngay",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
