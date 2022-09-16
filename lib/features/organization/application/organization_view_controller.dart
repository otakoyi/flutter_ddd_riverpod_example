import 'package:example/features/organization/domain/entities/organization_entity.dart';
import 'package:example/features/organization/infrastructure/repositories/organization_repository.dart';
import 'package:example/features/organization/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
class OrganizationViewController
    extends StateNotifier<AsyncValue<OrganizationEntity>> {
  ///
  OrganizationViewController(
    this.repository,
    this.id,
    this._read,
  ) : super(const AsyncValue.loading()) {
    _get();
  }

  ///
  final OrganizationRepository repository;

  final Reader _read;

  ///
  final String id;

  Future<void> _get() async {
    state = const AsyncValue.loading();
    final res = await repository.getOrganizationById(id);
    _read(currentOrganizationProvider.notifier).state =
        res.fold((l) => null, (r) => r);
    state = res.fold((l) => AsyncValue.error(l.toString()), AsyncValue.data);
  }
}
