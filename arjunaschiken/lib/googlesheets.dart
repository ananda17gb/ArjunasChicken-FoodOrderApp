import 'package:arjunaschiken/ordersheetscolumn.dart';
import 'package:gsheets/gsheets.dart';

class Order {
  static String _sheetId = "1gUx7u1OzxSPPKRMwtZoiaqqkLqRGvJsVlPrz6BHMVic";
  static const _sheetCredentials = r'''
  {
  "type": "service_account",
  "project_id": "arjunaschicken",
  "private_key_id": "ffe60540d9a49ec1895d4d49c1b3f3c6a64d4e96",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCz430isAtnopuh\nW0WeMAKoyxp2/88nSkzYsgvJ8EoGaqXuKOr6GllAWwvdSQ9t1wn6XIhj2+eo4HKN\n+csoanhccvF1xmbSfkTSMvN894spe68oUYF8qcsTeH3mudqejkMim5EgU66w2/58\niyPF7pL3oDkMHAt8VcPhGtxCTFcC+nhk4XnENL6t8uOIaTqsw2im10Svob3gg685\niB3SDYyqSxuANkwkojUHbxDPaso+gv9DTJtC1WFrTmri2qRJg4qr6Bmgk+tH1jss\nLETOe7ehF+2aN8m4C+rKHzNJQXHNUp2gog4wS17OulK2NLtLN5jqecRhqSZsT9Qj\nARjqpFwHAgMBAAECggEAKsRx8rZB7+Cj+Ye2lHY7m5+16gbFXET44ifqT5dWMhJW\n4rlNrCppf7hlqLV++pE+aQxozLzyZZ7+/SwfFbvCY9BcAbEqru6gNA0zAEnmBvXF\n3eMK0vWXN0jVPe5/wGR4J5kutq3OgXO8HCYEWkFvJXotNejQ/j1xtWnqZcS6hxVZ\nI/pOl0DcCVDiswgo3bYLUZjhOUUTZElwQboL5/qJMAvZDsnP+pGi0VD5CCqzGcZN\nYIp4gEizrWkRaPEL4NUpWd0xl11ABawChkzOa/YIICgXKaxe4bYj4ywoRQ6uq5PB\n4KeVChWY6x3niMd/ew0Baoi6eqHwfn0Rmv0cB/UPcQKBgQDjvsHZ/xmzkByDPy5p\ntZP0l9TXttKJ6pJZ5r7SONLUYZG+zDf4Z+MMIKPVJimobgiWPL5nJTZRn7psn4Ew\n72Ga1AR4OuQfO+od7r6jY9i9lNFXpY9m3v/JIDWo33dg0oXm8g394QH9AsG7K8j2\nXgMDZzMKOQ9a+ahGJOvLnO6JLwKBgQDKNMvvdsZwcGrOkT71WCRQKhVSy8kYsmrG\n4v1ioiTMlRMvR4XhcSx/Ma+9T2KhBrEBaz4fK9BR/a2cZ30O1Wy1QKfywC/uLGu9\nxmbmEOdK2VJpCgqMQDI9aMguElTwficSlgpZqO+oAgvFlWEidIAsCb09DXeu82SR\nITc/H4X0qQKBgHS3h3ukfFSFL8ensq6kSz5YLdGbtYzO9dAzLGpqisojcuE4ohqh\niz/k3nHXjBPwyF/Oo7oS3SK53H3cxQYCOKBzthK0A8NqHlLWz0bHXgXS5fKoO7T5\n5lb6NeXlGLY7TjqMpNUO4sj7B7RX/Tcd+SdeVU8Q7SivuCiytVF1jN4rAoGBALFx\naXEnsvYiwKerMCuPALbUZ0f0CvHASBFmSmNO1KovO9mmkycF8L1htc2UJ4IVZClR\nmf8yrKn2ym5RJp5oze+04G0XGDiTBK1RuSS1urKlSTtiE2WGRFA9bkV30tAEdHdL\n8aNCq6SsvvXRo57fy0ZZ+ZXlBp0he6QcGOYs3JmZAoGBAKrc1TosCGN8rMRKTMuU\nOaN4H0oGXOZtuy3MYy9dRrG2kWHhI9Nfn/7gDgjh1CUlOv4RoJKO/b1JKLToHiL8\nPdHuQL6+VolovtYDIX5jdxuTMUb+9VRlxignsIjyNvnsgl9fQgryn+eTfK/lZDxE\nCUtz/o+Gaq3nU4KWoi87cirI\n-----END PRIVATE KEY-----\n",
  "client_email": "arjunaschickensheets@arjunaschicken.iam.gserviceaccount.com",
  "client_id": "104821554518604700468",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/arjunaschickensheets%40arjunaschicken.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
  }
''';

  static Worksheet? _userSheet;
  static final _gsheets = GSheets(_sheetCredentials);

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_sheetId);

      _userSheet = await _getWorkSheet(spreadsheet, title: "Orders");
      final firstRow = SheetsColumn.getColumns();
      _userSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print(e);
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    _userSheet!.values.map.appendRows(rowList);
  }
}
