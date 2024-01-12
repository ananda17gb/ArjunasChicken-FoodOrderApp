class RelationElement {
  RelationElement? nextRelation;
  MenuElement? nextMenu;
}

class RelationList {
  RelationElement? firstRelation;
}

class MenuInfoType {
  String idMenu;
  String nameMenu;
  int priceMenu;

  MenuInfoType(this.idMenu, this.nameMenu, this.priceMenu);
}

class MenuElement {
  late MenuInfoType infoMenu;
  MenuElement? nextMenu;

  MenuElement(MenuInfoType x);
}

class MenuList {
  MenuElement? firstMenu;
}

class CustomerInfoType {
  late String idCustomer;
  late String nameCustomer;

  CustomerInfoType(String s, String t);
}

class CustomerElement {
  late CustomerInfoType infoCustomer;
  CustomerElement? nextCustomer;
  RelationList menu = RelationList();

  CustomerElement(CustomerInfoType x);
}

class CustomerList {
  CustomerElement? firstCustomer;
}

CustomerList createListCustomer() {
  return CustomerList()..firstCustomer = null;
}

MenuList createListMenu() {
  return MenuList()..firstMenu = null;
}

CustomerElement createElementCustomer(CustomerInfoType x) {
  return CustomerElement(x)
    ..nextCustomer = null
    ..menu.firstRelation = null;
}

MenuElement createElementMenu(MenuInfoType x) {
  return MenuElement(x)..nextMenu = null;
}

RelationElement createElementRelation() {
  return RelationElement()
    ..nextMenu = null
    ..nextRelation = null;
}

void insertLastCustomer(CustomerList C, CustomerElement P) {
  if (C.firstCustomer == null) {
    C.firstCustomer = P;
  } else {
    CustomerElement? c = C.firstCustomer;
    while (c!.nextCustomer != null) {
      c = c.nextCustomer;
    }
    c.nextCustomer = P;
  }
}

void insertLastMenu(MenuList M, MenuElement P) {
  if (M.firstMenu == null) {
    M.firstMenu = P;
  } else {
    MenuElement? m = M.firstMenu;
    while (m!.nextMenu != null) {
      m = m.nextMenu;
    }
    m.nextMenu = P;
  }
}

void orderMenu(
    CustomerList C, MenuList M, String nameCustomer, String nameMenu) {
  CustomerElement? c = searchCustomer(C, nameCustomer);
  MenuElement? m = searchMenu(M, nameMenu);
  if (c != null && m != null) {
    RelationElement r = createElementRelation();
    r.nextMenu = m;
    if (c.menu.firstRelation == null) {
      c.menu.firstRelation = r;
    } else {
      RelationElement? re = c.menu.firstRelation;
      while (re!.nextRelation != null) {
        re = re.nextRelation;
      }
      re.nextRelation = r;
    }
  }
}

void deleteCustomer(CustomerList C, String nameCustomer) {
  CustomerElement? c = searchCustomer(C, nameCustomer);

  if (c != null) {
    if (c == C.firstCustomer) {
      CustomerElement? p = c.nextCustomer;
      c.nextCustomer = null;
      C.firstCustomer = p;
    } else if (c.nextCustomer == null) {
      CustomerElement? p = C.firstCustomer;
      while (p!.nextCustomer != c) {
        p = p.nextCustomer;
      }
      p.nextCustomer = null;
    } else {
      CustomerElement? p = C.firstCustomer;
      while (p!.nextCustomer != c) {
        p = p.nextCustomer;
      }
      p.nextCustomer = c.nextCustomer;
      c.nextCustomer = null;
    }
  }
}

void deleteOrder(
    CustomerList C, RelationList R, String nameMenu, String nameCustomer) {
  CustomerElement? c = searchCustomer(C, nameCustomer);
  if (c != null && c.menu.firstRelation != null) {
    RelationElement? r = c.menu.firstRelation;
    RelationElement? r1 = c.menu.firstRelation;
    while (
        r!.nextRelation != null && r.nextMenu!.infoMenu.nameMenu != nameMenu) {
      r1 = r;
      r = r.nextRelation;
    }
    if (r.nextRelation != null && r.nextMenu!.infoMenu.nameMenu == nameMenu) {
      if (r == c.menu.firstRelation && r.nextRelation == null) {
        c.menu.firstRelation = null;
        r.nextMenu = null;
      } else if (r == c.menu.firstRelation && r.nextRelation != null) {
        c.menu.firstRelation = r.nextRelation;
        r.nextRelation = null;
        r.nextMenu = null;
      } else if (r.nextRelation == null) {
        r1!.nextRelation = null;
        r.nextMenu = null;
      } else {
        r1!.nextRelation = r.nextRelation;
        r.nextRelation = null;
        r.nextMenu = null;
      }
    }
  }
}

