import 'package:dotted_border/dotted_border.dart';
import 'package:example/config/app_layout.dart';
import 'package:example/features/common/presentation/utils/extensions/ui_extension.dart';
import 'package:example/features/organization/presentation/screens/organization_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main screen card that adds organization
class AddOrganizationCard extends StatelessWidget {
  ///
  const AddOrganizationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(OrganizationsCreateScreen.routeName),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(AppLayout.cardRadius),
        padding: EdgeInsets.zero,
        dashPattern: const [3, 3],
        child: SizedBox(
          height: 100,
          width: 392,
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppLayout.cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppLayout.defaultPadding),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr.addOrganization,
                      style: context.textTheme.titleMedium,
                    ),
                    const Icon(Icons.add),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
