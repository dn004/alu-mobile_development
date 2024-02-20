import 'package:flutter/material.dart';

class VerticalCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3, 
      itemBuilder: (context, index) {
        return CardWidget(index + 1); // Pass the index as a parameter to CardWidget
      },
    );
  }
}

class CardWidget extends StatelessWidget {
  final int cardNumber;

  CardWidget(this.cardNumber);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      
      child: Container(
        height: 200, 
        child: ListTile(
          title: Text('Card $cardNumber'),
          subtitle: Text('Description for Card $cardNumber'),
        ),
      ),
    );
  }
}
