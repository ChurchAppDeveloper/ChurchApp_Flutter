import 'package:badges/badges.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:churchapp/Screens/Announcemet/AnnouncemetList.dart';
import 'package:churchapp/Screens/Classifields/ClassiieldList.dart';
import 'package:churchapp/Screens/Confession/Confession.dart';
import 'package:churchapp/Screens/HomePage/empty_card.dart';
import 'package:churchapp/Screens/LiveStream/LiveStream.dart';
import 'package:churchapp/Screens/MassTiming/MassTiming.dart';
import 'package:churchapp/Screens/PrayerRequest/PrayerRequest.dart';
import 'package:churchapp/Screens/RestService/BannerService.dart';
import 'package:churchapp/Screens/RestService/ProfileService.dart';
import 'package:churchapp/Screens/WebViewLoad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HomeMenu {
  parishannouncement,
  livestream,
  bulletin,
  masstiming,
  prayerrequest,
  confession,
  classifields,
  readings,
  ministers,
  donate
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

  @override
  void initState() {
    super.initState();
    _fetching = true;
    ProfileService().getProfileDetails();
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
                        dotSize: 6.0,
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
          Expanded(
            // AnimationLimiter(
            child: GridView.count(
              childAspectRatio: 1.0,
              padding: EdgeInsets.fromLTRB(0, (height / 2), 0, 0),
              crossAxisCount: columnCount,
              children: List.generate(
                homelist.length,
                (int index) {
                  var homelistitem = homelist[index];
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: columnCount,
                    position: index,
                    duration: const Duration(milliseconds: 750),
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
                                ? Badge(
                                padding: EdgeInsets.all(15.0),
                                position: BadgePosition.topStart(
                                    top: 15, start: 5),
                                badgeContent: Text('99+',
                                    style: TextStyle(color: Colors.white)),
                                child: EmptyCard(
                                    imagename: homelistitem.imageName,
                                    title: homelistitem.title))
                                : EmptyCard(
                                imagename: homelistitem.imageName,
                                title: homelistitem.title)),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  pushToCubicNavigationCotroller(
      BuildContext context, HomeMenu homemenu) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (homemenu) {
      case HomeMenu.parishannouncement:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AnnouncemetList(isShowAppbar: true)),
        );
        // Navigator.of(context).push(
        //   CubePageRoute(
        //     enterPage: AnnouncemetList(isShowAppbar: true),
        //     exitPage: this.,
        //     duration: const Duration(milliseconds: 900),
        //   ),
        // );
        break;
      case HomeMenu.livestream:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LiveStream(isShowAppbar: true)),
        );
        // Navigator.push(
        //     context,
        //     PageTransition(
        //         alignment: Alignment.bottomCenter,
        //         curve: Curves.easeInOut,
        //         duration: Duration(milliseconds: 600),
        //         reverseDuration: Duration(milliseconds: 600),
        //         type: PageTransitionType.rightToLeftJoined,
        //         child: LiveStream(isShowAppbar: true),
        //         childCurrent: this));
        break;
      case HomeMenu.bulletin:
        print("asdasdad: " + prefs.getString('bulletinUrl'));
        var bulletin = WebViewLoad(
            weburl: prefs.getString('bulletinUrl'),
            isShowAppbar: true,
            pageTitle: "BULLETIN");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => bulletin),
        );
        // Navigator.push(
        //     context,
        //     PageTransition(
        //         alignment: Alignment.bottomCenter,
        //         curve: Curves.easeInOut,
        //         duration: Duration(milliseconds: 600),
        //         reverseDuration: Duration(milliseconds: 600),
        //         type: PageTransitionType.rightToLeftJoined,
        //         child: bulletin,
        //         childCurrent: this));
        break;
      case HomeMenu.masstiming:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MassTiming(isShowAppbar: true)),
        );
        // Navigator.push(
        //     context,
        //     PageTransition(
        //         alignment: Alignment.bottomCenter,
        //         curve: Curves.easeInOut,
        //         duration: Duration(milliseconds: 600),
        //         reverseDuration: Duration(milliseconds: 600),
        //         type: PageTransitionType.rightToLeftJoined,
        //         child: MassTiming(isShowAppbar: true),
        //         childCurrent: this));
        break;
      case HomeMenu.prayerrequest:
        // var bulletin = WebViewLoad(
        //     weburl: prefs.getString('prayerRequestUtl'),
        //     isShowAppbar: true,
        //     pageTitle: "PRAYER REQUEST");
        var prayerRequest = PrayerRequest(isShowAppbar: true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => prayerRequest),
        );
        // Navigator.push(
        //     context,
        //     PageTransition(
        //         alignment: Alignment.bottomCenter,
        //         curve: Curves.easeInOut,
        //         duration: Duration(milliseconds: 600),
        //         reverseDuration: Duration(milliseconds: 600),
        //         type: PageTransitionType.rightToLeftJoined,
        //         child: bulletin,
        //         childCurrent: this));
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
        // Navigator.push(
        //     context,
        //     PageTransition(
        //         alignment: Alignment.bottomCenter,
        //         curve: Curves.easeInOut,
        //         duration: Duration(milliseconds: 600),
        //         reverseDuration: Duration(milliseconds: 600),
        //         type: PageTransitionType.rightToLeftJoined,
        //         child: bulletin,
        //         childCurrent: this));
        break;
      case HomeMenu.confession:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Confession(isShowAppbar: true)),
        );

        break;
      case HomeMenu.classifields:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ClassiieldList(isShowAppbar: true)),
        );

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
      default:
    }
  }

  loadData() {
    homelist.add(HomeItem("Announcement", "image/announcement.png"));
    homelist.add(HomeItem("Livestream", "image/livestreaming.png"));
    homelist.add(HomeItem("Bulletins", "image/bulletin.png"));
    homelist.add(HomeItem("Mass Timings", "image/masstiming.png"));
    homelist.add(HomeItem("Prayer Request", "image/prayerrequest.png"));
    homelist.add(HomeItem("Conefssion", "image/confession.png"));
    homelist.add(HomeItem("CLASSIFIED", "image/classifield.png"));
    homelist.add(HomeItem("Readings", "image/reading.png"));
    homelist.add(HomeItem("School", "image/school.png"));
    homelist.add(HomeItem("Donate", "image/donate.png"));
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
