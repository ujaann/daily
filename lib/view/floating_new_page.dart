import 'package:flutter/material.dart';

class FloatingNewPage extends StatelessWidget {
  FloatingNewPage({required this.text, super.key});
  final String text;
  final DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(text),
          // CustomKeyboard(),
        ],
      ),
    );
  }
}

// class CustomKeyboard extends StatelessWidget {
//   const CustomKeyboard({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ColoredBox(
//       color: ColorsDaily.darkgray,
//       child: Column(
//         children: [
//           TextField(
//             decoration: InputDecoration(hintText: "Note"),
//           ),
//           // Column(
//           //   children: [
//           //     TextField(
//           //       enabled: false,
//           //       inputFormatters: [
//           //         FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?')),
//           //       ],
//           //       decoration: InputDecoration(
//           //         border: InputBorder.none,
//           //         disabledBorder: InputBorder.none,
//           //         focusedBorder: UnderlineInputBorder(),
//           //       ),
//           //       textAlign: TextAlign.right,
//           //     ),
//           //     SizedBox(
//           //       width: double.infinity,
//           //       // height: 270,
//           //       height: 270,
//           //       child: GridView.count(
//           //         padding: const EdgeInsets.all(12),
//           //         mainAxisSpacing: 12,
//           //         crossAxisSpacing: 12,
//           //         crossAxisCount: 4,
//           //         childAspectRatio: 2,
//           //         children: [
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '7',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '8',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '9',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text('today', style: FontsDaily.titleSubText)),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '4',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '5',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '6',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '+',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '1',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '2',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '3',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '-',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '.',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '0',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '«',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //           ElevatedButton(
//           //               onPressed: () {},
//           //               child: Text(
//           //                 '✓',
//           //                 style: FontsDaily.titleSubText,
//           //               )),
//           //         ],
//           //       ),
//           //     ),
//           //   ],
//           // ),

          
//         ],
//       ),
//     );
//   }
// }


// ElevatedButton(
//               onPressed: () {
//                 showModalBottomSheet(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return SizedBox(
//                       height: 600,
//                       child: Center(
//                           child: GridView.count(
//                         padding: EdgeInsets.all(12),
//                         mainAxisSpacing: 12,
//                         crossAxisSpacing: 12,
//                         crossAxisCount: 3,
//                         children: [
//                           ElevatedButton(onPressed: null, child: Text("data")),
//                           ColoredBox(
//                             color: ColorsDaily.green,
//                             child: Text('1'),
//                           ),
//                           ColoredBox(
//                             color: ColorsDaily.green,
//                             child: Text('1'),
//                           ),
//                           ColoredBox(
//                             color: ColorsDaily.green,
//                             child: Text('1'),
//                           ),
//                           ColoredBox(
//                             color: ColorsDaily.green,
//                             child: Text('1'),
//                           ),
//                           ColoredBox(
//                             color: ColorsDaily.green,
//                             child: Text('1'),
//                           ),
//                         ],
//                       )),
//                     );
//                   },
//                 );
//               },
//               child: Text("Open button"))