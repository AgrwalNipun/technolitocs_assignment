import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../config/model/blog_details_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class BlogDetails extends StatefulWidget {
  final BlogData blogData;

  const BlogDetails({Key? key, required this.blogData}) : super(key: key);

  @override
  State<BlogDetails> createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {

late var _controller;
final String linkImg = "https://technolitics-s3-bucket.s3.ap-south-1.amazonaws.com/rolbol-s3-bucket/";
@override
void initState() {
  super.initState();
  _controller = YoutubePlayerController(
params: YoutubePlayerParams(
  mute: false,
  showControls: true,
  showFullscreenButton: true,

),
);
}

String? extractYouTubeVideoId(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;

  // Handles https://www.youtube.com/watch?v=VIDEOID
  if (uri.queryParameters.containsKey('v')) {
    return uri.queryParameters['v'];
  }

  // Handles youtu.be/VIDEOID or youtube.com/embed/VIDEOID
  final regExp = RegExp(
    r"(?:v=|\/)([0-9A-Za-z_-]{11}).*",
    caseSensitive: false,
    multiLine: false,
  );

  final match = regExp.firstMatch(url);
  return match?.group(1);
}
Widget videoPlayer(String uri){
final id =extractYouTubeVideoId(uri);

  final _controller = YoutubePlayerController.fromVideoId(
    videoId: id!,
    autoPlay: false,
    params: const YoutubePlayerParams(showFullscreenButton: true),
  );

  return YoutubePlayer(
    controller: _controller,
    aspectRatio: 16 / 9,
  );


}
String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: false);
  return htmlText.replaceAll(exp, '').replaceAll('&nbsp;', ' ').replaceAll('&amp;', '&');
}

@override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth * 0.05;
    final double fontSize = screenWidth < 360 ? 12 : 14;

    // Define text styles
    final TextStyle titleStyle = TextStyle(
      fontFamily: 'Movatif',
      fontWeight: FontWeight.bold,
      fontSize: fontSize * 1.4,
    );

    final TextStyle descriptionStyle = TextStyle(
      fontFamily: 'Movatif',
      fontSize: fontSize,
      height: 1.4,
    );

    final TextStyle dateStyle = TextStyle(
      // No fontFamily specified - will use default
      fontSize: fontSize * 0.8,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Image.asset(
              'assets/images/backward_arrow_black.png',
              width: 24,
              height: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(

          // padding: EdgeInsets.all(padding),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.blogData.bannerType=="IMAGE"? Image.network(
                widget.blogData.bannerImage,
                width: double.infinity,
                // height: screenWidth * 0.6,
                fit: BoxFit.cover,

                errorBuilder:
                    (context, error, stackTrace) => Container(
                  height: screenWidth * 0.6,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              )
                  :videoPlayer(widget.blogData.bannerVideo),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    SizedBox(height: padding),
                    Text(widget.blogData.postDate, style: dateStyle),
                    SizedBox(height: padding * 0.5),
                    Text(widget.blogData.title, style: titleStyle),
                    SizedBox(height: padding),
                    Text(widget.blogData.description, style: descriptionStyle),
                    SizedBox(height: 50,),
                    ListView.builder(
                      shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:widget.blogData.moreDescription.length ,
                        itemBuilder: (context,index) {
                        final item = widget.blogData.moreDescription[index];
                        // print(item.description.toString()+ "/////////////////////////////${index}");

                        try{
                          print(item.description);
                        }catch(e){
                          print("/////////////////////////// ${e}");
                        }
                          return Column(
                            children: [
                              if(item.singleImage!='')
                              Image.network(
                                  linkImg+item.singleImage
                              ),


                               Text(removeAllHtmlTags(item.description.toString())),

                               SizedBox(height: 40,),

                              if(item.multipleImages.length>0)
                              _imageGrid(item.multipleImages) ,


                              SizedBox(height: 50,),
                              // Image.network(
                              //     linkImg+item.multipleImages[index]
                              // ),
                              Text(index.toString()),
                            ],
                          );
                        })
                  ],

                ),
              ),
            ],
          ),
        ),
      ),
    );


  }
