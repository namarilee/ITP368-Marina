// import 'package:flutter/material.dart';

import 'package:flutter_sound/flutter_sound.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

class SoundState
{
  FlutterSoundPlayer player;
  FlutterSoundRecorder recorder;
  bool isRecording;
  double currentPosition = 0; // not used yet
  double totalDuration = 0;   // not used yet

  String? filePath; // set when recording is successful

  SoundState
  ( { required this.player, required this.recorder,
      required this.isRecording,
      required this.filePath,
    }
  );

  SoundState.init() 
  : player= FlutterSoundPlayer(),
    recorder = FlutterSoundRecorder(),
    isRecording = false 
  { // await
    recorder.openRecorder(); // openAudioSession();

    player.openPlayer();

    // note .. if you hit 'record' before it is open. splat.
    // This should have a wait with init_status flag and all ...
  }

  void dispose()
  { recorder.closeRecorder();
    //player.dispose();
    //recorder.dispose();
  }
}

class SoundCubit extends Cubit<SoundState>
{
  SoundCubit() :super( SoundState.init() );

  Future<void> startRecording() async
  { 
    /*
    final bool hasPermish = await state.recorder.hasPermission();
    if (!hasPermish)
    { print("no permission to record");
      return;
    }
    */

    final PermissionStatus hasPermish = await Permission.microphone.status;
    if ( hasPermish.isDenied)
    {
       print("no mic, sorry");
       return;
    }

    // not here.  do this only once in init() sequence
    // await state.recorder.openRecorder(); // openAudioSession();

    final dir = await getApplicationDocumentsDirectory();
    final filename = "bob.aac";

    // path used here to launch the recorder.  state.filePath only gets
    // set when recording is successful
    final path = "${dir.path}/$filename";
    // final path = "yap.aac";

    /*
    const config = RecordConfig
    ( encoder: AudioEncoder.aacLc,
      sampleRate: 44100,
      bitRate: 128000,
    );
    */

    await state.recorder.startRecorder(toFile: path);
    emit( SoundState
          ( player:state.player, 
            recorder: state.recorder,
            isRecording: true,
            filePath: state.filePath,
          ) );
  }

  void stopRecording() async
  {
    final path = await state.recorder.stopRecorder();
    print("sound file path = $path");
    emit( SoundState
          ( player:state.player, 
            recorder: state.recorder,
            isRecording: false,
            filePath: path,
          ) );
  }

  Future<void> playRecording() async
  {
    if (state.filePath != null )
    {
      // await state.player.setFilePath( state.filePath! );


      state.player.startPlayer( fromURI: state.filePath );
      // state.player.startPlayer( fromURI: "yap.aac");

    }
  }

  Future<void> stopPlaying() async
  {
    await state.player.stopPlayer();
  }

}