import 'models.dart';

class MenuService {
  Menu? firstMenu;

  void addMenu(Menu menu) {
    if (firstMenu == null) {
      firstMenu = menu;
    } else {
      Menu lastMenu = getLastMenu();
      lastMenu.nextMenu = menu;
    }
  }

  void deleteMenu(String menuId) {
    if (firstMenu != null) {
      if (firstMenu!.id == menuId) {
        firstMenu = firstMenu!.nextMenu;
      } else {
        Menu currentMenu = firstMenu!;
        while (currentMenu.nextMenu != null &&
            currentMenu.nextMenu!.id != menuId) {
          currentMenu = currentMenu.nextMenu!;
        }
        if (currentMenu.nextMenu != null) {
          currentMenu.nextMenu = currentMenu.nextMenu!.nextMenu;
        }
      }
    }
  }

  void showAllMenus() {
    Menu? currentMenu = firstMenu;
    while (currentMenu != null) {
      print("Menu Name: ${currentMenu.name}, Price: ${currentMenu.price}");
      currentMenu = currentMenu.nextMenu;
    }
  }

  Menu getLastMenu() {
    Menu currentMenu = firstMenu!;
    while (currentMenu.nextMenu != null) {
      currentMenu = currentMenu.nextMenu!;
    }
    return currentMenu;
  }
}
