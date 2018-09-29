function draw_fixation(cueWidth, cueColor) 
{
	var canvas = document.getElementById("cueCanvas");
  	var context = canvas.getContext("2d");
	var centerWidth = canvas.width / 2.0;
	var centerHeight = canvas.height / 2.0;

	// Fixation Dot
	context.beginPath();
	context.arc(centerWidth, centerHeight, cueWidth, 0, 2 * Math.PI, false);
	context.fillStyle = cueColor;
	context.closePath();
	context.fill();
	
	var string4fixation = canvas.toDataURL();
	context.clearRect(0, 0, canvas.width, canvas.height);
	return string4fixation;
}