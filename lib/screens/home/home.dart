import 'package:flutter/material.dart';

import 'transactions_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Hi, John',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            // CarouselSlider(
            //   items: List.generate(
            //     3,
            //     (index) => SizedBox(
            //       width: double.infinity,
            //       child: Card(
            //         elevation: 0,
            //         color: Colors.grey[200],
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //         ),
            //       ),
            //     ),
            //   ),
            //   options: CarouselOptions(
            //     enableInfiniteScroll: false,
            //     scrollPhysics: const BouncingScrollPhysics(),
            //     enlargeCenterPage: true,
            //   ),
            // ),
            Expanded(child: TransactionsLists())
          ],
        ),
      ),
    );
  }
}
