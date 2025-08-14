import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 768;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 16.0 : 12.0), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Prevent expansion
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      EdgeInsets.all(isLargeScreen ? 8 : 6), // Reduced padding
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: isLargeScreen ? 24 : 20, // Reduced icon size
                  ),
                ),
                Icon(
                  Icons.trending_up,
                  color: Colors.green,
                  size: isLargeScreen ? 20 : 16, // Reduced icon size
                ),
              ],
            ),
            SizedBox(height: isLargeScreen ? 12 : 8), // Reduced spacing
            Flexible(
              // Wrap in Flexible to prevent overflow
              child: Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: isLargeScreen ? 20 : 18, // Reduced font size
                    ),
                overflow: TextOverflow.ellipsis, // Handle text overflow
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              // Wrap in Flexible to prevent overflow
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: isLargeScreen ? 14 : 12, // Reduced font size
                    ),
                overflow: TextOverflow.ellipsis, // Handle text overflow
              ),
            ),
          ],
        ),
      ),
    );
  }
}
