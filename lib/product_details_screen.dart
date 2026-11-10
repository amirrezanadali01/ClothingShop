import 'dart:math' as math;

import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
    required this.profile,
    required this.tag1,
    required this.tag2,
    required this.text,
    required this.title,
  }) : super(key: key);

  final String profile;
  final String name;
  final String image;
  final String title;
  final String price;
  final String tag1;
  final String tag2;
  final String text;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  // ---- Constants ----
  static const double _maxContentWidth = 520; // برای تبلت و وب
  static const double _handlePad = 7;
  static const int _maxDigits = 7;
  static const String _description =
      'Has been designed with versatility in mind, easy to throw on over a '
      't-shirt and jeans, layer under a coat, or wear buttoned up as a shirt.';

  // ---- Animations ----
  late final AnimationController _anim;
  late final AnimationController _menuAnim;

  late final Animation<Offset> _profileSlide;
  late final Animation<Offset> _titleSlide;
  late final Animation<Offset> _leadingSlide;
  late final Animation<double> _fade;
  late final Animation<Offset> _item1;
  late final Animation<Offset> _item2;
  late final Animation<Offset> _item3;
  late final Animation<Offset> _item4;
  late final Animation<Offset> _timeSlide;
  late final Animation<Offset> _likeSlide;
  late final Animation<Offset> _textSlide;
  late final Animation<Offset> _buySlide;
  late final Animation<Offset> _menuOfferSlide;
  late final Animation<Offset> _menuPriceSlide;
  late final Animation<double> _menuFade;

  // ---- state ----
  bool _ready = false; // Reveal the box behind the main image
  bool _menuOpen = false;
  bool _dragging = false;
  double _dragDy = 0;
  double _handleX = _handlePad;
  String _number = '';

  // Scale based on screen width (set in build)
  double _s = 1;

  Animation<Offset> _slide(Offset begin, AnimationController c) =>
      Tween<Offset>(begin: begin, end: Offset.zero).animate(c);

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _menuAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    _profileSlide = _slide(const Offset(1, 0), _anim);
    _titleSlide = _slide(const Offset(0, -2), _anim);
    _leadingSlide = _slide(const Offset(-1, 0), _anim);
    _fade = Tween<double>(begin: 0, end: 1).animate(_anim);
    _item1 = _slide(const Offset(-1, 0), _anim);
    _item2 = _slide(const Offset(-1.5, 0), _anim);
    _item3 = _slide(const Offset(-2, 0), _anim);
    _item4 = _slide(const Offset(-2.5, 0), _anim);
    _timeSlide = _slide(const Offset(-0.5, 0), _anim);
    _likeSlide = _slide(const Offset(0.5, 0), _anim);
    _textSlide = _slide(const Offset(0, 0.2), _anim);
    _buySlide = _slide(const Offset(0.1, 0), _anim);
    _menuOfferSlide = _slide(const Offset(0, -2), _menuAnim);
    _menuPriceSlide = _slide(const Offset(-0.5, 0), _menuAnim);
    _menuFade = Tween<double>(begin: 0, end: 1).animate(_menuAnim);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      setState(() => _ready = true);
      _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    _menuAnim.dispose();
    super.dispose();
  }

  // ---------------- Logic ----------------

  void _setMenu(bool open) {
    setState(() => _menuOpen = open);
    if (open) {
      _menuAnim.forward();
    } else {
      _menuAnim.reverse();
    }
  }

  void _onKey(String k) {
    setState(() {
      if (k == '⌫') {
        if (_number.isNotEmpty)
          _number = _number.substring(0, _number.length - 1);
      } else if (_number.length < _maxDigits) {
        _number += k;
      }
    });
  }

  void _submitOffer() {
    debugPrint('Offer submitted: $_number');
  }

  // ---------------- build ----------------

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = math.min(size.width, _maxContentWidth);
    // Scale based on screen width and height to fit everything on one screen
    _s = math.min(width / 375, size.height / 812).clamp(0.7, 1.25).toDouble();

    final collapsedH = 130.0 * _s;
    final expandedH = math.min(730.0 * _s, size.height * 0.9);

    return Scaffold(
      appBar: _buildAppBar(),
      bottomSheet: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: _buildOfferSheet(_menuOpen ? expandedH : collapsedH),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Padding(
            // Bottom spacing to prevent content from being hidden behind the bottom sheet
            padding: EdgeInsets.only(top: 16 * _s, bottom: collapsedH + 8),
            child: _buildBody(width),
          ),
        ),
      ),
    );
  }

  // ---------------- AppBar ----------------

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _titleSlide,
          child: Text(
            widget.name,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      leadingWidth: 80,
      leading: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _leadingSlide,
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const Center(
                child: Text(
                  '<<<',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _profileSlide,
            child: Container(
              width: 65,
              height: 50,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(widget.profile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- body ----------------

  Widget _buildBody(double width) {
    final hPad = 30 * _s.clamp(0.85, 1.1);
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gallery takes up all the remaining available space
        Expanded(child: _buildGallery()),

        // title
        Padding(
          padding: EdgeInsets.only(top: 20, left: hPad, right: hPad),
          child: Hero(
            tag: widget.title,
            child: Text(
              widget.title,
              style: titleStyle?.copyWith(
                  fontSize: 20 * _s, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        // time and like
        Padding(
          padding: EdgeInsets.only(top: 20, left: hPad, right: hPad),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _timeSlide,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_alarm,
                            color: Colors.grey, size: 19 * _s),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            '40 min ago',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                                fontSize: 14 * _s),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _likeSlide,
                  child: Container(
                    width: 80 * _s,
                    height: 40 * _s,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '78',
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 17 * _s,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(Icons.local_fire_department_outlined,
                            color: Colors.black38, size: 24 * _s),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tags (using Wrap, without a fixed width)
        Padding(
          padding: EdgeInsets.only(top: 10, left: hPad, right: hPad),
          child: Hero(
            tag: widget.text,
            child: Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [_tag(widget.tag1), _tag(widget.tag2)],
            ),
          ),
        ),

        // Description
        Padding(
          padding: EdgeInsets.only(left: hPad, right: hPad - 5, top: 20),
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _textSlide,
              child: Text(
                _description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                    fontSize: 15 * _s),
              ),
            ),
          ),
        ),

        SizedBox(height: 20 * _s),

        // Price and Purchase Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag: widget.price,
                child: Text(
                  '\$${widget.price}',
                  style: titleStyle?.copyWith(
                      fontSize: 30 * _s, fontWeight: FontWeight.w900),
                ),
              ),
              FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _buySlide,
                  child: Container(
                    width: 150 * _s,
                    height: 45 * _s,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: Center(
                      child: Text(
                        'Buy now',
                        style:
                            TextStyle(fontSize: 20 * _s, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16 * _s, vertical: 6 * _s),
      decoration: BoxDecoration(
        border: Border.all(width: 1.5),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontSize: 18 * _s, fontWeight: FontWeight.w500),
      ),
    );
  }

  // ---------------- gallery ----------------

  Widget _buildGallery() {
    return LayoutBuilder(
      builder: (context, box) => _galleryRow(box.maxHeight),
    );
  }

  Widget _galleryRow(double galleryH) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            height: galleryH,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 7),
              child: Column(
                children: [
                  _thumb(_item1, 'assets/images/cloth1.png', bordered: true),
                  _thumb(_item2, 'assets/images/cloth2.png',
                      alignment: Alignment.topCenter),
                  _thumb(_item3, 'assets/images/cloth3.png'),
                  _thumb(_item4, 'assets/images/cloth4.png',
                      alignment: Alignment.topCenter),
                ],
              ),
            ),
          ),
        ),

        // main image
        Expanded(
          flex: 3,
          child: LayoutBuilder(
            builder: (context, c) {
              final boxW = math.max(0.0, c.maxWidth - 22);
              final imgSize = math.min(boxW, galleryH) * 0.77;
              return SizedBox(
                height: galleryH,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      width: _ready ? boxW : 0,
                      height: _ready ? galleryH : 0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFE8E8E8),
                      ),
                    ),
                    Hero(
                      tag: widget.image,
                      child: Image(
                        image: AssetImage(widget.image),
                        width: imgSize,
                        height: imgSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _thumb(
    Animation<Offset> slide,
    String asset, {
    bool bordered = false,
    Alignment alignment = Alignment.center,
  }) {
    final radius = BorderRadius.circular(15);
    return Expanded(
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: slide,
          child: Container(
            margin: EdgeInsets.fromLTRB(5, bordered ? 0 : 2.5, 2, 2.5),
            padding: bordered ? const EdgeInsets.all(3) : null,
            decoration: BoxDecoration(
              color: bordered ? null : const Color(0xFFEFEFEF),
              border:
                  bordered ? Border.all(color: Colors.black, width: 3) : null,
              borderRadius: radius,
              image: bordered
                  ? null
                  : DecorationImage(
                      image: AssetImage(asset),
                      alignment: alignment,
                      fit: BoxFit.cover,
                    ),
            ),
            child: bordered ? Image(image: AssetImage(asset)) : null,
          ),
        ),
      ),
    );
  }

  // ---------------- bottom sheet ----------------

  Widget _buildOfferSheet(double height) {
    return GestureDetector(
      onVerticalDragStart: (_) => _dragDy = 0,
      onVerticalDragUpdate: (d) => _dragDy += d.delta.dy,
      onVerticalDragEnd: (_) {
        if (_dragDy < -25 && !_menuOpen) _setMenu(true);
        if (_dragDy > 25 && _menuOpen) _setMenu(false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFE5E5E5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: _menuOpen
              ? const ClampingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top handle (tap to expand or collapse)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _setMenu(!_menuOpen),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _menuOpen ? 1 : 0,
                child: SlideTransition(
                  position: _menuPriceSlide,
                  child: Text(
                    '\$${widget.price}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 40 * _s),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SlideTransition(
                position: _menuOfferSlide,
                child: Text(
                  'OFFER NEW PRICE',
                  style:
                      TextStyle(fontSize: 20 * _s, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 50 * _s,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 17),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Text('\$',
                        style: TextStyle(
                            fontSize: 17 * _s, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _number,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15 * _s),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FadeTransition(
                opacity: _menuFade,
                child: _buildKeypad(),
              ),
              const SizedBox(height: 24),
              _buildSwipeButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '⌫'],
    ];
    final rowGap = (MediaQuery.sizeOf(context).height * 0.025).clamp(8.0, 24.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          for (final row in rows)
            Row(
              children: [
                for (final k in row)
                  Expanded(
                    child: k.isEmpty
                        ? const SizedBox.shrink()
                        : InkResponse(
                            onTap: _menuOpen ? () => _onKey(k) : null,
                            radius: 30,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: rowGap),
                              child: Center(
                                child: k == '⌫'
                                    ? Icon(Icons.backspace_outlined,
                                        size: 26 * _s)
                                    : Text(k,
                                        style: TextStyle(fontSize: 30 * _s)),
                              ),
                            ),
                          ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSwipeButton() {
    return Container(
      height: 60 * _s,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFC5C5C5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final handleW = math.min(100 * _s, c.maxWidth * 0.35);
          final handleH = 60 * _s - 10;
          final maxX = c.maxWidth - handleW - _handlePad;
          final x = _handleX.clamp(_handlePad, maxX);

          return Stack(
            children: [
              Positioned(
                top: 5,
                right: _handlePad,
                child: Container(
                  width: handleW,
                  height: handleH,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(Icons.done, color: Colors.black),
                ),
              ),
              AnimatedPositioned(
                duration: _dragging
                    ? Duration.zero
                    : const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                top: 5,
                left: x,
                child: GestureDetector(
                  onHorizontalDragStart: (_) => _dragging = true,
                  onHorizontalDragUpdate: (d) {
                    setState(() {
                      _handleX = (_handleX + d.delta.dx)
                          .clamp(_handlePad, maxX)
                          .toDouble();
                    });
                  },
                  onHorizontalDragEnd: (_) {
                    final done = _handleX >= maxX * 0.9;
                    setState(() {
                      _dragging = false;
                      _handleX = _handlePad;
                    });
                    if (done) _submitOffer();
                  },
                  child: Container(
                    width: handleW,
                    height: handleH,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.shop, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
