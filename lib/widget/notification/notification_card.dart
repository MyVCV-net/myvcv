import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String imageUrl;
  final String username;
  final String subtitle;
  final String time;

  const NotificationCard({
    Key? key,
    required this.imageUrl,
    required this.username,
    required this.subtitle,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Center(
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        title: Text(username),
        subtitle: Text("$subtitle \n$time"),
        isThreeLine: true,
      ),
    ));
  }
}
