var h = "highlight"
var t = false

function saveNote(){
	if(t){
		$.post(document.location + ".json",  {_method:"put",notes: $("input").eq(0).val()})
		t=false
	}
}

function saveCoords(c)
{
	$.post(document.location + ".json", 
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
			$(".jcrop-holder div").eq(0).remove(".note").append("<div class='note'><input type='text' name='note'/></div>")
			$(".note").append("<div class='arrows'><div class='arrow a1'></div><div class='arrow a2'></div><div class='arrow a3'></div><div class=' arrow a4'></div></div>")
			$("input").keypress(function(){
				t=true
				setTimeout("saveNote()",2000)
			 })
		}
}

$(function(){ 
	$('.' + h).Jcrop({ onSelect: saveCoords}); 
});
