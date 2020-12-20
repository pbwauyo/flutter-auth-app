import 'package:auth_app/repos/comment_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentSlider extends StatefulWidget{
  final String commentId;
  final double initialValue;

  CommentSlider({@required this.commentId, this.initialValue});

  @override
  _CommentSliderState createState() => _CommentSliderState();
}

class _CommentSliderState extends State<CommentSlider> {
  double _sliderValue = 0.0;
  final _commentRepo = CommentRepo();

  @override
  void initState() {
    super.initState();
    _sliderValue  = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          valueIndicatorColor: Constants.SLIDER_LABEL_COLORS[_sliderValue],
          thumbColor: Constants.SLIDER_LABEL_COLORS[_sliderValue],
        ),
        child: Slider(
          min: 0.0,
          max: 3.0,
          label: Constants.SLIDER_LABELS[_sliderValue],
          
          divisions: 3,
          value: _sliderValue, 
          onChanged: (newValue){
            setState(() {
              _sliderValue = newValue;
              print("VALUE: $newValue");
            });
          },
          onChangeEnd: (newValue){
            _commentRepo.updateCommentRating(
              commentId: widget.commentId, 
              newRating: newValue
            );
          },
        ),
      ),
    );
  }
}