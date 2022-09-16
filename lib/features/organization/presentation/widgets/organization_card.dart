import 'package:example/config/app_layout.dart';
import 'package:example/features/common/presentation/utils/extensions/ui_extension.dart';
import 'package:example/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A selectable [Card] with [Organization title]
/// [selected] -
class OrganizationCard extends StatelessWidget {
  /// Default constructor for [OrganizationCard]
  const OrganizationCard({
    super.key,
    required this.organization,
    required this.selected,
  });

  /// The organization that the card represents
  final OrganizationEntity organization;

  /// Determines if the card is selected or not
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/${DashboardScreen.routePath}/${organization.id}',
        );
      },
      child: SizedBox(
        height: 100,
        width: 392,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppLayout.cardRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppLayout.defaultPadding),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        organization.name,
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      // Text(organization.description)
                    ],
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
