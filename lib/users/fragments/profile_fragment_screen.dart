import 'package:appshop/users/authentication/login_screen.dart';
import 'package:appshop/users/model/userPreferences/current_user.dart';
import 'package:appshop/users/model/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileFragmentScreen extends StatelessWidget
{
  final CurrentUser _currentUser = Get.put(CurrentUser());

  signOutUser() async
  {
    var resultResponse = await Get.dialog(
       AlertDialog(
        backgroundColor: Colors.grey,
        title: const Text(
          "Đăng Xuất",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Bạn có chắc là?\nBạn muốn đăng xuất khỏi ứng dụng?",
        ),
        actions: [
          TextButton(
            onPressed: ()
            {
              Get.back();
            },
            child: const Text(
              "Không",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: ()
            {
              Get.back(result: "loggedOut");
            },
            child: const Text(
              "Có",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );

    if(resultResponse == "loggedOut")
    {
      //delete the user data from phone local storage
      RememberUserPrefs.removeUserInfo().then((value)
      {
        Get.off(LoginScreen());
      });
    }
  }

  Widget userInfoItemProfile(IconData iconData, String userData)
  {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 16,),
          Text(
            userData,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white70,
            Colors.lightBlueAccent,
          ],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(32),
        children: [

          Center(
            child: Image.asset(
              "images/man.png",
              width: 240,
            ),
          ),

          const SizedBox(height: 20,),

          userInfoItemProfile(Icons.person, _currentUser.user.user_name),

          const SizedBox(height: 20,),

          userInfoItemProfile(Icons.email, _currentUser.user.user_email),

          const SizedBox(height: 20,),

          Center(
            child: Material(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: ()
                {
                  signOutUser();
                },
                borderRadius: BorderRadius.circular(32),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  child: Text(
                    "Đăng Xuất",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
