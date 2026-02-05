import 'package:flutter/material.dart';
import '../screens/profile_employee_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/about_us_screen.dart';
import '../screens/booking_history_screen.dart';
import '../constants/colors.dart';
import '../screens/favorite_cars_screen.dart';
import '../screens/main_menu_screen.dart';
import '../constants/colors.dart';
import '../screens/profile_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/about_us_screen.dart';
import '../screens/booking_history_screen.dart';
import '../screens/favorite_cars_screen.dart';
import '../screens/main_menu_screen.dart';
import '../screens/login_screen.dart';
import '../screens/all_requests_screen.dart';
import '../screens/profile_employee_screen.dart';
import '../screens/create_employee_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/manager_notification_screen.dart';
import '../screens/deliveries_screen.dart';
import '../screens/my_deliveries_screen.dart';
import '../screens/add_request_screen.dart';
import '../screens/add_car_screen.dart';

class CustomDrawer extends StatefulWidget {
  /// [viewMode]
  /// 0 -> Customer
  /// 1 -> Booking Office Employee
  /// 2 -> Delivery
  /// 3 -> Online request Approver
  /// 4 -> Manager
  final int viewMode;

  const CustomDrawer({super.key, this.viewMode = 0});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  static String activePage = 'Home';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.primaryBlue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(context),
            const SizedBox(height: 10),

            _drawerTile(context, Icons.home, 'Home', () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainMenuScreen()),
              );
            }),

            // if (widget.viewMode != 4)
            _drawerTile(context, Icons.person, 'Profile', () {
              if (widget.viewMode == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileEmployeeScreen(),
                  ),
                );
              }
            }),

            // if (widget.viewMode != 1 && widget.viewMode != 3)
            _drawerTile(context, Icons.notifications, 'Notifications', () {
              if (widget.viewMode == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManagerNotificationScreen(),
                  ),
                );
              }
            }),

            // if (widget.viewMode == 3)
            _drawerTile(
              context,
              Icons.format_list_bulleted,
              'All Requests',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllRequestsScreen(),
                  ),
                );
              },
            ),

            _drawerTile(
              context,
              Icons.local_shipping_outlined,
              'Deliveries',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeliveriesScreen(),
                  ),
                );
              },
            ),

            _drawerTile(
              context,
              Icons.assignment_turned_in_outlined,
              'My Deliveries',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyDeliveriesScreen(),
                  ),
                );
              },
            ),

            // if (widget.viewMode != 0)
            _drawerTile(context, Icons.favorite, 'Favorite cars', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteCarsScreen(),
                ),
              );
            }),

            // if (widget.viewMode == 0)
            _drawerTile(context, Icons.history_rounded, 'Booking history', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookingHistoryScreen(),
                ),
              );
            }),

            // if (widget.viewMode == 4)
            _drawerTile(context, Icons.person_add, 'Create Account', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateEmployeeScreen(),
                ),
              );
            }),
            // if (widget.viewMode == 4)
            _drawerTile(context, Icons.assignment, 'Reports', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportsScreen()),
              );
            }),
            _drawerTile(context, Icons.add_circle_outline, 'Add Request', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddRequestScreen(car: {}),
                ),
              );
            }),

            _drawerTile(
              context,
              Icons.directions_car_filled_outlined,
              'Add Car',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCarScreen()),
                );
              },
            ),


            _drawerTile(context, Icons.info_outline, 'About us', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            }),

            _drawerTile(context, Icons.logout, 'Log out', () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.only(
          top: 50,
          left: 16,
          right: 16,
          bottom: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.menu, color: AppColors.primaryWhite, size: 30),
                const SizedBox(width: 15),
                const Text(
                  'Menu',
                  style: TextStyle(
                    color: AppColors.primaryWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    bool isActive = activePage == title;
    Color contentColor = isActive
        ? const Color(0xFF00E5FF)
        : Colors.white; 
    return ListTile(
      leading: Icon(icon, color: contentColor, size: 28),
      title: Text(
        title,
        style: TextStyle(
          color: contentColor,
          fontSize: 18,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      onTap: () {
        setState(() => activePage = title);
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
