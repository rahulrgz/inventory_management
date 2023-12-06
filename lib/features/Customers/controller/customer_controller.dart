import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/features/Customers/repository/customer_repository.dart';
import 'package:inventory_management_shop/models/customer_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/utils.dart';

final customerControllerProvider =
    StateNotifierProvider<CustomerController, bool>((ref) {
  final customerRepository = ref.watch(customerRepositoryProvider);
  return CustomerController(customerRepository: customerRepository, ref: ref);
});

final getCustomerProvider =
    StreamProvider.family.autoDispose((ref, String shopId) {
  return ref.watch(customerControllerProvider.notifier).getCustomer(shopId);
});

class CustomerController extends StateNotifier<bool> {
  final CustomerRepository _customerRepository;
  final Ref _ref;
  CustomerController({
    required CustomerRepository customerRepository,
    required Ref ref,
  })  : _customerRepository = customerRepository,
        _ref = ref,
        super(false);

  addCustomers(
      {required BuildContext context,
      required CustomerModel customerModel}) async {
    state = true;
    final res = await _customerRepository.addCustomers(
      customerModel: customerModel,
    );
    state = false;
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, "Customer Profile Added Successfully");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<CustomerModel>> getCustomer(String shopId) {
    return _customerRepository.getCustomers(shopId);
  }

  deleteCustomer(CustomerModel customerModel, BuildContext context) async {
    var delete = await _customerRepository.deleteCustomer(customerModel);
    delete.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, "Customer Details deleted successfully"));
  }
}
