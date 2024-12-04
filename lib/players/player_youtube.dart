import 'package:SindanoShow/provider/playerprovider.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayerYoutube extends StatefulWidget {
  final String? videoId, videoUrl, vUploadType, videoThumb;
  const PlayerYoutube(
      this.videoId, this.videoUrl, this.vUploadType, this.videoThumb,
      {Key? key})
      : super(key: key);

  @override
  State<PlayerYoutube> createState() => PlayerYoutubeState();
}

class PlayerYoutubeState extends State<PlayerYoutube> {
  YoutubePlayerController? controller;
  bool fullScreen = false;
  late PlayerProvider playerProvider;
  int? playerCPosition, videoDuration;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    _initPlayer();
  }

  _initPlayer() async {
    controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );
    debugPrint("videoUrl :===> ${widget.videoUrl}");
    var videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl ?? "");
    debugPrint("videoId :====> $videoId");
    controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: black,
        body: Stack(
          children: [
            _buildPlayer(),
            if (!kIsWeb)
              Positioned(
                top: 15,
                left: 15,
                child: SafeArea(
                  child: InkWell(
                    onTap: onBackPressed,
                    focusColor: gray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    child: Utils.buildBackBtnDesign(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    if (controller == null) {
      return Utils.pageLoader();
    } else {
      return YoutubePlayerScaffold(
        backgroundColor: black,
        controller: controller!,
        autoFullScreen: true,
        defaultOrientations: const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        builder: (context, player) {
          return Scaffold(
            backgroundColor: black,
            body: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return player;
                },
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    controller?.close();
    if (!(kIsWeb) || !(Constant.isTV)) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  Future<bool> onBackPressed() async {
    if (!(kIsWeb) || !(Constant.isTV)) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    debugPrint("onBackPressed playerCPosition :===> $playerCPosition");
    debugPrint("onBackPressed videoDuration :===> $videoDuration");
    if (!mounted) return Future.value(false);
    Navigator.pop(context, false);
    return Future.value(true);
  }
}
