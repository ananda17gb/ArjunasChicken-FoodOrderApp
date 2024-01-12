import 'models.dart';

class CustomerService {
  Customer? firstCustomer;

  void addCustomer(Customer customer) {
    if (firstCustomer == null) {
      firstCustomer = customer;
    } else {
      Customer lastCustomer = getLastCustomer();
      lastCustomer.nextCustomer = customer;
    }
  }

  void deleteCustomer(String customerId) {
    if (firstCustomer != null) {
      if (firstCustomer!.id == customerId) {
        firstCustomer = firstCustomer!.nextCustomer;
      } else {
        Customer currentCustomer = firstCustomer!;
        while (currentCustomer.nextCustomer != null &&
            currentCustomer.nextCustomer!.id != customerId) {
          currentCustomer = currentCustomer.nextCustomer!;
        }
        if (currentCustomer.nextCustomer != null) {
          currentCustomer.nextCustomer =
              currentCustomer.nextCustomer!.nextCustomer;
        }
      }
    }
  }

  void showAllCustomers() {
    Customer? currentCustomer = firstCustomer;
    while (currentCustomer != null) {
      print("Customer Name: ${currentCustomer.name}");
      Relation? currentRelation = currentCustomer.firstRelation;
      while (currentRelation != null) {
        print("  Menu Name: ${currentRelation.menu.name}");
        currentRelation = currentRelation.nextRelation;
      }
      currentCustomer = currentCustomer.nextCustomer;
    }
  }

  Customer getLastCustomer() {
    Customer currentCustomer = firstCustomer!;
    while (currentCustomer.nextCustomer != null) {
      currentCustomer = currentCustomer.nextCustomer!;
    }
    return currentCustomer;
  }
}
