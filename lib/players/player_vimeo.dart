import 'package:SindanoShow/provider/playerprovider.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class PlayerVimeo extends StatefulWidget {
  final String? videoId, videoUrl, vUploadType, videoThumb;
  const PlayerVimeo(
      this.videoId, this.videoUrl, this.vUploadType, this.videoThumb,
      {Key? key})
      : super(key: key);

  @override
  State<PlayerVimeo> createState() => PlayerVimeoState();
}

class PlayerVimeoState extends State<PlayerVimeo> {
  String? vUrl;
  late PlayerProvider playerProvider;
  int? playerCPosition, videoDuration;

  @override
  void initState() {
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    super.initState();
    vUrl = widget.videoUrl;
    if (!(vUrl ?? "").contains("https://vimeo.com/")) {
      vUrl = "https://vimeo.com/$vUrl";
    }
    debugPrint("vUrl===> $vUrl");
  }

  @override
  void dispose() {
    if (!(kIsWeb) || !(Constant.isTV)) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: black,
        body: Stack(
          children: [
            VimeoVideoPlayer(
              url: vUrl ?? "",
              autoPlay: true,
              systemUiOverlay: const [],
              deviceOrientation: const [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ],
              startAt: Duration.zero,
              onProgress: (timePoint) {
                playerCPosition = timePoint.inMilliseconds;
                debugPrint("playerCPosition :===> $playerCPosition");
              },
              onFinished: () async {
                /* Remove From Continue */
              },
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
