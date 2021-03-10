import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';
import 'package:time_tracker/sign_in/show_exception_alert_dialog.dart';

import 'job_list_tile.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure you want to logout',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () => _confirmSignOut(context),
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditJobPage.show(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final jobs = snapshot.data;
            final children = jobs.map((job) => JobListTile(
              job: job,
              onTap: () => EditJobPage.show(context,job: job),
            )).toList();
            return ListView(
              children: children,
            );
          }
          if(snapshot.hasError){
            return Center(child: Text('Error occurred'),);
          }
          return Center(child: CircularProgressIndicator(),);
        },

    );
  }
}
