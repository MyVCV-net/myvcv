import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myvcv/models/models.dart';
import 'package:myvcv/screens/screens.dart';

class JobCard extends StatelessWidget {
  const JobCard({
    Key? key,
    required this.jobs,
  }) : super(key: key);

  final JobModel jobs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(JobDesc(
          selectedJobId: jobs.jobId,
        ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: CachedNetworkImage(
                      imageUrl: jobs.userImageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      jobs.username,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(jobs.jobTitle),
              ),
              Text(
                  "${jobs.city}${jobs.country != '' ? '/' : ''}${jobs.country}",
                  style: TextStyle(
                      color:
                          Theme.of(context).iconTheme.color!.withOpacity(0.5))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                child: SizedBox(
                  height: 35,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Card(
                          color: Colors.white,
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("${jobs.experianceYears} Years",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10)),
                          ))),
                      Card(
                          color: Colors.white,
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("${jobs.salary} ${jobs.currency}/M",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10)),
                          ))),
                    ],
                  ),
                ),
              ),
              Text("From: ${jobs.publishDate} - To: ${jobs.endDate}",
                  style: TextStyle(
                    fontSize: 8,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
