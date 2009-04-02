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
view_panel['top']=100;
view_panel['left']=100;
var IE = document.all?true:false
if (!IE) document.captureEvents(Event.MOUSEMOVE)


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
	offset['left']=parseFloat(cropper.css("left"));
	offset['top']=parseFloat(cropper.css("top"));
	offset['right']=offset.left + cropper.width();
	offset['bottom']=offset.top + cropper.height();
	return true
}



jQuery.fn.extend({
   makeButton:function(image,transform,params,title){
		var text = title || (transform+" "+params.join(" "));
		var button=$("<div class='doit pseudolink' id='" + transform+ "'>"+text+"</div>");
		var target=	$(".croppee")
		button.bind("click",function(){
			if ($(this).find("input").size()==0 && params[0]!=""){
				for (var i in params){
					var field=$("<input type='text' value='"+params[i]+"'/>");
					$(this).append(field);
				}
				$(this).append("<div class='pseudobutton ok'>ok</div>");
				$(this).append("<div class='pseudobutton cancel'>cancel</div>");
				
				$(".ok").bind("click",function(){
					$(".loader").css("visibility","visible");
					var new_params=$.map($(this).parent().find("input"), function(i){return i.value;});
					target.getImage(image_prefix,image,transform,new_params);
				});
				$(".pseudobutton").bind("click",function(){
					$(this).parent().parent().find("input").remove();
					$(this).parent().parent().find(".pseudobutton").remove();
				});
				$(this).find("input").eq(0).focus().select();
			}
			else if (params[0]=="") {
		    	$(".loader").css("visibility","visible");
				target.getImage(image_prefix,image,transform,params);
			}	
		});
		$(this).append(button);
	},
   getImage:function(node,id,transformation,params){
	
		params=(params || null);
		var url=new Array();
		var croppee=$(this);
		url =[node,id,transformation];
		if (params.length>0){
			url = url.concat(params);
		}
		url=url.join("/");
		updated_url=[node,id,"refresh",Math.random()].join("/");
		var request=$.ajax({
			type: "GET",
			url: (url),
			datatype:"json",
			async:true,
			success:function(json){
				$(".loader").css("visibility","hidden");
			
				}
			});
		$(this).ajaxComplete(function(request){
			$(this).css("background-image","url("+ updated_url+")");
				$(".cropper").css("background-image","url("+ updated_url+")");
		});

		if ($(this).css("background-image").length>5){
			
		
		}
		else{
			$(this).attr("src",	updated_url);
		}
				
		$.ajax({
			type: "GET",
			url: (url+"/info"),
			datatype:"json",
			async:true,
			success:function(json){
				info=eval(json);
				croppee.width(info[0]['width']+"px").height(info[0]['height']+"px");
				croppee.center();
			}
			});
	},
	keepCentered:function(){
		var c=$(this)
		$(this).center()
		$(window).bind("resize",function(){
			c.center();
		});
			return $(this);
	},
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

//	var image_id=croppee.css("background-image").replace(/url\(/,'').replace(/[\)]/,'').split("/");
	//var img_src=$(this).attr("src");
/*	if (img_src != null){
		croppee=$("<div class='croppee'></div>");
		$("body").append(croppee);
	//	$(this).remove();
		source_image=img_src;
 	}*/
//	else{
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
//	cropper.append("<div class='dragger'></div>");
	
	$(".handle").width(h_width).height(h_height);
	$(".dragger").width(cropper.width()).height(cropper.height());
	$(".dragger").css("top",(h_width+"px")).css("left",(h_width+"px")).css("cursor","move");
	
	cropper.css("background-image",("url("+source_image+")"));
	croppee.css("background-image",("url("+source_image+")"));

	$(".handle").bind("mousedown",function(){
		clicking=true;
		document.onmousedown = getMouseXY;
		view_panel.top=croppee.css("top").replace(/px/,'');
		view_panel.left=croppee.css("left").replace(/px/,'');;
		
		hand=$(this).attr("id");
	});

	$("body").add(".handle").add(".dragger").bind("mouseup",function(){
		if (callback && clicking){callback();}
		clicking=false;
		dragging=false;
		i=0;
		p_x=0
		p_y=0
	});

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

	$("body").bind("mousemove",function(){
		constrained=false;
		if (false){
			document.onmousemove = getMouseXY;
			$(".toolbar").append("<div>"+d_y+"</div>");
		//	tempY=(tempY-view_panel.top);
		//	tempX=(tempX-view_panel.left);
			d_y+=ParseFloat(tempY-p_y);
			getOffsets(cropper);
			if ((tempX+cropper.width())>max_width){tempX=(max_width-cropper.width());constrained=true}
			if ((tempY+cropper.height())>max_height){tempY=(max_height-cropper.height());constrained=true}
			cropper.css("left",
				(tempX-h_width)).css("top",d_y).css("background-position",
				("-"+(tempX-h_width)+"px -" + (tempY-h_height)+"px"));
			//tempY+=view_panel.top;
		//	tempX+=view_panel.left;
			
		}
		if(clicking==true){	
			document.onmousemove = getMouseXY;
			tempY=(tempY-view_panel.top)-(2*h_height);
			tempX=(tempX-view_panel.left)+(h_width);
			if (tempX<h_width){tempX=h_width;constrained=true}
			if (tempY<h_height){tempY=h_height;constrained=true}
			if (tempX>max_width){tempX=max_width;constrained=true}
			if (tempY>max_height){tempY=max_height;constrained=true}
			if (top_left_drags && hand=="tl"){
				if ((tempX+cropper.width())>max_width){tempX=(max_width-cropper.width());constrained=true}
				if ((tempY+cropper.height())>max_height){tempY=(max_height-cropper.height());constrained=true}
			}
			getOffsets(cropper);
		
			if (hand=="br"){
				if (!constrained){
					cropper.width(tempX-offset.left).height(tempY-offset.top);
				}
			}
			else if (hand=="bl"){
				if (!constrained){
					cropper.width(offset.right-tempX+h_width).height(tempY-offset.top).css("left",(tempX-h_width)).css("background-position",("-"+(tempX-h_width)+"px -" + offset.top+"px"));
				}
			}
			else if (hand=="tr"){
				if (!constrained){
					cropper.width(tempX-offset.left).css("top",(tempY-h_height)).height(offset.bottom-tempY+h_height).css("background-position",("-"+offset.left+"px -" + (tempY-h_height)+"px"));
				}
			}
			else if (hand=="tl"){
				if(!constrained){
					if (!top_left_drags){
						cropper.height(offset.bottom-tempY+h_height).width(offset.right-tempX+h_width);
					}
					cropper.css("left",(tempX-h_width)).css("top",(tempY-h_height)).css("background-position",("-"+(tempX-h_width)+"px -" + (tempY-h_height)+"px"));
				}	
			}	
			tempY+=view_panel.top;
			tempX+=view_panel.left;
		}
	});
	}
});

$(document).ready(function(){
	$(".screenshot").allowCropping();
});