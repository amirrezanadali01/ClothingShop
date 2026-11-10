import 'dart:math' as math;

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shopclothing/product_details_screen.dart';

import 'product_widgets.dart';

class ProductItem {
  ProductItem({
    required this.isActive,
    required this.image,
    required this.profile,
    required this.title,
    required this.text,
    required this.price,
    this.tag1 = 'Larg',
    this.tag2 = 'Grey Omber',
    this.offset = 0.0,
  });

  final bool isActive;
  final String image;
  final String profile;
  final String title;
  final String text;
  final String price;
  final String tag1;
  final String tag2;
  double offset;
}

class ClothingShopScreen extends StatefulWidget {
  const ClothingShopScreen({Key? key}) : super(key: key);

  @override
  State<ClothingShopScreen> createState() => _ShopChoiceState();
}

class _ShopChoiceState extends State<ClothingShopScreen>
    with SingleTickerProviderStateMixin {
  static const double _turnEnd = 0.08916669492368346;
  static const double _offsetStep = 0.04100;
  static const double _offsetThreshold = 0.187;
  static const double _maxContentWidth = 520; // tablet and web
  static const double _cardScale = 0.9; // Slider size (1.0 = original size)
  final List<ProductItem> _items = [
    ProductItem(
      isActive: false,
      image: 'assets/images/cloth4.png',
      profile: 'assets/images/b3.jpg',
      title: 'Whiting Overshirt Navy1',
      text: 'Has been designed with versatility in mind, easy to ',
      price: '13',
    ),
    ProductItem(
      isActive: true,
      image: 'assets/images/cloth1.png',
      profile: 'assets/images/b5.jpg',
      title: 'Whiting Overshirt Navy',
      text:
          'Has been designed with versatility in mind, easy to throw on over a...',
      price: '120',
    ),
    ProductItem(
      isActive: false,
      image: 'assets/images/skyit.jpg',
      profile: 'assets/images/g4.jpg',
      title: 'Atomic Ski boots',
      text:
          'Great boots for skiing) Used it once. Too small for me. No scratches or...',
      price: '32',
    ),
    ProductItem(
      isActive: true,
      image: 'assets/images/bag.jpg',
      profile: 'assets/images/b3.jpg',
      title: 'Horsebit Shoulder Bag #1955',
      text:
          "Hey guys!!! Brand New bag, boght it for my mom, but she didn't like it...",
      price: '280',
    ),
  ];

  final List<Map<String, dynamic>> _stories = const [
    {'image': 'assets/images/g1.jpg', 'active': true, 'name': 'Your Story'},
    {'image': 'assets/images/b2.jpg', 'active': false, 'name': 'mike_03'},
    {'image': 'assets/images/g3.jpg', 'active': false, 'name': 'leyatrast78'},
    {'image': 'assets/images/b1.jpg', 'active': false, 'name': 'amirreza'},
  ];

  late final AnimationController _animController;
  late final Animation<double> _turn1;
  late final Animation<double> _turn2;
  late final Animation<double> _blur1;
  late final Animation<double> _blur2;
  late final PageController _pageController;

  late int _nowPage;
  bool _countScroll = true;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _turn1 = Tween<double>(begin: 0.0, end: _turnEnd).animate(_animController);
    _turn2 = Tween<double>(begin: _turnEnd, end: 0.0).animate(_animController);
    _blur1 = Tween<double>(begin: 0, end: 5).animate(_animController);
    _blur2 = Tween<double>(begin: 5, end: 0).animate(_animController);

    _nowPage = _items.length - 1;
    _pageController = PageController()..addListener(_onPageScroll);
  }

  void _onPageScroll() {
    if (!_pageController.hasClients) return;

    setState(() {
      if (_countScroll) {
        if (_items[_nowPage].isActive) {
          _animController.forward();
        } else {
          _animController.reverse();
        }
        _items[_nowPage].offset += _offsetStep;
      }
      _countScroll = true;

      final page = _pageController.page ?? 0;
      if (page >= 1.0) {
        _nowPage--;
        _countScroll = false;

        // Restart from the beginning when all cards are swiped (prevent crashes)
        if (_nowPage < 0) {
          for (final item in _items) {
            item.offset = 0;
          }
          _nowPage = _items.length - 1;
        }
        _pageController.jumpTo(0);
      }
    });
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_onPageScroll)
      ..dispose();
    _animController.dispose();
    super.dispose();
  }

  void _openDetails() {
    final item = _items[_nowPage.clamp(0, _items.length - 1)];
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        pageBuilder: (_, __, ___) => ProductDetailsScreen(
          image: item.image,
          text: item.text,
          name: 'mike',
          price: item.price,
          profile: item.profile,
          tag1: item.tag1,
          tag2: item.tag2,
          title: item.title,
        ),
      ),
    );
  }

  double _slideX(int i) {
    final item = _items[i];
    if (_nowPage == i) return -item.offset;
    return item.offset > _offsetThreshold ? -1.2 : 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = math.min(size.width, _maxContentWidth);

    // Scale based on screen width (375 = reference design width)
    final scale = (width / 375).clamp(0.8, 1.3);
    final fabSize = 75.0 * scale;
    final navIcon = 32.0 * scale;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: fabSize,
        height: fabSize,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(navIcon, fabSize, scale),
      appBar: _buildAppBar(scale),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.025),
                  _buildStories(width),
                  // Spacing between stories and slider (smaller value = slider moves up)
                  SizedBox(height: (size.height * 0.025).clamp(10.0, 25.0)),
                  Align(
                    alignment: Alignment.topCenter,
                    heightFactor: _cardScale,
                    child: Transform.scale(
                      scale: _cardScale,
                      alignment: Alignment.topCenter,
                      child: _buildCards(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// ---------------- Sections ----------------

  PreferredSizeWidget _buildAppBar(double scale) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 185 * scale),
        child: Container(
          height: 50 * scale,
          padding: EdgeInsets.symmetric(horizontal: 18 * scale),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Read news',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 14 * scale),
                ),
              ),
              Icon(
                EvaIcons.bookOpenOutline,
                color: Colors.black,
                size: 28 * scale,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          width: 60 * scale,
          height: 40 * scale,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Icon(
            EvaIcons.messageCircleOutline,
            color: Colors.black,
            size: 36 * scale,
          ),
        ),
      ],
    );
  }

  Widget _buildStories(double width) {
    // Enable horizontal scrolling on narrow screens to prevent overflow
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: width),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (final s in _stories)
              StoriesUser(
                image: s['image'] as String,
                isActive: s['active'] as bool,
                name: s['name'] as String,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCards() {
    return Stack(
      children: [
        for (var i = 0; i < _items.length; i++)
          SlideTransition(
            position: AlwaysStoppedAnimation(Offset(_slideX(i), 0)),
            child: InfoProduct(
              blur1: _blur1,
              blur2: _blur2,
              tun1: _turn1,
              tun2: _turn2,
              title: _items[i].title,
              text: _items[i].text,
              price: _items[i].price,
              profile: _items[i].profile,
              image: _items[i].image,
              isActive: _items[i].isActive,
              tag1: _items[i].tag1,
              tag2: _items[i].tag2,
            ),
          ),
        Positioned.fill(
          child: PageView.builder(
            itemCount: _items.length,
            controller: _pageController,
            itemBuilder: (_, __) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _openDetails,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(double iconSize, double fabSize, double scale) {
    Widget navButton(IconData icon) => IconButton(
          iconSize: iconSize,
          onPressed: null,
          icon: Icon(icon),
        );

    return BottomAppBar(
      notchMargin: 9,
      height: 90 * scale.clamp(0.9, 1.1),
      shape: const CircularNotchedRectangle(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navButton(Icons.local_fire_department_outlined),
                navButton(EvaIcons.search),
              ],
            ),
          ),
          SizedBox(width: fabSize),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navButton(EvaIcons.homeOutline),
                navButton(EvaIcons.shoppingBagOutline),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
