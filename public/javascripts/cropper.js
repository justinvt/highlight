var tempX = 0
var tempY = 0
var p_x=0;
var p_y=0;
var d_y=0;
var d_x=0;
var i=0;
var hand = ""
var clicking=false;
var dragging=false;
var clickable = false;
var interested=new Array();
var constrained=false;
var h_width=10;
var h_height=h_width;
var max_width=300;
var max_height=300;
var top_left_drags=false;
var source_image="";
var offset=new Object();
var image_prefix=null;
var view_panel=new Object();
view_panel['height']=480;
view_panel['width']=640;
view_panel['top']=0;
view_panel['left']=0;
var IE = document.all?true:false
if (!IE) document.captureEvents(Event.MOUSEMOVE)


function getMouseXY(e) {
  if (IE) {
    p_x = event.clientX + document.body.scrollLeft
    p_y = event.clientY + document.body.scrollTop
  } else {
    p_x = e.pageX
    p_y = e.pageY
  }  
  if (p_x < 0){p_x = 0}
  if (p_y < 0){p_y = 0}
  return [p_x,p_y]
}

function getOffsets(cropper){
	offset['left']=parseFloat(cropper.css("left"));
	offset['top']=parseFloat(cropper.css("top"));
	offset['right']=offset.left + cropper.width();
	offset['bottom']=offset.top + cropper.height();
	return true
}

jQuery.fn.extend({
	center:function(){
		var lo=parseFloat(($(window).width()-$(this).width())/2);
		var to=parseFloat(($(window).height()-$(this).height())/2);
		var min=20
		var max=90
		if (to < min){ to=min}
		if (to > max){ to=max}
		$(this).css("left",lo).css("top",to);	
	},
	properlySize: function(){
		var response=$.ajax({
			type: "GET",
			url: ($(this).workingVersion()+"/info"),
			datatype:"json",
			async:false
			}).responseText;
			info=eval(response);
			$(this).width(info[0]['width']).height(info[0]['height']);
			return $(this);
	},
	workingVersion: function(){
		if ($(this).css("background-image")){
			return $(this).css("background-image").replace(/url|[\(\)]/g,"");
		}
	}	,
	draggable: function(){
		var t=$(this);
		var h=0;

		$(".toolbar").prepend("<div class='grabber'></div>");
		
		$(this).find('.grabber').bind("mousedown",function(){
			interested[t.attr("class")]=true;
			document.onmousedown = getMouseXY;
			hand=$(this).attr("id");
			if (i==0){
				p_y=tempY-$(".toolbar").css("top").replace(/px/,'');
				p_x=tempX-$(".toolbar").css("left").replace(/px/,'');
				i++;
				//alert(p_x);
			}
		});
		$("body").bind("mousemove",function(){
			if(interested[t.attr("class")]==true){	
				document.onmousemove = getMouseXY;
			    $(".toolbar").css("top",tempY-p_y);
				$(".toolbar").css("left",tempX-p_x);
				}
			});
		
			$("body").add(".grabber").bind("mouseup",function(){
				interested[t.attr("class")]=false;
				i=0;
				p_x=0
				p_y=0
			});
			return $(this);
	},
  allowCropping: function(callback) {
	var croppee = $(this);
	var cropper = $("<div class='cropper'></div>");
	var curtain = $("<div class='curtain'></div>");

	source_image=$(this).workingVersion();
//	}
//	var response=$.ajax({
//		type: "GET",
//		url: (source_image+"/info"),
//		datatype:"json",
//		async:false
//	}).responseText;
//	info=eval(response);
	croppee.width(640).height(480);
	
	croppee.prepend(curtain).prepend(cropper).css("font-size","0px");
	max_width=croppee.width();
	max_height=croppee.height();
	curtain.height(max_height).width(max_width);


	cropper.append("<div class='handle topmost leftmost' id='tl'></div>");
	cropper.append("<div class='handle topmost rightmost' id='tr'></div>");
	cropper.append("<div class='handle bottommost leftmost' id='bl'></div>");
	cropper.append("<div class='handle bottommost rightmost' id='br'></div>");
	cropper.append("<div class='dragger'></div>");
	
	$(".handle").width(h_width).height(h_height);
	$(".dragger").width(cropper.width()).height(cropper.height());
	$(".dragger").css("top",(h_width+"px")).css("left",(h_width+"px")).css("cursor","move");
	
	cropper.css("background-image",("url("+source_image+")"));
	croppee.css("background-image",("url("+source_image+")"));

	$(".handle").bind("mousedown",function(e){
		clicking=true;
		tempX = getMouseXY(e)[0]
		tempY = getMouseXY(e)[1]
		document.onmousemove = getMouseXY(e);
		hand=$(this).attr("id");
	});

	$("body").add(".handle").add(".dragger").bind("mouseup",function(){
		if (callback && clicking){callback();}
		clicking=false;
		dragging=false;
		i=0;
		document.onmousemove = null;
	});
/*
	$(".dragger").bind("mousedown",function(){
		i=0;
		dragging=true;
		document.onmousedown = getMouseXY;
		if (i==0){
			p_y=tempY;
			p_x=tempX;
			d_y=cropper.css("top").replace(/[^0-9]+/,'');
			//alert(d_y);
			i++;
		}
		view_panel.top=croppee.css("top").replace(/px/,'');
		view_panel.left=croppee.css("left").replace(/px/,'');;
	
	});
*/
	$("body").bind("mousemove",function(e){
		if(clicking==true){	

	
		//	getOffsets(cropper);
		
			if (hand=="br"){
				var cw = $(".cropper").width()
				$(".cropper").width(cw + (getMouseXY(e)[0] - tempX))
			
			}
			else if (hand=="bl"){
				if (!constrained){
				
				}
			}
			else if (hand=="tr"){
				if (!constrained){
				
				}
			}
			else if (hand=="tl"){
				if(!constrained){
					if (!top_left_drags){
					}
				}	
			}	
		}
	});
	}
});

$(document).ready(function(){
	$(".screenshot").allowCropping();
});