void deleteAllOrder(CustomerList C, RelationList R, String nameCustomer) {
  CustomerElement? c = searchCustomer(C, nameCustomer);
  RelationElement? p;
  while (c!.menu.firstRelation != null) {
    p = c.menu.firstRelation;
    c.menu.firstRelation = c.menu.firstRelation!.nextRelation;
    p = null;
  }
}

CustomerElement? searchCustomer(CustomerList C, String nameCustomer) {
  CustomerElement? c = C.firstCustomer;
  while (c != null && c.infoCustomer.nameCustomer != nameCustomer) {
    c = c.nextCustomer;
  }
  return c;
}

MenuElement? searchMenu(MenuList M, String nameMenu) {
  MenuElement? m = M.firstMenu;
  while (m!.infoMenu.nameMenu != nameMenu && m.nextMenu != null) {
    m = m.nextMenu;
  }
  if (m.infoMenu.nameMenu == nameMenu) {
    return m;
  }
  return null;
}

RelationElement? searchRelation(RelationList R, MenuElement? P) {
  RelationElement? r = R.firstRelation;
  while (r != null && (r.nextMenu != P || P == null)) {
    r = r.nextRelation;
  }
  return r;
}

void showCustomerBasedOnMenu(CustomerList C, MenuList M, String nameMenu) {
  RelationElement? r;
  CustomerElement? c = C.firstCustomer;
  int i = 1;
  while (c != null) {
    r = searchRelation(c.menu, searchMenu(M, nameMenu));
    if (r != null) {
      print("$i. Customer Name: ${c.infoCustomer.nameCustomer}");
      print("   Customer ID\t: ${c.infoCustomer.idCustomer}");
      i++;
    } else {
      print("No customer ordered this menu");
    }
    c = c.nextCustomer;
  }
}

void showMenuBasedOnCustomer(CustomerList C, String nameCustomer) {
  CustomerElement? c = searchCustomer(C, nameCustomer);
  int i = 1;
  if (c != null) {
    if (c.menu.firstRelation != null) {
      RelationElement? r = c.menu.firstRelation;
      while (r != null) {
        print("$i. Menu Name\t: ${r.nextMenu!.infoMenu.nameMenu}");
        print("   Menu Price\t: ${r.nextMenu!.infoMenu.priceMenu}");
        r = r.nextRelation;
        i++;
      }
    }
  } else {
    print("There is no customer with that name");
  }
}

void showAllOrder(CustomerList C) {
  CustomerElement? c = C.firstCustomer;
  while (c != null) {
    if (c.menu.firstRelation == null) {
      print("This person hasn't ordered anything");
    } else {
      RelationElement? r = c.menu.firstRelation;
      int i = 1;
      while (r != null) {
        print("$i. Customer ID\t: ${c.infoCustomer.idCustomer}");
        print("   Customer Name: ${c.infoCustomer.nameCustomer}");
        print("   Menu ID\t: ${r.nextMenu!.infoMenu.idMenu}");
        print("   Menu Name\t: ${r.nextMenu!.infoMenu.nameMenu}");
        print("   Price\t: ${r.nextMenu!.infoMenu.priceMenu}");

        r = r.nextRelation;
        i++;
      }
    }
    c = c.nextCustomer;
  }
}

void showAllCustomer(CustomerList C) {
  CustomerElement? c = C.firstCustomer;
  int i = 1;
  while (c != null) {
    print("$i. Customer Name: ${c.infoCustomer.nameCustomer}");
    print("   Customer ID\t: ${c.infoCustomer.idCustomer}");
    i++;
    c = c.nextCustomer;
  }
}

void showAllMenu(MenuList M) {
  MenuElement? m = M.firstMenu;
  int i = 1;
  while (m != null) {
    print("$i. Menu ID\t: ${m.infoMenu.idMenu}");
    print("   Menu Name\t: ${m.infoMenu.nameMenu}");
    print("   Price\t: ${m.infoMenu.priceMenu}");
    i++;
    m = m.nextMenu;
  }
}

void totalPrice(CustomerList C, String nameCustomer) {
  CustomerElement? c = searchCustomer(C, nameCustomer);
  int i = 0;
  int total = 0;
  if (c != null) {
    if (c.menu.firstRelation != null) {
      RelationElement? r = c.menu.firstRelation;
      while (r != null) {
        total = total + r.nextMenu!.infoMenu.priceMenu;
        r = r.nextRelation;
        i++;
      }
      print("Total Menu : $i");
      print("Total Price : $total");
    }
  } else {
    print("There is no customer with that name");
  }
}
