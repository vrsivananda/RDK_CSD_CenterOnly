function draw_cue(set_size, cueWidth, x, y) 
{
	var canvas = document.getElementById("cueCanvas");
  	var context = canvas.getContext("2d");
	var centerWidth = canvas.width / 2.0;
	var centerHeight = canvas.height / 2.0;
		
	// Cue to target stimulus
	context.beginPath();	
	context.moveTo(x,y);
	context.lineTo(centerWidth, centerHeight);
	context.lineWidth = cueWidth;
	context.strokeStyle = 'black';
	context.closePath();
	context.stroke();
	
	
	// Fixation Dot
	context.beginPath();
	context.arc(centerWidth, centerHeight, cueWidth, 0, 2 * Math.PI, false);
	context.fillStyle = 'red';
	context.closePath();
	context.fill();
	
	var string4fixation = canvas.toDataURL();
	context.clearRect(0, 0, canvas.width, canvas.height);
	return string4fixation;
}