var hl = "highlight"
var t = false
var u = document.location.toString().replace(/\/[a-zA-Z]+$/g, "") + ".json"
var i = u.match(/[0-9]+\.[a-zA-Z]+$/).toString().replace(/[^0-9]+/,'')
var d = u.match(/^http:\/\/[^\/]+/)
var l = [d,i].join("/")
var tu,w,h;

function saveNote(){
	if(t){
		$.post( u,  
			{
				_method:"put",
				notes: $("input").eq(0).val(),
				from: "ajax"
			}
		)
		t=false
	}
}

function setCoords()
{
	$.getJSON("/h/" + i + "/screenshot.json",
		{},
		function(json){
			w = json["screenshot"]["width"]
			h = json["screenshot"]["height"]
			$("#viewer .screenshot").width(w).height(h)
		}
	)
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
			notes: $("input").eq(0).val(),
			from: "ajax"
		}
	)
		if($(".jcrop-holder .note").length == 0){
			$.getJSON(u,{},function(js){
				tu = js["highlight"]["tiny_url"]
				$(".jcrop-holder").before("<div class='url'><span>(</span><a title='Tiny url for sharing your highlig.ht' href='" + tu +"'>" + tu + "</a><span>)</span></div>")
			})
			var i = u.match(/[0-9]+\.[a-zA-Z]+$/).toString().replace(/[^0-9]+/,'')
			$(".jcrop-holder div").eq(0).remove(".note").append("<div class='note'><form method='post' action='/" + i + "'><input type='text' name='notes' class='caption'/></form></div>")
			$(".note").append("<div class='arrows'><div class='arrow a1'></div><div class='arrow a2'></div><div class='arrow a3'></div><div class=' arrow a4'></div></div>")
			$(".caption").keypress(function(){
				t=true;
				setTimeout("saveNote()",500)
			 })
		}
		$(".caption").focus()
}

$(function(){ 
	$('#editor .' + hl).Jcrop({ onSelect: saveCoords}); 
	$("#viewer .screenshot").prepend("<div class='curtain'></div")
	$(".curtain").height($("#viewer .screenshot").height()).width($("#viewer .screenshot").width())
	//setTimeout("alert($('.caption').val())",10000)
});
