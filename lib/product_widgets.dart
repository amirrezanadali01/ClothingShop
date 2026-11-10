import 'dart:ui';
import 'package:flutter/material.dart';

class StoriesUser extends StatelessWidget {
  const StoriesUser(
      {super.key,
      required this.image,
      required this.isActive,
      required this.name});

  final bool isActive;
  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(
                color: isActive ? Colors.grey : Colors.black, width: 3),
            borderRadius: BorderRadius.circular(23),
            color: Colors.white,
          ),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image:
                  DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(name)
      ],
    );
  }
}

class InfoProduct extends StatelessWidget {
  const InfoProduct({
    required this.isActive,
    required this.tun1,
    required this.tun2,
    required this.blur1,
    required this.blur2,
    required this.image,
    required this.profile,
    required this.price,
    required this.text,
    required this.title,
    required this.tag1,
    required this.tag2,
    super.key,
  });

  final bool isActive;
  final Animation tun1;
  final Animation tun2;

  final Animation blur1;
  final Animation blur2;

  final String image;
  final String profile;
  final String price;
  final String title;
  final String text;
  final String tag1;
  final String tag2;

  @override
  Widget build(BuildContext context) {
    // start 0
    // end 0.08916669492368346

    return Transform.rotate(
      angle: isActive == true ? -tun1.value : -tun2.value,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: ImageFiltered(
          enabled: !isActive,
          imageFilter: ImageFilter.blur(
              sigmaX: isActive == true ? blur1.value : blur2.value,
              sigmaY: isActive == true ? blur1.value : blur2.value),
          child: Container(
            width: 360,
            height: 470,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: AssetImage(profile),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'mike_03',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.access_alarm,
                                    color: Colors.grey,
                                    size: 19,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '40 min ago',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Text(
                              '78',
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              Icons.local_fire_department_outlined,
                              color: Colors.black38,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Hero(
                      tag: '${image}',
                      child: Image(
                        image: AssetImage(image),
                        height: 205,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Hero(
                    tag: title,
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    text,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Hero(
                        tag: price,
                        child: Text(
                          '\$${price}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 25),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Hero(
                        tag: text,
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 35,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.5),
                                borderRadius: BorderRadius.circular(23),
                              ),
                              child: Center(
                                child: Text(
                                  tag1,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(width: 7),
                            Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.5),
                                borderRadius: BorderRadius.circular(23),
                              ),
                              child: Center(
                                child: Text(
                                  tag2,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
