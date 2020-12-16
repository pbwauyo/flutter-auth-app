import 'package:auth_app/models/happr_contact.dart';
import 'package:auth_app/widgets/contact_avatar.dart';
import 'package:flutter/material.dart';

import 'custom_text_view.dart';

class FriendsWidget extends StatelessWidget {
  final List<HapprContact> contacts;
  final double size;

  FriendsWidget({ this.size = 24, this.contacts});

  @override
  Widget build(BuildContext context) {
    double marginRight = size/2;

    return GestureDetector(
      onTap: (){
        showModalBottomSheet(
          context: context, 
          builder: (context){
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: contacts.map(
                (contact) => Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6, top: 5, ),
                  child: ListTile(
                    leading: ContactAvatar(
                      initials: contact.initials,
                      size: 30,
                    ),
                    title: CustomTextView(
                      fontSize: 13,
                      text: contact.displayName
                    ),
                  )
                )
              ).toList(),
            );
          }
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: getContactsSublist().map(
          (contact) => 
          Center(
            child: Container(
              width: size + 10,
              height: size + 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((size+10)/2)
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 4),
              child: ContactAvatar(
                size: size,
                initials: contact.initials,
                fontSize: 10,
              ),
            ),
          )
        ).toList()
      ),
    );
  }

  List<HapprContact> getContactsSublist(){
    if(contacts.length > 4){
      return contacts.sublist(0, 4);
    }else{
      return contacts;
    }
  }
}