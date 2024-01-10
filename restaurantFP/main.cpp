#import "restaurantFP.h"

int main()
{
    system("Color 0A");
    cout << " ____    __    ____  _______  __        ______   ______   .___  ___.  _______\n";
    cout << " \\   \\  /  \\  /   / |   ____||  |      /      | /  __  \\  |   \\/   | |   ____|\n";
    cout << "  \\   \\/    \\/   /  |  |__   |  |     |  ,----'|  |  |  | |  \\  /  | |  |__   \n";
    cout << "   \\            /   |   __|  |  |     |  |     |  |  |  | |  |\\/|  | |   __|  \n";
    cout << "    \\    /\\    /    |  |____ |  `----.|  `----.|  `--'  | |  |  |  | |  |____ \n";
    cout << "     \\__/  \\__/     |_______||_______| \\______| \\______/  |__|  |__| |_______|\n";

    cout << endl;
     cout << R"(
                            ==(W{==========-      /===-
                              ||  (.--.)         /===-_---~~~~~~~~~------____
                              | \_,|**|,__      |===-~___                _,-' `
                 -==\\        `\ ' `--'   ),    `//~\\   ~~~~`---.___.-~~
             ______-==|        /`\_. .__/\ \    | |  \\           _-~`
       __--~~~  ,-/-==\\      (   | .  |~~~~|   | |   `\        ,'
    _-~       /'    |  \\     )__/==0==-\<>/   / /      \      /
  .'        /       |   \\      /~\___/~~\/  /' /        \   /'
 /  ____  /         |    \`\.__/-~~   \  |_/'  /          \/'
/-'~    ~~~~~---__  |     ~-/~         ( )   /'        _--~`
                  \_|      /        _) | ;  ),   __--~~
                    '~~--_/      _-~/- |/ \   '-~ \
                   {\__--_/}    / \\_>-|)<__\      \
                   /'   (_/  _-~  | |__>--<__|      |
                  |   _/) )-~     | |__>--<__|      |
                  / /~ ,_/       / /__>---<__/      |
                 o-o _//        /-~_>---<__-~      /
                 (^(~          /~_>---<__-      _-~
                ,/|           /__>--<__/     _-~
             ,//('(          |__>--<__|     /                  .----_
            ( ( '))          |__>--<__|    |                 /' _---_~\
         `-)) )) (           |__>--<__|    |               /'  /     ~\`\
        ,/,'//( (             \__>--<__\    \            /'  //        ||
      ,( ( ((, ))              ~-__>--<_~-_  ~--____---~' _/'/        /'
    `~/  )` ) ,/|                 ~-_~>--<_/-__       __-~ _/
  ._-~//( )/ )) `                    ~~-'_/_/ /~~~~~~~__--~
   ;'( ')/ ,)(                              ~~~~~~~~~~
  ' ') '( (/
    '   '  `
    )" << endl;
    cout << "======================================" << endl;
    cout << "=           Food Order App           =" << endl;
    cout << "=                                    =" << endl;
    cout << "=   made by Bryan D and Ananda AW    =" << endl;
    cout << "======================================" << endl;
    string menu, customer;
    customerList C;
    menuList M;
    relationList R;
    createListCustomer(C);
    createListMenu(M);
    int add;
    adr_customer P;
    adr_menu Q;
    menu_infotype q;
    customer_infotype p;
    string nameC, nameM;
    int answer = showDashboard();
    cout << endl;
    while (answer != 12){
        switch (answer){
        case 1:
            cout << "Enter the menu ID\t: ";
            cin >> q.id_menu;
            cout << "Enter the menu name\t: ";
            cin >> q.name_menu;
            cout << "Enter the menu price\t: ";
            cin >> q.price_menu;
            Q = createElementMenu(q);
            insertLastMenu(M,Q);
            cout << q.name_menu << " has been added to the list!" << endl;
            break;
        case 2:
            cout << "Enter customer ID\t: ";
            cin >> p.id_customer;
            cout << "Enter customer name\t: ";
            cin >> p.name_customer;
            P = createElementCustomer(p);
            insertLastCustomer(C,P);
            cout << "What do you want to order? ";
            cin >> menu;
            while (menu != "STOP"){
                orderMenu(C,M,p.name_customer,menu);
                cout << "What do you want to order (type STOP to stop ordering)? ";
                cin >> menu;
            }
            cout << p.name_customer << " orders have been added to the list!" << endl;
            break;
        case 3:
            cout << "Enter customer name: ";
            cin >> nameC;
            cout << "What do you want to order? ";
            cin >> menu;
            while (menu != "STOP"){
                orderMenu(C,M,nameC,menu);
                cout << "What do you want to order (type STOP to stop ordering)? ";
                cin >> menu;
            }
            break;
        case 4:
            cout << "Enter the customer name: ";
            cin >> nameC;
            deleteAllOrder(C,R,nameC);
            deleteCustomer(C,nameC);
            break;
        case 5:
            cout << "Enter the customer name: ";
            cin >> nameC;
            cout << "What do you want to cancel? enter the menu name (type STOP to stop): ";
            cin >> nameM;
            while (nameM != "STOP"){
                deleteOrder(C,R, nameM,nameC);
                cout << "What do you want to cancel? enter the menu name (type STOP to stop): ";
                cin >> nameM;
            }
            break;
        case 6:
            cout << "=================== MENUS ===================" << endl;
            showAllMenu(M);
            cout << "=============================================" << endl;
            break;
        case 7:
            cout << "================= CUSTOMERS =================" << endl;
            showAllCustomer(C);
            cout << "=============================================" << endl;
            break;
        case 8:
            cout << "=================== ORDERS ==================" << endl;
            showAllOrder(C);
            cout << "=============================================" << endl;
             break;
        case 9:
            cout << "Enter the customer name: ";
            cin >> nameC;
            cout << endl;
            cout << nameC << " orders:" << endl;
            if (C.first_customer == NULL){
                cout << "There is no customer in the list." << endl;
            }else {
                showMenuBasedOnCustomer(C, nameC);
            }
            break;
        case 10:
            cout << "Enter the menu name: ";
            cin >> nameM;
            cout << endl;
            cout << nameM << " is ordered by:" << endl;
            showCustomerBasedOnMenu(C,M,nameM);
            break;
        case 11:
            cout << "Enter customer name: ";
            cin >> nameC;
            cout << endl;
            cout << "===========RECEIPT==========="<< endl;
            showMenuBasedOnCustomer(C, nameC);
            totalPrice(C, nameC);

        break;
        ;
        }
        cout << endl;
        answer = showDashboard();
        cout << endl;
    }
    return 0;
}
