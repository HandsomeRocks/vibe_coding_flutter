import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/stat_card.dart';
import 'login_screen.dart';
import 'web_embed_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  String? _selectedSubMenu;
  String? _selectedSuperSpecialType; // 'Current' or 'Previous'
  
  // Drawer expansion states
  bool _cataloguesExpanded = false;
  bool _superSpecialsExpanded = false;
  
  // Sample URLs for demonstration
  final Map<String, String> _catalogueUrls = {
    'Current': 'https://bbb.co.za/',
    'Previous': 'https://bbb.co.za/',
  };
  
  final Map<String, Map<String, String>> _superSpecialsUrls = {
    'Current': {
      'South Africa': 'https://bbb.co.za/',
      'Namibia': 'https://bbb.co.za/',
      'Botswana': 'https://bbb.co.za/',
      'Zimbabwe': 'https://bbb.co.za/',
    },
    'Previous': {
      'South Africa': 'https://bbb.co.za/',
      'Namibia': 'https://bbb.co.za/',
      'Botswana': 'https://bbb.co.za/',
      'Zimbabwe': 'https://bbb.co.za/',
    },
  };
  
  final List<Map<String, dynamic>> _reports = [
    {'name': 'Sales Report', 'url': 'https://bbb.co.za/', 'icon': Icons.trending_up},
    {'name': 'Inventory Report', 'url': 'https://bbb.co.za/', 'icon': Icons.inventory},
    {'name': 'Customer Report', 'url': 'https://bbb.co.za/', 'icon': Icons.people},
    {'name': 'Revenue Report', 'url': 'https://bbb.co.za/', 'icon': Icons.attach_money},
    {'name': 'Performance Report', 'url': 'https://bbb.co.za/', 'icon': Icons.analytics},
    {'name': 'Marketing Report', 'url': 'https://bbb.co.za/', 'icon': Icons.campaign},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_getPageTitle()),
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
              // Navigate back to login screen and clear the navigation stack
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false, // Remove all previous routes
                );
              }
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
                  'Admin Home',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isLargeScreen ? 14 : 12, // Reduced font size
                  ),
                ),
              ],
            ),
          ),
          // Navigation items
          _buildNavigationItem(Icons.home, 'Home', 0),
          _buildExpandableNavigationItem(
            Icons.category, 
            'Catalogues', 
            1,
            _cataloguesExpanded,
            ['Current', 'Previous'],
            (subMenu) {
              setState(() {
                _selectedIndex = 1;
                _selectedSubMenu = subMenu;
                _selectedSuperSpecialType = null;
              });
              Navigator.pop(context);
            },
          ),
          _buildExpandableNavigationItem(
            Icons.local_offer, 
            'Super Specials', 
            2,
            _superSpecialsExpanded,
            ['Current', 'Previous'],
            (subMenu) {
              setState(() {
                _selectedIndex = 2;
                _selectedSuperSpecialType = subMenu;
              });
              Navigator.pop(context);
            },
          ),
          _buildNavigationItem(Icons.assessment, 'Reports', 3),
          const Divider(),
          _buildNavigationItem(Icons.help, 'Help & Support', 4),
          _buildNavigationItem(Icons.info, 'About', 5),
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
            _selectedSubMenu = null;
            _selectedSuperSpecialType = null;
          });
        }
        // Close drawer on all screen sizes
        Navigator.pop(context);
      },
    );
  }

  Widget _buildExpandableNavigationItem(
    IconData icon, 
    String title, 
    int index,
    bool isExpanded,
    List<String> subMenus,
    Function(String) onSubMenuTap,
  ) {
    final bool isSelected = _selectedIndex == index;
    
    return Column(
      children: [
        ListTile(
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
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
          selected: isSelected,
          selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          onTap: () {
            setState(() {
              if (title == 'Catalogues') {
                _cataloguesExpanded = !_cataloguesExpanded;
              } else if (title == 'Super Specials') {
                _superSpecialsExpanded = !_superSpecialsExpanded;
              }
            });
          },
        ),
        if (isExpanded) ...[
          ...subMenus.map((subMenu) => Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ListTile(
              leading: const SizedBox(width: 24), // Indent sub-menu
              title: Text(
                subMenu,
                style: TextStyle(
                  fontSize: 14,
                  color: (_selectedIndex == index && 
                         ((title == 'Catalogues' && _selectedSubMenu == subMenu) ||
                          (title == 'Super Specials' && _selectedSuperSpecialType == subMenu)))
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[600],
                  fontWeight: (_selectedIndex == index && 
                             ((title == 'Catalogues' && _selectedSubMenu == subMenu) ||
                              (title == 'Super Specials' && _selectedSuperSpecialType == subMenu)))
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              selected: _selectedIndex == index && 
                       ((title == 'Catalogues' && _selectedSubMenu == subMenu) ||
                        (title == 'Super Specials' && _selectedSuperSpecialType == subMenu)),
              selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              onTap: () => onSubMenuTap(subMenu),
            ),
          )),
        ],
      ],
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildCataloguesTab();
      case 2:
        return _buildSuperSpecialsTab();
      case 3:
        return _buildReportsTab();
      case 4:
        return _buildHelpSupportTab();
      case 5:
        return _buildAboutTab();
      default:
        return _buildDashboardTab();
    }
  }

  Widget _buildDashboardTab() {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 768;
    final int crossAxisCount = isLargeScreen ? 3 : 2;

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
                  'Welcome to New BBB App!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Access your catalogues, super specials, and reports',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Main Navigation Tiles
          Text(
            'Quick Access',
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
            childAspectRatio: isLargeScreen ? 1.2 : 1.0,
            children: [
              _buildHomeTile(
                'Catalogues',
                Icons.category,
                Colors.blue,
                'View current and previous catalogues',
                () {
                  setState(() {
                    _selectedIndex = 1;
                    _selectedSubMenu = null;
                    _selectedSuperSpecialType = null;
                  });
                },
              ),
              _buildHomeTile(
                'Super Specials',
                Icons.local_offer,
                Colors.orange,
                'Browse super special pamphlets by country',
                () {
                  setState(() {
                    _selectedIndex = 2;
                    _selectedSuperSpecialType = null;
                  });
                },
              ),
              _buildHomeTile(
                'Reports',
                Icons.assessment,
                Colors.green,
                'Access various business reports',
                () {
                  setState(() {
                    _selectedIndex = 3;
                    _selectedSubMenu = null;
                    _selectedSuperSpecialType = null;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCataloguesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with sub-menu selection
          if (_selectedSubMenu != null) ...[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _selectedSubMenu = null;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'Catalogues - $_selectedSubMenu',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              'Catalogues',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select Current or Previous from the menu',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
          const SizedBox(height: 24),
          
          // Show either selection or specific catalogue
          if (_selectedSubMenu == null) ...[
            // Show selection options
            _buildCatalogueSelection(),
          ] else ...[
            // Show specific catalogue
            _buildSubMenuSection(
              _selectedSubMenu!,
              _catalogueUrls[_selectedSubMenu!]!,
              _selectedSubMenu == 'Current' ? Icons.today : Icons.history,
              _selectedSubMenu == 'Current' ? Colors.blue : Colors.grey,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCatalogueSelection() {
    return Column(
      children: [
        // Current Catalogues
        _buildTypeSelectionCard(
          'Current',
          Icons.today,
          Colors.blue,
          'View current catalogues',
        ),
        const SizedBox(height: 16),
        
        // Previous Catalogues
        _buildTypeSelectionCard(
          'Previous',
          Icons.history,
          Colors.grey,
          'View previous catalogues',
        ),
      ],
    );
  }

  Widget _buildSuperSpecialsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with back button if on country selection page
          if (_selectedSuperSpecialType != null) ...[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _selectedSuperSpecialType = null;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'Super Specials - $_selectedSuperSpecialType',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              'Super Specials',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
          const SizedBox(height: 24),
          
          // Show either the type selection or country selection
          if (_selectedSuperSpecialType == null) ...[
            // Page 1: Select Current or Previous
            _buildSuperSpecialTypeSelection(),
          ] else ...[
            // Page 2: Select Country
            _buildCountrySelection(_selectedSuperSpecialType!),
          ],
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 768;
    final int crossAxisCount = isLargeScreen ? 3 : 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isLargeScreen ? 1.5 : 1.2,
            ),
            itemCount: _reports.length,
            itemBuilder: (context, index) {
              final report = _reports[index];
              return _buildReportCard(report);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubMenuSection(String title, String url, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Show WebEmbedScreen as a modal dialog
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding: const EdgeInsets.all(16),
                child: Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: WebEmbedScreen(
                    title: '$title Catalogue',
                    url: url,
                    parameters: {
                      'source': 'app',
                      'type': 'catalogue',
                      'period': title.toLowerCase(),
                    },
                  ),
                ),
              );
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Click to view $title catalogue',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuperSpecialTypeSelection() {
    return Column(
      children: [
        // Current Super Specials
        _buildTypeSelectionCard(
          'Current',
          Icons.local_offer,
          Colors.orange,
          'View current super special pamphlets by country',
        ),
        const SizedBox(height: 16),
        
        // Previous Super Specials
        _buildTypeSelectionCard(
          'Previous',
          Icons.history,
          Colors.grey,
          'View previous super special pamphlets by country',
        ),
      ],
    );
  }

  Widget _buildTypeSelectionCard(String title, IconData icon, Color color, String description) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (_selectedIndex == 1) {
            // Catalogues
            setState(() {
              _selectedSubMenu = title;
            });
          } else if (_selectedIndex == 2) {
            // Super Specials
            setState(() {
              _selectedSuperSpecialType = title;
            });
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountrySelection(String type) {
    final countryUrls = _superSpecialsUrls[type]!;
    final color = type == 'Current' ? Colors.orange : Colors.grey;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Country',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose a country to view $type super special pamphlets',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 24),
        
        // Country selection grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.5,
          ),
          itemCount: countryUrls.length,
          itemBuilder: (context, index) {
            final country = countryUrls.keys.elementAt(index);
            final url = countryUrls[country]!;
            return _buildCountryCard(country, url, color);
          },
        ),
      ],
    );
  }

  Widget _buildHomeTile(String title, IconData icon, Color color, String description, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Icon(
                Icons.arrow_forward,
                color: color,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryCard(String country, String url, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          // Show WebEmbedScreen as a modal dialog
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding: const EdgeInsets.all(16),
                child: Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: WebEmbedScreen(
                    title: 'Super Specials - $country',
                    url: url,
                    parameters: {
                      'source': 'app',
                      'type': 'super_specials',
                      'country': country.toLowerCase().replaceAll(' ', '_'),
                      'period': _selectedSuperSpecialType?.toLowerCase() ?? 'current',
                    },
                  ),
                ),
              );
            },
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.public,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  country,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Show WebEmbedScreen as a modal dialog
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding: const EdgeInsets.all(16),
                child: Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: WebEmbedScreen(
                    title: report['name'],
                    url: report['url'],
                    parameters: {
                      'source': 'app',
                      'type': 'report',
                      'report_type': report['name'].toLowerCase().replaceAll(' ', '_'),
                    },
                  ),
                ),
              );
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                report['icon'],
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                report['name'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Click to view report',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSupportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Help & Support',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          
          // FAQ Section
          _buildHelpCard(
            'Frequently Asked Questions',
            Icons.question_answer,
            Colors.blue,
            'Find answers to common questions about using the app',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening FAQ section...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          
          // Contact Support
          _buildHelpCard(
            'Contact Support',
            Icons.support_agent,
            Colors.green,
            'Get in touch with our support team',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening contact support...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          
          // User Guide
          _buildHelpCard(
            'User Guide',
            Icons.book,
            Colors.orange,
            'Learn how to use all features of the app',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening user guide...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          
          // Troubleshooting
          _buildHelpCard(
            'Troubleshooting',
            Icons.build,
            Colors.red,
            'Common issues and their solutions',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening troubleshooting guide...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          
          // App Info Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.app_registration,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New BBB App',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Version 1.0.0',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'A comprehensive business management application for catalogues, super specials, and reports.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Company Info
          _buildAboutCard(
            'Company Information',
            Icons.business,
            Colors.blue,
            'Learn more about our company and mission',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening company information...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          
          // Privacy Policy
          _buildAboutCard(
            'Privacy Policy',
            Icons.privacy_tip,
            Colors.green,
            'Read our privacy policy and data protection information',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening privacy policy...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          
          // Terms of Service
          _buildAboutCard(
            'Terms of Service',
            Icons.description,
            Colors.orange,
            'View our terms of service and usage guidelines',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening terms of service...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          
          // Contact Us
          _buildAboutCard(
            'Contact Us',
            Icons.contact_support,
            Colors.purple,
            'Get in touch with our team',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening contact information...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard(String title, IconData icon, Color color, String description, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Home';
      case 1:
        if (_selectedSubMenu != null) {
          return 'Catalogues - $_selectedSubMenu';
        }
        return 'Catalogues';
      case 2:
        if (_selectedSuperSpecialType != null) {
          return 'Super Specials - $_selectedSuperSpecialType';
        }
        return 'Super Specials';
      case 3:
        return 'Reports';
      case 4:
        return 'Help & Support';
      case 5:
        return 'About';
      default:
        return 'Home';
    }
  }

  Widget _buildAboutCard(String title, IconData icon, Color color, String description, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
