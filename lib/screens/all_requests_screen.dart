// import 'package:flutter/material.dart';
// import '../widgets/custom_drawer.dart';
// import 'request_details_screen.dart';
// import '../constants/colors.dart';
// import '../widgets/app_bar.dart';

// class AllRequestsScreen extends StatelessWidget {
//   const AllRequestsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         backgroundColor: AppColors.primaryBlue,
//         drawer: const CustomDrawer(),
//         appBar: CustomAppBar(title: "All Requests"),
//         // appBar: AppBar(
//         //   backgroundColor: AppColors.primaryBlue,
//         //   elevation: 0,
//         //   leading: Builder(
//         //     builder: (context) => IconButton(
//         //       icon: const Icon(
//         //         Icons.menu,
//         //         color: AppColors.primaryWhite,
//         //         size: 30,
//         //       ),
//         //       onPressed: () => Scaffold.of(context).openDrawer(),
//         //     ),
//         //   ),
//         //   title: const Text(
//         //     'All Requests',
//         //     style: TextStyle(
//         //       color: AppColors.primaryWhite,
//         //       fontWeight: FontWeight.bold,
//         //       fontSize: 22,
//         //     ),
//         //   ),
//         //   bottom: const TabBar(
//         //     indicatorColor: Color(0XFF308CE8),
//         //     labelColor: Color(0XFF308CE8),
//         //     unselectedLabelColor: Colors.white60,
//         //     indicatorWeight: 3,
//         //     tabs: [
//         //       Tab(text: 'New'),
//         //       Tab(text: 'Approved'),
//         //       Tab(text: 'Rejected'),
//         //     ],
//         //   ),
//         // ),
//         body: Container(
//           margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
//           decoration: BoxDecoration(
//             color: AppColors.secondaryBlue,
//             borderRadius: BorderRadius.circular(25),
//           ),
//           child: TabBarView(
//             children: [
//               _buildRequestsList(context),
//               const Center(
//                 child: Text(
//                   'No Approved Requests yet',
//                   style: TextStyle(color: AppColors.primaryBlue),
//                 ),
//               ),
//               const Center(
//                 child: Text(
//                   'No Rejected Requests yet',
//                   style: TextStyle(color: AppColors.primaryBlue),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRequestsList(BuildContext context) {
//     final List<Map<String, String>> requests = [
//       {'name': 'Rawan Yahya', 'car': 'Hyundai Tucson', 'type': 'SUV'},
//       {'name': 'Leen Sabri', 'car': 'Toyota Rush', 'type': 'Family / 7-Seater'},
//       {'name': 'Amal Zaben', 'car': 'BMW 5 Series', 'type': 'Luxury Sedan'},
//       {'name': 'Hanade Zareer', 'car': 'Tesla Model 3', 'type': 'Electric'},
//     ];

//     return ListView.builder(
//       padding: const EdgeInsets.all(15),
//       itemCount: requests.length,
//       itemBuilder: (context, index) {
//         return _buildRequestCard(
//           context,
//           requests[index]['name']!,
//           requests[index]['car']!,
//           requests[index]['type']!,
//         );
//       },
//     );
//   }

//   Widget _buildRequestCard(
//     BuildContext context,
//     String name,
//     String car,
//     String type,
//   ) {
//     const Color darkBlue = AppColors.primaryBlue;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 15),
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//       decoration: BoxDecoration(
//         color: AppColors.primaryWhite,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _infoRow('Name: ', name),
//                 const SizedBox(height: 4),
//                 _infoRow('Car: ', car),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Type: $type',
//                   style: const TextStyle(color: Colors.grey, fontSize: 13),
//                 ),
//               ],
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const RequestDetailsScreen(),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.secondaryBlue,
//               foregroundColor: AppColors.primaryBlue,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//             ),
//             child: const Text(
//               'Open',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoRow(String label, String value) {
//     return RichText(
//       text: TextSpan(
//         style: const TextStyle(color: Colors.black, fontSize: 15),
//         children: [
//           TextSpan(
//             text: label,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           TextSpan(text: value),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'request_details_screen.dart';
import '../constants/colors.dart';
import '../widgets/app_bar.dart';

class AllRequestsScreen extends StatelessWidget {
  const AllRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.primaryBlue,
        drawer: const CustomDrawer(),
        // استخدام الـ CustomAppBar الخاص بك
        appBar: const CustomAppBar(title: "All Requests"),
        body: Column(
          children: [
            // وضع التبويبات هنا خارج الـ AppBar
            const TabBar(
              indicatorColor: AppColors.primaryWhite,
              labelColor: AppColors.primaryWhite,
              unselectedLabelColor: Colors.white60,
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'New'),
                Tab(text: 'Approved'),
                Tab(text: 'Rejected'),
              ],
            ),
            // الجزء السفلي الذي يحتوي على محتوى الطلبات
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBlue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBarView(
                  children: [
                    _buildRequestsList(context),
                    const Center(
                      child: Text(
                        'No Approved Requests yet',
                        style: TextStyle(color: AppColors.primaryBlue),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'No Rejected Requests yet',
                        style: TextStyle(color: AppColors.primaryBlue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList(BuildContext context) {
    final List<Map<String, String>> requests = [
      {'name': 'Rawan Yahya', 'car': 'Hyundai Tucson', 'type': 'SUV'},
      {'name': 'Leen Sabri', 'car': 'Toyota Rush', 'type': 'Family / 7-Seater'},
      {'name': 'Amal Zaben', 'car': 'BMW 5 Series', 'type': 'Luxury Sedan'},
      {'name': 'Hanade Zareer', 'car': 'Tesla Model 3', 'type': 'Electric'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        return _buildRequestCard(
          context,
          requests[index]['name']!,
          requests[index]['car']!,
          requests[index]['type']!,
        );
      },
    );
  }

  Widget _buildRequestCard(
    BuildContext context,
    String name,
    String car,
    String type,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow('Name: ', name),
                const SizedBox(height: 4),
                _infoRow('Car: ', car),
                const SizedBox(height: 4),
                Text(
                  'Type: $type',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequestDetailsScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryBlue,
              foregroundColor: AppColors.primaryBlue,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
            ),
            child: const Text(
              'Open',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 15),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
