import 'package:badges/badges.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:churchapp/Screens/Classifields/ClassifiedList.dart';
import 'package:churchapp/Screens/Confession/Confession.dart';
import 'package:churchapp/Screens/HomePage/empty_card.dart';
import 'package:churchapp/Screens/MassTiming/MassTiming.dart';
import 'package:churchapp/Screens/PrayerRequest/PrayerRequest.dart';
import 'package:churchapp/Screens/RestService/BannerService.dart';
import 'package:churchapp/Screens/WebViewLoad.dart';
import 'package:churchapp/api/announcement_api.dart';
import 'package:churchapp/model_response/announcement_count_response.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/common_fun.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HomeMenu {
  parishannouncement,
  livestream,
  bulletin,
  masstiming,
  prayerrequest,
  donate,
  confession,
  classifieds,
  readings,
  ministers,
  school,
  contactus,
  aboutus,
  logout
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int columnCount = 2;
  var homelist = [];
  var bannerImages = List<NetworkImage>();
  var reloadBannerImages = List<NetworkImage>();
  var menuposition = HomeMenu.values[0];
  bool _fetching;
  AnimationController controller;
  Animation<double> animation;
  int bannerindex = 0;
  Future apiAnnouncementCount;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 16) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  @override
  void initState() {
    super.initState();
    _fetching = true;
    // ProfileService().getProfileDetails();
    firebaseSetup(_firebaseMessaging);
    _firebaseMessaging.getToken().then((String token) {
      print("token $token");
    });
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);

    animation.addStatusListener((status) {
      setState(() {
        bannerindex = bannerindex + 1;
        if (bannerindex > bannerImages.length - 1) {
          bannerindex = 0;
        }
        reloadBannerImages.clear();
        reloadBannerImages.add(bannerImages[bannerindex]);
      });
      if (status == AnimationStatus.completed) {
        print("completed");
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        print("forward");
        controller.forward();
      }
    });

    loadData();
    apiAnnouncementCount = getAnnouncementCountAPI();
    BannerService.getBanners().then((banners) {
      var localBannerImages = List<NetworkImage>();
      for (var i = 0; i < banners.length; i++) {
        localBannerImages.add(NetworkImage(banners[i].imageName));
        // localBannerImages.add(Image.network(banners[i].imageName));
      }
      setState(() {
        bannerImages = localBannerImages;
        reloadBannerImages.add(bannerImages[bannerindex]);
        _fetching = false;
        controller.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 245, 246, 250), //Color.fromARGB(255, 219, 69, 71)
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 219, 69, 71),
          ),
          Container(
            child: Transform.scale(
              scale: 1.5,
              child: Image.asset(
                "image/background.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          ClipPath(
            child: (_fetching)
                ? Container(
                    child: Center(
                      child: Loading(
                        indicator: BallPulseIndicator(),
                        size: 100.0,
                        color: Colors.red,
                      ),
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: FadeTransition(
                      opacity: animation,
                      child: Carousel(
                        boxFit: BoxFit.cover,
                        autoplay: true,
                        animationCurve: Curves.decelerate,
                        animationDuration: Duration(milliseconds: 500),
                        dotSize: 4.0,
                        dotIncreasedColor: Colors.green,
                        dotBgColor: Colors.transparent,
                        dotPosition: DotPosition.topRight,
                        dotVerticalPadding: 10.0,
                        showIndicator: false,
                        indicatorBgPadding: 7.0,
                        images: reloadBannerImages,
                      ),
                    ),
                  ),
            clipper: BottomWaveClipper(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 48),
              child: Text("Good ${greeting()}",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )),
            ),
          ),
          GridView.count(
            childAspectRatio: 1.0,
            padding: EdgeInsets.fromLTRB(0, (height / 2), 0, 0),
            crossAxisCount: columnCount,
            physics: BouncingScrollPhysics(),
            children: List.generate(
              homelist.length,
              (int index) {
                var homelistitem = homelist[index];
                return AnimationConfiguration.staggeredGrid(
                  columnCount: columnCount,
                  position: index,
                  duration: const Duration(milliseconds: 400),
                  child: ScaleAnimation(
                    scale: 0.5,
                    child: FadeInAnimation(
                      child: GestureDetector(
                          onTap: () async {
                            menuposition = HomeMenu.values[index];
                            pushToCubicNavigationCotroller(
                                context, menuposition);
                          },
                          child: (index == 0)
                              ? FutureBuilder<AnnouncementCountResponse>(
                                  future: apiAnnouncementCount,
                                  builder: (context, projectSnap) {
                                    if (projectSnap.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else if (projectSnap.connectionState ==
                                        ConnectionState.done) {
                                      return (projectSnap.data.content != 0)
                                          ? Badge(
                                              padding: EdgeInsets.all(15.0),
                                              position: BadgePosition.topStart(
                                                  top: 15, start: 15),
                                              badgeContent: Text(
                                                  projectSnap.data.content
                                                      .toString(),
                                                  textAlign: TextAlign.start,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                              child: EmptyCard(
                                                  imagename:
                                                      homelistitem.imageName,
                                                  title: homelistitem.title))
                                          : Container();
                                    } else {
                                      return Container();
                                    }
                                  })
                              : EmptyCard(
                                  imagename: homelistitem.imageName,
                                  title: homelistitem.title)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  pushToCubicNavigationCotroller(
      BuildContext context, HomeMenu homemenu) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (homemenu) {
      case HomeMenu.parishannouncement:
        Get.toNamed("/announcementList", arguments: true);
        break;
      case HomeMenu.livestream:
        Get.toNamed("/liveStream", arguments: true);
        break;
      case HomeMenu.bulletin:
        var bulletin = WebViewLoad(
            weburl: prefs.getString('bulletinUrl'),
            isShowAppbar: true,
            pageTitle: "BULLETIN");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => bulletin),
        );
        break;
      case HomeMenu.masstiming:
        Get.toNamed("/mass", arguments: true);
        break;
      case HomeMenu.prayerrequest:
        Get.toNamed("/prayerRequest", arguments: true);
        break;
      case HomeMenu.donate:
        var bulletin = WebViewLoad(
            weburl: prefs.getString('donateUrl'),
            isShowAppbar: true,
            pageTitle: "DONATE");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => bulletin),
        );
        break;
      case HomeMenu.confession:
        Get.toNamed("/prayerRequest", arguments: true);
        break;
      case HomeMenu.classifieds:
        Get.toNamed("/classifiedList", arguments: true);
        break;
      case HomeMenu.readings:
        var bulletin = WebViewLoad(
            weburl: prefs.getString('onlieReadingUrl'),
            isShowAppbar: true,
            pageTitle: "ONLINE READINGS");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => bulletin),
        );

        break;
      case HomeMenu.ministers:
        var bulletin = WebViewLoad(
            weburl: prefs.getString('ministersUrl'),
            isShowAppbar: true,
            pageTitle: "MINISTERS");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => bulletin),
        );

        break;
      case HomeMenu.school:
        var bulletin = WebViewLoad(
            weburl: prefs.getString('schoolUrl'),
            isShowAppbar: true,
            pageTitle: "School");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => bulletin),
        );

        break;
      case HomeMenu.contactus:
        Get.toNamed("/contact");
        break;
      case HomeMenu.aboutus:
        var bulletin = WebViewLoad(
            weburl: prefs.getString('aboutUs'),
            isShowAppbar: true,
            pageTitle: "About us");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => bulletin),
        );
        break;
      case HomeMenu.logout:
        Get.dialog(
          AlertDialog(
              elevation: 6.0,
              title: Text(
                logout,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    logoutDesc,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.red,
                            onSurface: Colors.grey,
                          ),
                          child: Text(
                            "No",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            onSurface: Colors.grey,
                          ),
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0),
                          ),
                          onPressed: () {
                            SharedPref().setStringPref(SharedPref().token, "");
                            Get.offAndToNamed("/login");
                          },
                        )
                      ],
                    ),
                  ),
                ],
              )),
        );
        break;
      default:
    }
  }

  loadData() {
    homelist.add(HomeItem("Announcement", "image/megaphone.svg"));
    homelist.add(HomeItem("Livestream", "image/live.svg"));
    homelist.add(HomeItem("Bulletins", "image/news.svg"));
    homelist.add(HomeItem("Mass Timings", "image/candle_light.svg"));
    homelist.add(HomeItem("Prayer Request", "image/christianity.svg"));
    homelist.add(HomeItem("Donate", "image/donation.svg"));
    homelist.add(HomeItem("Confession", "image/jesus.svg"));
    homelist.add(HomeItem("Classified", "image/handshake.svg"));
    homelist.add(HomeItem("Readings", "image/bible.svg"));
    homelist.add(HomeItem("Ministers", "image/priest.svg"));
    homelist.add(HomeItem("School", "image/church.svg"));
    homelist.add(HomeItem("Contact Us", "image/email.svg"));
    homelist.add(HomeItem("About Us", "image/group.svg"));
    homelist.add(HomeItem("Logout", "image/logout.svg"));
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  void firebaseSetup(FirebaseMessaging _firebaseMessaging) async {
    await FirebaseMessaging.instance.subscribeToTopic('barnabas');
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher'); // <- default icon name is @mipmap/ic_launcher
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: false,
      requestAlertPermission: true,
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'barnabas_channel', // id
          'New Announcement Notifications', // title
          'New Announcement is arrived.', // description
          importance: Importance.max,
          enableLights: true,
          enableVibration: true,
          playSound: true,
          showBadge: true);
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      // RemoteMessage initialMessage =
      //     await FirebaseMessaging.instance.getInitialMessage();

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  icon: android?.smallIcon,
                  playSound: true,
                  enableVibration: true,
                  enableLights: true,
                  autoCancel: true,
                  category: "New Announcement",
                  channelShowBadge: true,
                  visibility: NotificationVisibility.public,
                  ticker: "New Announcement",
                  importance: Importance.max,
                  showWhen: true,
                  priority: Priority.max,

                  // other properties...
                ),
              ));
        }
      });
      // if (initialMessage?.data['type'] == 'task') {
      //   /* Navigator.pushNamed(context, '/chat',
      //       arguments: ChatArguments(initialMessage));*/
      // }
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      snackBarAlert(error, "Notification Permission is denied",
          Icon(Icons.error_outline), errorColor, whiteColor);
    }
  }
}

class HomeItem {
  final String title;
  final String imageName;

  HomeItem(this.title, this.imageName);
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
