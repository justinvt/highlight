var IE = document.all?true:false
if (!IE) document.captureEvents(Event.MOUSEMOVE)

var tempX = 0
var tempY = 0
var hand = ""
var clicking=false;
var clickable = false;
var constrained=false;
var h_width=10;
var h_height=h_width;
var max_width=300;
var max_height=300;
var top_left_drags=false;
var source_image="http://farm3.static.flickr.com/2268/2051432090_e594f0a86c_b.jpg";
var left_offset = 0;
var right_offset = 0;
var top_offset = 0;
var bottom_offset = 0;

function getMouseXY(e) {
  if (IE) {
    tempX = event.clientX + document.body.scrollLeft
    tempY = event.clientY + document.body.scrollTop
  } else {
    tempX = e.pageX
    tempY = e.pageY
  }  
  if (tempX < 0){tempX = 0}
  if (tempY < 0){tempY = 0}
  return true
}

function getOffsets(cropper){
	left_offset=parseFloat(cropper.css("left").replace("px",''));
	top_offset=parseFloat($(".croppee").css("top").replace("px",''));
	right_offset=(left_offset) + cropper.width();
	bottom_offset=(top_offset) + cropper.height();
	return true
}

$(document).ready(function(){

	var croppee = $(".cropper");
	var cropper = $(".croppee");


	max_width=$(".cropper").width();
	max_height=$(".cropper").height();
	cropper.append("<div class='handle topmost leftmost' id='tl'></div>");
	cropper.append("<div class='handle topmost rightmost' id='tr'></div>");
	cropper.append("<div class='handle bottommost leftmost' id='bl'></div>");
	cropper.append("<div class='handle bottommost rightmost' id='br'></div>");
	$(".handle").width(h_width).height(h_height);
	cropper.css("background-image",("url("+source_image+")"));
	croppee.css("background-image",("url("+source_image+")"))

	$(".handle").mousedown(function(){
		clicking=true;
		document.onmousedown = getMouseXY;
		hand=$(this).attr("id");
	});
	
	$(".handle").mouseover(function(){clickable=true;});
	$(window).add(".handle").mouseup(function(){
		clicking=false;
	});
	
	$(document).mousemove(function(){
		constrained=false;
		if(clicking==true){	
			document.onmousemove = getMouseXY;
			if (tempX<h_width){tempX=h_width;constrained=true}
			if (tempY<h_height){tempY=h_height;constrained=true}
			if (tempX>max_width){tempX=max_width;constrained=true}
			if (tempY>max_height){tempY=max_height;constrained=true}
			if (top_left_drags){
				if ((tempX+cropper.width())>max_width && (hand=="tl")){tempX=(max_width-cropper.width());constrained=true}
				if ((tempY+cropper.height())>max_height && (hand=="tl")){tempY=(max_height-cropper.height());constrained=true}
			}
			
			getOffsets(cropper);
			
			if (hand=="br"){
				if (!constrained){
					cropper.width(tempX-left_offset).height(tempY-parseFloat(top_offset));
				}
			}
			else if (hand=="bl"){
				if (!constrained){
					cropper.width(right_offset-tempX+h_width).height(tempY-top_offset).css("left",(tempX-h_width)).css("background-position",("-"+(tempX-h_width)+"px -" + top_offset+"px"));
				}
			}
			else if (hand=="tr"){
			if (!constrained){
				cropper.width(tempX-left_offset).css("top",((tempY-h_height) + "px")).height(bottom_offset-tempY+h_height).css("background-position",("-"+left_offset+"px -" + (tempY-h_height)+"px"));
			}
			}
			else if (hand=="tl"){
				if(!constrained){
					if (!top_left_drags){
						cropper.height(bottom_offset-tempY+h_height).width(right_offset-tempX+h_width);
					}
				cropper.css("left",(tempX-h_width)).css("top",(tempY-h_height)).css("background-position",("-"+(tempX-h_width)+"px -" + (tempY-h_height)+"px"));
				}	
			}
		}
	});

});