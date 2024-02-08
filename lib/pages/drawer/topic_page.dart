// import 'package:flutter/material.dart';
// import 'package:timetrek/pages/drawer/drawer.dart';
// import 'package:timetrek/pages/drawer/home_page.dart';
// import 'package:timetrek/widgets/widgets.dart';
//
// class TopicPage extends StatefulWidget {
//   const TopicPage({super.key});
//
//   @override
//   State<TopicPage> createState() => _TopicPageState();
// }
//
// class _TopicPageState extends State<TopicPage> {
//
//   List<String> selectedTopics = [];
//
//   final List<String> allTopics = [
//     'Sports',
//     'Entertainment',
//     'Social Media',
//     'Trucking',
//     'Adventure',
//     'More', // You can add more topics here
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       drawer: SideDrawer(),
//
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           color: Colors.black,
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             nextScreen(context, const HomePage());
//           },
//         ),
//       ),
//
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//               children: [
//
//                 Container(
//                   alignment: Alignment.topLeft,
//                   child: const Text(
//                     'All Topics',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//
//                 ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: allTopics.length,
//                   itemBuilder: (context, index) {
//                     final topic = allTopics[index];
//                     final bool isSelected = selectedTopics.contains(topic);
//
//                     return CheckboxListTile(
//                       title: Text(topic),
//                       value: isSelected,
//                       onChanged: (bool? newValue) {
//                         setState(() {
//                           if (newValue ?? false) { // Use null-coalescing operator ??
//                             selectedTopics.add(topic);
//                           } else {
//                             selectedTopics.remove(topic);
//                           }
//                         });
//                       },
//                     );
//                   },
//                 ),
//
//
//
//
//               ],
//           ),
//
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:timetrek/pages/drawer/drawer.dart';
import 'package:timetrek/pages/drawer/home_page.dart';
import 'package:timetrek/widgets/widgets.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({super.key});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  List<String> selectedTopics = [];

  final List<String> allTopics = [
    'Sports',
    'Entertainment',
    'Social Media',
    'Trucking',
    'Adventure',
    'More', // You can add more topics here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            nextScreen(context, const HomePage());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'All Topics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10), // Add some spacing between the title and buttons
              Wrap(
                spacing: 10,
                children: allTopics.map((topic) => buildTopicButton(topic)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopicButton(String topic) {
    final bool isSelected = selectedTopics.contains(topic);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            selectedTopics.remove(topic);
          } else {
            selectedTopics.add(topic);
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey, // Change color based on selection
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        topic,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }






}
