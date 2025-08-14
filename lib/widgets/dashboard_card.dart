import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String time;

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 768;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 16.0 : 12.0), // Reduced padding
        child: Row(
          children: [
            Container(
              padding:
                  EdgeInsets.all(isLargeScreen ? 12 : 8), // Reduced padding
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: isLargeScreen ? 24 : 20, // Reduced icon size
              ),
            ),
            SizedBox(width: isLargeScreen ? 16 : 12), // Reduced spacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Prevent expansion
                children: [
                  Flexible(
                    // Wrap in Flexible to prevent overflow
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                isLargeScreen ? 16 : 14, // Reduced font size
                          ),
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                    ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    // Wrap in Flexible to prevent overflow
                    child: Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            fontSize:
                                isLargeScreen ? 14 : 12, // Reduced font size
                          ),
                      overflow: TextOverflow.ellipsis, // Handle text overflow
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    fontSize: isLargeScreen ? 12 : 10, // Reduced font size
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
