import 'package:chewie/chewie.dart';
import 'package:Sindano/provider/playerprovider.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/widget/mytext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class PlayerVideo extends StatefulWidget {
  final String? videoId, videoUrl, vUploadType, videoThumb;
  const PlayerVideo(
      this.videoId, this.videoUrl, this.vUploadType, this.videoThumb,
      {Key? key})
      : super(key: key);

  @override
  State<PlayerVideo> createState() => _PlayerVideoState();
}

class _PlayerVideoState extends State<PlayerVideo> {
  late PlayerProvider playerProvider;
  int? playerCPosition, videoDuration;
  ChewieController? _chewieController;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    debugPrint("videoUrl ========> ${widget.videoUrl}");
    debugPrint("vUploadType ========> ${widget.vUploadType}");
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playerInit();
    });
    super.initState();
  }

  _playerInit() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl ?? ""),
    );
    await Future.wait([_videoPlayerController.initialize()]);

    /* Chewie Controller */
    _setupController();

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  _setupController() async {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      startAt: Duration.zero,
      autoPlay: true,
      autoInitialize: true,
      looping: false,
      fullScreenByDefault: false,
      allowFullScreen: true,
      hideControlsTimer: const Duration(seconds: 1),
      showControls: true,
      allowedScreenSleep: false,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      cupertinoProgressColors: ChewieProgressColors(
        playedColor: colorPrimary,
        handleColor: colorAccent,
        backgroundColor: grayDark,
        bufferedColor: whiteTransparent,
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: colorPrimary,
        handleColor: colorAccent,
        backgroundColor: grayDark,
        bufferedColor: whiteTransparent,
      ),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: MyText(
            color: white,
            text: errorMessage,
            textalign: TextAlign.center,
            fontsizeNormal: 14,
            fontweight: FontWeight.w600,
            fontsizeWeb: 16,
            multilanguage: false,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            fontstyle: FontStyle.normal,
          ),
        );
      },
    );
    _chewieController?.addListener(() {
      playerCPosition =
          (_chewieController?.videoPlayerController.value.position)
                  ?.inMilliseconds ??
              0;
      videoDuration = (_chewieController?.videoPlayerController.value.duration)
              ?.inMilliseconds ??
          0;
      debugPrint("playerCPosition :===> $playerCPosition");
      debugPrint("videoDuration :=====> $videoDuration");
      if (!(_chewieController?.isFullScreen ?? false)) {
        if (kIsWeb) {
          onBackPressed();
        }
        if (!(kIsWeb) || !(Constant.isTV)) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }
      }
    });
  }

  @override
  void dispose() {
    if (_chewieController != null) {
      _chewieController?.removeListener(() {});
      _chewieController?.videoPlayerController.dispose();
    }
    if (!(kIsWeb) || !(Constant.isTV)) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    playerProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: black,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: _buildPage(),
              ),
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
      ),
    );
  }

  Widget _buildPage() {
    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      return _buildPlayer();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: Utils.pageLoader(),
          ),
          const SizedBox(height: 20),
          MyText(
            color: white,
            text: "Loading...",
            textalign: TextAlign.center,
            fontsizeNormal: 14,
            fontweight: FontWeight.w600,
            fontsizeWeb: 16,
            multilanguage: false,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            fontstyle: FontStyle.normal,
          ),
        ],
      );
    }
  }

  Widget _buildPlayer() {
    return AspectRatio(
      aspectRatio: _chewieController?.aspectRatio ??
          (_chewieController?.videoPlayerController.value.aspectRatio ??
              16 / 9),
      child: Chewie(
        controller: _chewieController!,
      ),
    );
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
