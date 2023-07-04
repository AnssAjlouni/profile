import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:seechat/Chats/ChatMessages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Config/Config.dart';
import 'EditAccountScreen.dart';
import 'TopBarBack.dart';

class ProfileScreen extends StatefulWidget {
  String user_id;

  ProfileScreen({Key? key, required this.user_id}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  bool has_story = true;
  final more_controller = MoreController();
  String user_image =
      "https://seechat.s3.eu-west-2.amazonaws.com/profiles/default.png";
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    getProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            body: Container(
                child: SafeArea(
                    child: Stack(children: [
          TopBarBack(),
          Container(
              margin: EdgeInsets.only(top: 60),
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.blue,
                                  width: has_story == true ? 3 : 0),
                              borderRadius: BorderRadius.circular(200)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(200),
                              child: Obx(() => Image(
                                    image: NetworkImage(
                                        more_controller.image.value.toString()),
                                    height: 50,
                                    fit: BoxFit.cover,
                                    width: 50,
                                  ))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  more_controller.name.value,
                                  style: TextStyle(
                                      fontFamily: "tajawal",
                                      color: Color(0xff2c8ace),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                more_controller.verification.value == "true"
                                    ? Image(
                                        image: AssetImage(
                                            "assets/icons/verifiyed.png"),
                                        height: 20,
                                      )
                                    : SizedBox()
                              ],
                            )),
                        Obx(() => Text(
                              more_controller.bio.value,
                              style: TextStyle(
                                  fontFamily: "tajawal", fontSize: 18),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => Visibility(
                                visible: !more_controller.my_profile.value,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(
                                        ChatMessages(user_id: widget.user_id));
                                  },
                                  child: Container(
                                    height: 35,
                                    padding:
                                        EdgeInsets.only(right: 15, left: 15),
                                    decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        border: Border.all(
                                            width: 1, color: Color(0xff2c8ace)),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "رسالة",
                                          style: TextStyle(
                                              color: Color(0xff2c8ace),
                                              fontFamily: "tajawal",
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Image(
                                            image: AssetImage(
                                                "assets/icons/message.png"),
                                            color: Color(0xff2c8ace),
                                            width: 25),
                                      ],
                                    ),
                                  ),
                                ))),
                            Obx(() => Visibility(
                                visible: more_controller.my_profile.value,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(EditAccountScreen());
                                  },
                                  child: Container(
                                    height: 35,
                                    padding:
                                        EdgeInsets.only(right: 15, left: 15),
                                    decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        border: Border.all(
                                            width: 1, color: Color(0xff2c8ace)),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "تعديل",
                                          style: TextStyle(
                                              color: Color(0xff2c8ace),
                                              fontFamily: "tajawal",
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Image(
                                            image: AssetImage(
                                                "assets/icons/edit_account.png"),
                                            color: Color(0xff2c8ace),
                                            width: 25),
                                      ],
                                    ),
                                  ),
                                ))),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                send_follow_unfollow();
                              },
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.only(right: 15, left: 15),
                                decoration: BoxDecoration(
                                    color: Color(0xff2c8ace),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "متابعة",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "tajawal",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.only(right: 7, left: 7),
                              decoration: BoxDecoration(
                                  color: Color(0xfff1f1f1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Image(
                                  image: AssetImage("assets/icons/youtube.png"),
                                  width: 35,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.only(right: 7, left: 7),
                              decoration: BoxDecoration(
                                  color: Color(0xfff1f1f1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Image(
                                  image:
                                      AssetImage("assets/icons/snapchat.png"),
                                  width: 35,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.only(right: 7, left: 7),
                              decoration: BoxDecoration(
                                  color: Color(0xfff1f1f1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Image(
                                  image: AssetImage("assets/icons/tiktok.png"),
                                  width: 25,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.only(right: 7, left: 7),
                              decoration: BoxDecoration(
                                  color: Color(0xfff1f1f1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Image(
                                  image:
                                      AssetImage("assets/icons/intagram.png"),
                                  width: 30,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.only(right: 7, left: 7),
                              decoration: BoxDecoration(
                                  color: Color(0xfff1f1f1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Image(
                                  image:
                                      AssetImage("assets/icons/facebook.png"),
                                  height: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Color(0xffecebeb),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(
                                      "0",
                                      style: TextStyle(
                                          fontFamily: "tajawal",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text("منشور",
                                        style:
                                            TextStyle(fontFamily: "tajawal")),
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Obx(() => Text(
                                          more_controller.followers_count.value,
                                          style: TextStyle(
                                              fontFamily: "tajawal",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )),
                                    Text("متابع",
                                        style:
                                            TextStyle(fontFamily: "tajawal")),
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Obx(() => Text(
                                          more_controller
                                              .followings_count.value,
                                          style: TextStyle(
                                              fontFamily: "tajawal",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )),
                                    Text("يتابع",
                                        style:
                                            TextStyle(fontFamily: "tajawal")),
                                  ],
                                )),
                          ],
                        ),
                        Flexible(
                            child: Container(
                                width: double.infinity,
                                height: 322,
                                color: Color(0xfff3f3f3),
                                child: DefaultTabController(
                                  length: 6,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 60,
                                        color: Color(0xfff3f3f3),
                                        child: TabBar(
                                          indicatorColor: Color(0xff2c8ace),
                                          unselectedLabelColor: Colors.red,
                                          labelColor: Colors.red,
                                          tabs: [
                                            Tab(
                                              icon: Image.asset(
                                                'assets/icons/all.png',
                                                color: Color(0xff808080),
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                            Tab(
                                              icon: Image.asset(
                                                'assets/icons/photo.png',
                                                color: Color(0xff808080),
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                            Tab(
                                              icon: Image.asset(
                                                'assets/icons/texts.png',
                                                color: Color(0xff808080),
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                            Tab(
                                              icon: Image.asset(
                                                'assets/icons/videos.png',
                                                color: Color(0xff808080),
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                            Tab(
                                              icon: Image.asset(
                                                'assets/icons/reels.png',
                                                color: Color(0xff808080),
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                            Tab(
                                              icon: Image.asset(
                                                'assets/icons/favorite.png',
                                                color: Color(0xff808080),
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(child: Container(
                                        child: TabBarView(
                                          children: [
                                            Container(color: Colors.yellow),
                                            // content for 'all' tab
                                            Container(color: Colors.blue),
                                            // content for 'photo' tab
                                            Container(color: Colors.green),
                                            // content for 'texts' tab
                                            Container(color: Colors.red),
                                            // content for 'videos' tab
                                            Container(color: Colors.orange),
                                            // content for 'reels' tab
                                            Container(color: Colors.purple),
                                            // content for 'favorite' tab
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                ))),
                      ],
                    ),
                  )))
        ])))));
  }

  send_follow_unfollow() async {
    print("user_id");
    print(widget.user_id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("access_token");
    print(await prefs.getString("access_token").toString());
    final url = Config.URL_FOLLOW_UNFOLLOW;
    final response = await http.post(Uri.parse(url), body: {
      'id': widget.user_id,
    }, headers: {
      'Authorization': 'Bearer ${prefs.getString("access_token").toString()}',
    });
    var res = jsonDecode(response.body);
    print("message response");
    print(res);
    if (response.statusCode == 200) {
      // var data = "true";
      if (res["status"] == true) {
        if (res["action"] == "added") {
          Config.super_dialog("تم متابعة المستخدم", "إغلاق", context, () {
            Navigator.pop(context);
          });
        } else if (res["action"] == "removed") {
          Config.super_dialog("تم إلغاء متابعة المستخدم", "إغلاق", context, () {
            Navigator.pop(context);
          });
        }
      }
      // setState(() {});
    } else {
      print('Error while uploading image: ${response.reasonPhrase}');
    }
  }

  getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("access_token");
    print(await prefs.getString("access_token").toString());

    // print(prefs.getString("access_token"));
    try {
      var response = await http.get(
          Uri.parse(Config.URL_PROFILE + widget.user_id + "/show"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${prefs.getString("access_token").toString()}',
          });
      var res = jsonDecode(response.body);
      String name = "",
          bio = "",
          image = "",
          followers_count = "",
          followings_count = "";
      bool has_story = false;
      bool my_profile = false;
      String verification = "false";
      print("my_profile");
      print(res);
      if (res["user"].containsKey('first_name') &&
          res["user"].containsKey('last_name')) {
        name = res["user"]["first_name"] + " " + res["user"]["last_name"];
      }
      if (res["user"].containsKey('profile_picture_url')) {
        image = res["user"]["profile_picture_url"]["small"];
      }
      if (res["user"].containsKey('bio')) {
        bio = res["user"]["bio"];
      } else {
        bio = "";
      }
      if (res["user"].containsKey('has_story')) {
        has_story = res["user"]["has_story"];
      } else {
        has_story = false;
      }
      if (res["user"].containsKey('my_profile')) {
        my_profile = res["user"]["my_profile"];
      } else {
        my_profile = false;
      }
      if (res["user"].containsKey('verification')) {
        verification = res["user"]["verification"];
      } else {
        verification = "false";
      }
      if (res["user"].containsKey('followers_count')) {
        followers_count = res["user"]["followers_count"].toString();
      } else {
        followers_count = "0";
      }
      if (res["user"].containsKey('followings_count')) {
        followings_count = res["user"]["followings_count"].toString();
      } else {
        followings_count = "0";
      }
      more_controller.update_profile(name, image, bio, has_story, verification,
          followers_count, followings_count, my_profile);
      return res;
      if (res.containsKey('message')) {
        if (res['message'] == "Unauthenticated") {
          Config.super_dialog("إنتهت صلاحية الجلسة", "تسجيل الدخول", context,
              () {
            Navigator.pop(context);
          });
          // prefs.setBool("login", false);
          // prefs.clear();
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => PhoneScreen()));
        }
      }
      return res;
    } catch (error) {
      print(error);
      return [];
    }
    // res.sort((a, b) => a['name'].compareTo(b['name']));
  }
}

class MoreController extends GetxController {
  var image =
      'https://seechat.s3.eu-west-2.amazonaws.com/profiles/default.png'.obs;
  var name = ''.obs;
  var bio = ''.obs;
  var has_story = false.obs;
  var verification = "false".obs;
  var followers_count = "0".obs;
  var followings_count = "0".obs;
  var my_profile = false.obs;

  void update_profile(
      String name,
      String image,
      String bio,
      bool has_story,
      String verification,
      String followers_count,
      String followings_count,
      bool my_profile) {
    this.image.value = image;
    this.name.value = name;
    this.bio.value = bio;
    this.has_story.value = has_story;
    this.followers_count.value = followers_count;
    this.followings_count.value = followings_count;
    this.verification.value = verification;
    this.my_profile.value = my_profile;
  }
}
