import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:eac/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../riverpod/general_riverpod.dart';
import "config.dart" as config;
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'log_sink.dart';

class JoinChannelVideo extends ConsumerStatefulWidget {
  /// Construct the [JoinChannelVideo]
  const JoinChannelVideo({Key? key}) : super(key: key);

  @override
  State createState() => State();
}

class State extends ConsumerState<JoinChannelVideo> {
  late final RtcEngine _engine;

  bool isJoined = false;
  bool cameraOn=true;
  bool micOn=true;
  List<int> remoteUid = [];
  bool _isRenderSurfaceView = false;

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
  }

  Future<void> _initEngine() async {
    print("room :: ${ref.read(roomProvider)?.id??''}");
    var url = Uri.parse('https://asia-southeast1-asthma-care.cloudfunctions.net/generateAgoraToken?channelName=${ref.read(roomProvider)?.id??''}&userId=0');


    Map<String, dynamic> data = {
    };

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Request was successful, and you can handle the response here
      String token=json.decode(response.body)['token'];
      _engine = await RtcEngine.createWithContext(RtcEngineContext(config.appId));
      print('done');
      _addListeners();

      await _engine.enableVideo();
      await _engine.startPreview();
      await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      await _engine.setClientRole(ClientRole.Broadcaster);
      await _joinChannel(token);
    }
  }

  void _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      warning: (warningCode) {
        logSink.log('warning $warningCode');
      },
      error: (errorCode) {
        logSink.log('error $errorCode');
      },
      joinChannelSuccess: (
          channel, uid, elapsed) {
        logSink.log('joinChannelSuccess $channel $uid $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      userJoined: (uid, elapsed) {
        logSink.log('userJoined  $uid $elapsed');
        setState(() {
          remoteUid.add(uid);
        });
      },
      userOffline: (uid, reason) {
        logSink.log('userOffline  $uid $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });
      },
      leaveChannel: (stats) {
        logSink.log('leaveChannel ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
    ));
  }

  _joinChannel(String token) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _engine.joinChannel(token, ref.read(roomProvider)?.id??'', null, config.uid);
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _renderVideo(),
          ],
        ),
      ],
    );
  }

  _renderVideo() {
    return Expanded(
      child: Stack(
        children: [
          if(!remoteUid.isEmpty)
          Container(
            child: rtc_remote_view.SurfaceView(
              uid: remoteUid.first,
              channelId: ref.read(roomProvider)?.id??'',
            )
          ),
          if(!remoteUid.isEmpty)
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 120,
              height: 120,
              child: const rtc_local_view.SurfaceView(
                zOrderMediaOverlay: true,
                zOrderOnTop: true,
              ),
            ),
          ),
          if(remoteUid.isEmpty)
            Container(
                child: const rtc_local_view.SurfaceView(
                  zOrderMediaOverlay: true,
                  zOrderOnTop: true,
                )
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child:   Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ClipOval(
        child: InkWell(
          onTap: ()async{
              setState(() {
                micOn=!micOn;
              });
              await _engine.enableLocalAudio(micOn);
          },
          child: Container(
              width: 60.0,
              height: 60.0,
              decoration: new BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: Icon(micOn?Icons.mic_none:Icons.mic_off_outlined, color: Colors.white,size: 40),
          ),
        ),
      ),
      SizedBox(width: 30,),
      ClipOval(
        child: InkWell(
          onTap: ()async{
              cameraOn=!cameraOn;
              if(cameraOn){
                await _engine.enableVideo();
              }else{
                await _engine.disableVideo();
              }

          },
          child: Container(
              width: 60.0,
              height: 60.0,
              decoration: new BoxDecoration(
                color: Colors.black12,
                border: Border.all(color: Colors.white),
                shape: BoxShape.circle,
              ),
              child: Icon(cameraOn?Icons.video_call_outlined:Icons.videocam_off_outlined, color: Colors.white,size: 40,),
          ),
        ),
      )
    ],
  ),
            ),
),

        ],
      ),
    );
  }
}

