import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotelhub/screens/bookmark_page.dart';
import 'package:hotelhub/screens/homepage.dart';
import 'package:hotelhub/screens/profile_page.dart';

class BottNavBar extends StatelessWidget {
  const BottNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottNavBarController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.bookmark), label: 'Bookmark'),
            NavigationDestination(
                icon: Icon(Icons.account_circle), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class BottNavBarController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screens = [HomePage(), BookmarkPage(), ProfilePage()];
}
