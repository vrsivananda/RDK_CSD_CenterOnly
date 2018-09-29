//jspsych-fullscreen.js:
jsPsych['fullscreen'] = (function(){

    var plugin = {};

    plugin.create = function(params){
        var trials = [];

        trials[0] = {};
        trials[0].text = params.showtext;
        trials[0].button = params.buttontext;
        trials[0].exit = params.exit || false;
		trials[0].display_element = params.display_element;

        return trials;
    }
   

    plugin.trial = function(display_element, trial){
        
		// create object to store data from trial
          var trial_data = {
            "trial_type": 'fullscreen'
          };
          jsPsych.data.write(trial_data);
		
		if(!isFullscreen() && !trial.exit)
		{
			 display_element.html(trial.text);
			 display_element.append("<div class='jspsych-fullscreen'><button id='jspsych-fullscreen-button'>" + trial.button + "</button></div>");
			$('#jspsych-fullscreen-button').on('click',function(){
				launchIntoFullscreen(document.documentElement);
				
				display_element.html('');
				jsPsych.finishTrial();
			});
		}
		else if (isFullscreen() && trial.exit)
		{ 
			display_element.html('<p style="padding-top: 50px; text-align: center;">Exiting fullscreen mode</p>');
			display_element.append("<div class='jspsych-fullscreen'><button id='jspsych-fullscreen-button'>" + trial.button + "</button></div>");
			$('#jspsych-fullscreen-button').on('click',function(){
				quitFullscreen(document.documentElement);
				
				display_element.html('');
				jsPsych.finishTrial();
			});
		}
		else
		{
			display_element.html('');
			jsPsych.finishTrial();
		}
		
    }

    return plugin;
	
})();

function isFullscreen(){
  return (document.fullscreenElement || document.mozFullScreenElement || document.webkitFullscreenElement || document.msFullscreenElement);
}

function launchIntoFullscreen(element) {
  if(element.requestFullscreen) {
    element.requestFullscreen();
  } else if(element.mozRequestFullScreen) {
    element.mozRequestFullScreen();
  } else if(element.webkitRequestFullscreen) {
    element.webkitRequestFullscreen();
  } else if(element.msRequestFullscreen) {
    element.msRequestFullscreen();
  }}
  
function quitFullscreen(element) {
  if (document.exitFullscreen) {
      document.exitFullscreen();
    } else if (document.msExitFullscreen) {
      document.msExitFullscreen();
    } else if (document.mozCancelFullScreen) {
      document.mozCancelFullScreen();
    } else if (document.webkitExitFullscreen) {
      document.webkitExitFullscreen();
    }}

	
	

//example code snippet:
//var activate_fullscreen = {
//    type: 'fullscreen',
//    showtext: '<p style="padding-top: 50px; text-align: center;">This experiment is now shon in fullscreen-mode',
//    buttontext: "OK"
//}

//experiment.push(activate_fullscreen);

//...
//var end_fullscreen = {    type: 'fullscreen',    showtext: '<p style="padding-top: 50px; text-align: center;">exiting fullscreen-mode',    buttontext: "OK",    exit: true}    experiment.push(end_fullscreen);
