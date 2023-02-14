import 'package:appshop/users/fragments/favorites_fagment_screen.dart';
import 'package:appshop/users/fragments/home_fagment_screen.dart';
import 'package:appshop/users/fragments/order_fragment_screen.dart';
import 'package:appshop/users/fragments/profile_fragment_screen.dart';
import 'package:appshop/users/model/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DashboardOfFragments extends StatelessWidget
{
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  final List<Widget> _fragmentScreens =
  [
    HomeFragmentScreen(),
    FavoritesFragmentScreen(),
    OrderFragmentScreen(),
    ProfileFragmentScreen(),
  ];

  final List _navigationBtnProperties =
  [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home",
    },
    {
      "active_icon": Icons.favorite,
      "non_active_icon": Icons.favorite_border,
      "label": "Favorites",
    },
    {
      "active_icon": FontAwesomeIcons.boxOpen,
      "non_active_icon": FontAwesomeIcons.box,
      "label": "Orders",
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outlined,
      "label": "Profile",
    },
  ];

  final RxInt _indexNumber = 0.obs;

  DashboardOfFragments({super.key});

  @override
  Widget build(BuildContext context)
  {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentStare)
      {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller)
      {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Obx(
                ()=> _fragmentScreens[_indexNumber.value]
            ),
          ),
          bottomNavigationBar: Obx(
              ()=> BottomNavigationBar(
                currentIndex: _indexNumber.value,
                onTap: (value)
                {
                  _indexNumber.value = value;
                },
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white24,
                items: List.generate(4, (index)
                {
                  var navBtnProperty = _navigationBtnProperties[index];
                  return BottomNavigationBarItem(
                    backgroundColor: Colors.blue,
                    icon: Icon(navBtnProperty["non_active_icon"]),
                    activeIcon: Icon(navBtnProperty["active_icon"]),
                    label: navBtnProperty["label"],
                  );
                }),
              ),
          ),
        );
      },
    );
  }
}
