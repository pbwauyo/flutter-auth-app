import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';

class ContactsListController extends GetxController {
  final contacts = <Contact>[].obs;

  @override
  void onReady() {
    super.onReady();
    _loadContacts();
  }

  Future<void> _loadContacts() async{
    final fetchedContacts = await ContactsService.getContacts();
    fetchedContacts.forEach((contact) { 
      contacts.add(contact);
    });
  }
}