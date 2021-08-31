import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';

import 'list_items_builder.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key? key}) : super(key: key);

  Future<void> _delete(BuildContext context, Job job) async{
    try {
      final database = Provider.of<Database>(context, listen: false,);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
        showExceptionAlertDialog(
            context,
            title: "Operation failed",
            exception: e,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => EditJobPage.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => EditJobPage.show(
      //       context,
      //     database: Provider.of<Database>(context, listen: false),
      //   ),
      //   child: Icon(Icons.add),
      // ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red[900]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            child: JobListTile(
              job: job,
              onTap: () => JobEntriesPage.show(context, job),
            ),
          )
        );
      }
    );
  }
}
