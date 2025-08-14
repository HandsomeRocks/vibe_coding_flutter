import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildDrawer() {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 768;

    return Drawer(
      width: isLargeScreen ? 280 : null, // Wider drawer on desktop
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Prevent expansion
              children: [
                CircleAvatar(
                  radius: isLargeScreen ? 30 : 25, // Reduced radius
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: isLargeScreen ? 35 : 30, // Reduced icon size
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8), // Reduced spacing
                Text(
                  'New BBB App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLargeScreen ? 20 : 18, // Reduced font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isLargeScreen ? 14 : 12, // Reduced font size
                  ),
                ),
              ],
            ),
          ),
          // Navigation items
          _buildNavigationItem(Icons.dashboard, 'Dashboard', 0),
          _buildNavigationItem(Icons.analytics, 'Analytics', 1),
          _buildNavigationItem(Icons.people, 'Users', 2),
          _buildNavigationItem(Icons.settings, 'Settings', 3),
          const Divider(),
          _buildNavigationItem(Icons.help, 'Help & Support', -1),
          _buildNavigationItem(Icons.info, 'About', -1),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(IconData icon, String title, int index) {
    final bool isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      onTap: () {
        if (index >= 0) {
          setState(() {
            _selectedIndex = index;
          });
        }
        // Close drawer on all screen sizes
        Navigator.pop(context);
      },
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildAnalyticsTab();
      case 2:
        return _buildUsersTab();
      case 3:
        return _buildSettingsTab();
      default:
        return _buildDashboardTab();
    }
  }

  Widget _buildDashboardTab() {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 768;
    final int crossAxisCount = isLargeScreen ? 4 : 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here\'s what\'s happening today',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats Section
          Text(
            'Quick Stats',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isLargeScreen
                ? 2.5
                : 1.8, // Increased aspect ratio to prevent overflow
            children: [
              const StatCard(
                title: 'Total Users',
                value: '1,234',
                icon: Icons.people,
                color: Colors.blue,
              ),
              const StatCard(
                title: 'Active Sessions',
                value: '567',
                icon: Icons.online_prediction,
                color: Colors.green,
              ),
              const StatCard(
                title: 'Revenue',
                value: '\$12,345',
                icon: Icons.attach_money,
                color: Colors.orange,
              ),
              const StatCard(
                title: 'Orders',
                value: '89',
                icon: Icons.shopping_cart,
                color: Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Activity
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          // Responsive activity cards
          if (isLargeScreen) ...[
            // Desktop: 2 columns
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      DashboardCard(
                        title: 'New User Registration',
                        subtitle: 'John Doe joined the platform',
                        icon: Icons.person_add,
                        time: '2 minutes ago',
                      ),
                      const SizedBox(height: 12),
                      DashboardCard(
                        title: 'Order Completed',
                        subtitle: 'Order #12345 has been delivered',
                        icon: Icons.check_circle,
                        time: '15 minutes ago',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DashboardCard(
                    title: 'System Update',
                    subtitle: 'New features have been deployed',
                    icon: Icons.system_update,
                    time: '1 hour ago',
                  ),
                ),
              ],
            ),
          ] else ...[
            // Mobile: Single column
            DashboardCard(
              title: 'New User Registration',
              subtitle: 'John Doe joined the platform',
              icon: Icons.person_add,
              time: '2 minutes ago',
            ),
            const SizedBox(height: 12),
            DashboardCard(
              title: 'Order Completed',
              subtitle: 'Order #12345 has been delivered',
              icon: Icons.check_circle,
              time: '15 minutes ago',
            ),
            const SizedBox(height: 12),
            DashboardCard(
              title: 'System Update',
              subtitle: 'New features have been deployed',
              icon: Icons.system_update,
              time: '1 hour ago',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Analytics Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'User Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
