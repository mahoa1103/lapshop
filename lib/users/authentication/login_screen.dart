import 'dart:convert';

import 'package:appshop/admin/login_admin.dart';
import 'package:appshop/users/authentication/signup_screen.dart';
import 'package:appshop/api_connection/api_connection.dart';
import 'package:appshop/users/fragments/dashboard_of_fagments.dart';
import 'package:appshop/users/model/user.dart';
import 'package:appshop/users/model/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget
{
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen>
{
  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  loginUserNow() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.login),
        body: {
          "user_email": emailController.text.trim(),
          "user_password": passwordController.text.trim(),
        },
      );

      if(res.statusCode == 200) // connection with api to server - success
      {
        var resBodyOfLogin = jsonDecode(res.body);

        if(resBodyOfLogin['success'] == true)
        {
          Fluttertoast.showToast(msg: "Bạn đã đăng nhập thành công.");

          User userInfo = User.fromJson(resBodyOfLogin["userData"]);

          //save userInfo
          await RememberUserPrefs.storeUserInfo(userInfo);

          Future.delayed(const Duration(milliseconds: 2000), ()
          {
            Get.to(DashboardOfFragments());
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Eamil hoặc mật khẩu bị sai, mời nhập lại.");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(e)
    {
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

                      //Login Screen header
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 285,
                        child: Image.asset(
                            "images/laptoplogo.png"
                        ),
                      ),

                      //Login Screen sign-in form
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

                                //email-password-login btn
                                Form(
                                  key: formkey,
                                  child: Column(
                                    children: [

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
                                          contentPadding:const EdgeInsets.symmetric(
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
                                              contentPadding: const EdgeInsets.symmetric(
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
                                              loginUserNow();
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(30),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 28,
                                            ),
                                            child: Text(
                                              "Đăng Nhập",
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

                                //Don't have an account btn
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Bạn chưa có tài khoản?"
                                    ),
                                    TextButton(
                                      onPressed: ()
                                      {
                                        Get.to(SignUpScreen());
                                      },
                                      child: const Text(
                                        "Đăng Ký Ngay",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const Text(
                                  "Hoặc",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),

                                //are you an Admin btn
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                        "Bạn là Admin?"
                                    ),
                                    TextButton(
                                      onPressed: ()
                                      {
                                        Get.to(AdminLoginScreen());
                                      },
                                      child: const Text(
                                        "Click Here",
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
