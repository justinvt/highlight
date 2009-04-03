var h = "highlight"
var t = false
var u = document.location.toString().replace(/\/[a-zA-Z]+$/g, "") + ".json"
var i = u.match(/[0-9]+\.[a-zA-Z]+$/).toString().replace(/[^0-9]+/,'')
var d = u.match(/^http:\/\/[^\/]+/)
var l = [d,i].join("/")

function saveNote(){
	if(t){
		$.post( u,  {_method:"put",notes: $("input").eq(0).val()})
		t=false
	}
}

function saveCoords(c)
{
	$.post(u, 
		{
			_method:"put",
			x1:c.x,
			x2:c.x2,
			y1:c.y,
			y2:c.y2,
			notes: $("input").eq(0).val()
		}
	)
		if($(".jcrop-holder .note").length == 0){
			$(".jcrop-holder").before("<div class='url'><a href='" + l +"'>" + "share" + "</a></div>")
			$(".jcrop-holder div").eq(0).remove(".note").append("<div class='note'><input type='text' name='note'/></div>")
			$(".note").append("<div class='arrows'><div class='arrow a1'></div><div class='arrow a2'></div><div class='arrow a3'></div><div class=' arrow a4'></div></div>")
			$("input").keypress(function(){
				t=true
				setTimeout("saveNote()",2000)
			 })
		}
}

$(function(){ 
	$('#editor .' + h).Jcrop({ onSelect: saveCoords}); 
	$("#viewer .screenshot").prepend("<div class='curtain'></div")
	$(".curtain").height($("#viewer .screenshot").height()).width($("#viewer .screenshot").width())
});
