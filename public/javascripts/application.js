var h = "highlight"
function saveCoords(c)
{
	$.post(document.location + ".json", 
		{
			_method:"put",
			x1:c.x,
			x2:c.x2,
			y1:c.y,
			y2:c.y2
		}
	)
}

$(function(){ $('.' + h).Jcrop({
		onSelect: saveCoords
	}); 
});
