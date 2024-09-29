import 'package:flutter/material.dart';
import 'package:spento/utils/page_data.dart';

class ResponsiveNavigation extends StatefulWidget {
  @override
  _ResponsiveNavState createState() => _ResponsiveNavState();
}

class _ResponsiveNavState extends State<ResponsiveNavigation> {
  bool _isCollapsed = false; 
  int _selectedIndex = 0;
  double _sidebarWidthExpanded = 250;
  double _sidebarWidthCollapsed = 70;

  void _toggleSidebar() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Scaffold(
            body: Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _isCollapsed ? _sidebarWidthCollapsed : _sidebarWidthExpanded,
                  color: Color(0xff20a8d8),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        height: 60,
                        child: Center(
                          child: Text('SPENTO', style: TextStyle(fontSize: _isCollapsed ? 16 : 20, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: pageLists.length,
                          itemBuilder: (context, index){
                            final data = pageLists[index];
                            return SidebarItem(
                              icon: data['icon'],
                              title: data['title'],
                              isCollapsed: _isCollapsed,
                              isSelected: _selectedIndex == index,
                              onTap: () => _onItemTapped(index),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: _toggleSidebar,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: pages[_selectedIndex],
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: navItems,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCollapsed;
  final bool isSelected;
  final VoidCallback onTap;

  SidebarItem({
    required this.icon,
    required this.title,
    required this.isCollapsed,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      color: isSelected ? const Color(0xff2f353a) : null,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: !isCollapsed ? Text(title, style: TextStyle(color: Colors.white)) : null,
        horizontalTitleGap: 12,
        onTap: onTap,
      ),
    );
  }
}
