import 'package:example/features/auth/auth_provider.dart';
import 'package:example/features/auth/presentation/screens/auth_screen.dart';
import 'package:example/features/common/presentation/screens/error_screen.dart';
import 'package:example/features/common/presentation/utils/extensions/ui_extension.dart';
import 'package:example/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:example/features/departments/presentation/screens/departments_create_screen.dart';
import 'package:example/features/departments/presentation/screens/departments_edit_screen.dart';
import 'package:example/features/departments/presentation/screens/departments_view_screen.dart';
import 'package:example/features/organization/presentation/screens/organization_create_screen.dart';
import 'package:example/features/organization/presentation/screens/organizations_list_screen.dart';
import 'package:example/flavors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main router for the Example app
///
/// ! Pay attention to the order of routes.
/// Create:  example/create
/// View:    example/:eid
/// Edit:    example/:eid/edit
/// where :edit means example entity id.
///
/// ! Note about parameters
/// Router keeps parameters in global map. It means that if you create route
/// organization/:id and organization/:id/department/:id. Department id will
///  override organization id. So use :oid and :did instead of :id
/// Also router does not provide option to set regex for parameters.
/// If you put - example/:eid before - example/create for route - example/create
/// will be called route - example/:eid
///
///
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: OrganizationsListScreen.routeName,
      builder: (context, state) => const OrganizationsListScreen(),
      routes: [
        GoRoute(
          path: OrganizationsCreateScreen.routePath,
          name: OrganizationsCreateScreen.routeName,
          builder: (context, state) => const OrganizationsCreateScreen(),
        ),
        GoRoute(
          path: '${DashboardScreen.routePath}/:oid',
          name: DashboardScreen.routeName,
          builder: (context, state) => DashboardScreen(
            title: F.title,
            organizationId: state.pathParameters['oid']!,
          ),
          routes: [
            GoRoute(
              path: DepartmentsCreateScreen.routePath,
              name: DepartmentsCreateScreen.routeName,
              builder: (context, state) => const DepartmentsCreateScreen(),
            ),
            GoRoute(
              path: DepartmentsViewScreen.routePath,
              name: DepartmentsViewScreen.routeName,
              builder: (context, state) => DepartmentsViewScreen(
                id: state.pathParameters['did']!,
              ),
            ),
            GoRoute(
              path: DepartmentsEditScreen.routePath,
              name: DepartmentsEditScreen.routeName,
              builder: (context, state) => DepartmentsEditScreen(
                id: state.pathParameters['did']!,
              ),
            ),
          ],
        ),

        // GoRoute(
        //   path: UserOrganizationsPage.route,
        //   name: UserOrganizationsPage.route,
        //   builder: (context, state) => const UserOrganizationsPage(),
        // )
      ],
    ),
    GoRoute(
      path: '/${AuthScreen.route}',
      name: AuthScreen.route,
      builder: (context, state) => const AuthScreen(),
    ),
  ],
  observers: [
    routeObserver,
  ],
  redirect: (context, state) {
    final loggedIn = authStateListenable.value;
    final goingToLogin = state.matchedLocation.contains('/${AuthScreen.route}');

    if (!loggedIn && !goingToLogin) {
      return '/${AuthScreen.route}';
    }
    if (loggedIn && goingToLogin) return '/';

    return null;
  },
  refreshListenable: authStateListenable,
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => ErrorScreen(message: context.tr.somethingWentWrong),
);

/// Route observer to use with RouteAware
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
