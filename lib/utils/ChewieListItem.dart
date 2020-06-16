import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:truck_learning/models/chapterlistmodel.dart';
import 'package:video_player/video_player.dart';

class ChewieListItem extends StatefulWidget
{
  ChaptersListModel courseListModel;
  // This will contain the URL/asset path which we want to play
  final VideoPlayerController videoPlayerController;
  final bool looping;

  ChewieListItem({
    @required this.videoPlayerController,
    this.looping,
    this.courseListModel,
    Key key,
  }) : super(key: key);

  @override
  _ChewieListItemState createState() => _ChewieListItemState(courseListModel);
}

class _ChewieListItemState extends State<ChewieListItem> {
  ChewieController _chewieController;
  ChaptersListModel chaptersListModel;


  _ChewieListItemState(this.chaptersListModel);

  @override
  void initState() {
    super.initState();
    widget.videoPlayerController.addListener(checkVideo);
    // Wrapper on top of the videoPlayerController
    _chewieController = ChewieController(
      startAt: Duration(seconds: 5),
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      // Prepare the video to be played and display the first frame
      autoInitialize: true,
      looping: widget.looping,
      // Errors can occur for example when trying to play a video
      // from a non-existent URL
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },



    );

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  void checkVideo(){

    //print(widget.videoPlayerController.value.position);

    // Implement your calls inside these conditions' bodies :
    if(widget.videoPlayerController.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    if(widget.videoPlayerController.value.position == widget.videoPlayerController.value.duration) {
      print('video Ended');
    }

    print(widget.videoPlayerController.value.duration);

  }

  @override
  void dispose() {
    super.dispose();
    // IMPORTANT to dispose of all the used resources
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