Widget _imageGrid(List<String> images){
  int value = images.length;

    switch (value) {
      case 1:
        return Container(
            child:Image.network(
          linkImg +images[0],
              errorBuilder: (_,_,_)=>Text("Error"),

        ));
      case 2:
        return Row(
          children: [
    Image.network(
    linkImg +images[0],
    errorBuilder: (_,_,_)=>Text("Error"),

    ),
            Image.network(
              linkImg +images[1],
              errorBuilder: (_,_,_)=>Text("Error"),

            )
          ],
        );
      case 3:
        return SizedBox(
          height: 400,
          child: Row(
            children: [
              Column(
                children: [Image.network(
                  linkImg +images[0],
                  errorBuilder: (_,_,_)=>Text("Error"),

                ),
                  Image.network(
                    linkImg +images[2],
                    errorBuilder: (_,_,_)=>Text("Error"),

                  ),

                ],
              ),
              Image.network(
                linkImg +images[1],
                errorBuilder: (_,_,_)=>Text("Error"),

              )
            ],
          ),
        );
      default:

        return SizedBox(
          height: 400,
          child: Row(
            children: [
              Column(
                children: [
    GestureDetector(
    onTap: (){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SwipeImages(images:images,currentIndex:0)));
    },
    child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                    width:MediaQuery.of(context).size.width/2-25,
                    height: 170,
                    fit:BoxFit.fill,
                    linkImg +images[0],
                    errorBuilder: (_,_,_)=>Text("Error"),
                    
                                    ),
                  ),),
                  SizedBox(
                    height: 20,
                  ),

                  GestureDetector(
                  onTap: (){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SwipeImages(images:images,currentIndex:2)));
    },
    child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),child: Image.network(
                    width:MediaQuery.of(context).size.width/2-25,
                    height: 210,
                    fit: BoxFit.fill,
                    linkImg +images[2],
                    errorBuilder: (_,_,_)=>Text("Error"),

                  ),
    ),),
                ],
              ),
              SizedBox(width: 10,),

    GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SwipeImages(images:images,currentIndex:1)));
      },
      child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
          child:Image.network(
                  width:MediaQuery.of(context).size.width/2-25,
                  height: 400,
                  fit: BoxFit.cover,
                  linkImg +images[1],
                  errorBuilder: (_,_,_)=>Text("Error"),
      
                )),
    )
            ],
          ),
        );
    }


}
}


class SwipeImages extends StatefulWidget {
  final List<String> images;
  int currentIndex;
  SwipeImages({super.key,
    required this.images,
    required this.currentIndex
  });

  @override
  State<SwipeImages> createState() => _SwipeImagesState();
}

class _SwipeImagesState extends State<SwipeImages> {
  late int index;
  late List<String> images;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.currentIndex;
    images = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    int x = index;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:  SystemUiOverlayStyle(
          statusBarColor: Colors.black, // set this to match AppBar or transparent
          statusBarIconBrightness: Brightness.light, // <-- this makes icons white (Android)
          statusBarBrightness: Brightness.dark,       // <-- this is for iOS
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        
      ),
      backgroundColor: Colors.black,
      body:PageView.builder(
          itemCount: images.length,
          controller: PageController(initialPage: index),

          itemBuilder: (context,index1) {

            return Center(
        child: InteractiveViewer(
          onInteractionEnd: (val){
            setState(() {
              x= index1;
            });
          }
          ,
          minScale: 0.5,
          panEnabled: true,
          child: Image.network(
            height: double.infinity,
            width: double.infinity,
            "https://technolitics-s3-bucket.s3.ap-south-1.amazonaws.com/rolbol-s3-bucket/"+images[index1],
            fit: BoxFit.fitWidth,
          ),
        ),
      );
          }
      )
    );
  }
}


