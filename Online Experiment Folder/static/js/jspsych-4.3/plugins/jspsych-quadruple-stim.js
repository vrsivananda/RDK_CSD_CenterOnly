//plugin for triple-stim
 
 
(function( $ ) {
	jsPsych["quadruple-stim"] = (function(){

		var plugin = {};

		plugin.create = function(params) {
			
			
      params = jsPsych.pluginAPI.enforceArray(params, ['data']);
			
			
			var trials = new Array(params.stimuli.length);
			for (var i = 0; i < trials.length; i++) {
			
				 trials[i] = {};
				 trials[i].type = "triple-stim";
			     trials[i].stimuli = params.stimuli[i];
				
				
                 trials[i].a_path = params.stimuli[i][0];
                 trials[i].b_path = params.stimuli[i][1];
				 trials[i].c_path = params.stimuli[i][2];
				 trials[i].d_path = params.stimuli[i][3];
                // other information needed for the trial method can be added here
                
                // supporting the generic data object with the following line
                // is always a good idea. it allows people to pass in the data
                // parameter, but if they don't it gracefully adds an empty object
                // in it's place.
				
                 trials[i].choices = params.choices || [];
				 
                 // timing parameters
                 trials[i].timing_abcd = params.timing_abcd || -1; // defaults to -1, meaning infinite time on ABCD. If a positive number is used, then ABCD will only be displayed for that length.
                 trials[i].timing_response = params.timing_response || -1;
			
				  // optional parameters
                  trials[i].is_html = (typeof params.is_html === 'undefined') ? false : params.is_html;
                  trials[i].prompt = (typeof params.prompt === 'undefined') ? "" : params.prompt;
				  trials[i].display_element = params.display_element;

			}
			return trials;
		};
		
		function shuffleArray(array) 
		{
		  var currentIndex = array.length, temporaryValue, randomIndex ;

		  // While there remain elements to shuffle...
		  while (0 !== currentIndex) 
		  {

			// Pick a remaining element...
			randomIndex = Math.floor(Math.random() * currentIndex);
			currentIndex -= 1;

			// And swap it with the current element.
			temporaryValue = array[currentIndex];
			array[currentIndex] = array[randomIndex];
			array[randomIndex] = temporaryValue;
		  }

		  return array;
		}
		
		
		plugin.trial = function(display_element, trial) {
			
				
			
		trial = jsPsych.pluginAPI.evaluateFunctionParameters(trial);

		var setTimeoutHandlers = [];
			
		var keyboardListener;
	    

		var images = [trial.a_path, trial.b_path, trial.c_path, trial.d_path];
		images = shuffleArray(images);
	    var target_pos = images.indexOf(trial.a_path);


         // show the options
        if (!trial.is_html) {
          display_element.append($('<img>', {
            "src": images[0],
            "class": 'jspsych-quadruple-stimulus'
          }));
          display_element.append($('<img>', {
            "src": images[1],
            "class": 'jspsych-quadruple-stimulus'
          }));
		  display_element.append($('<img>', {
            "src": images[2],
            "class": 'jspsych-quadruple-stimulus'
          }));
		  display_element.append($('<img>', {
            "src": images[3],
            "class": 'jspsych-quadruple-stimulus'
          }));
        } else {
          display_element.append($('<img>', {
            "src": images[0],
            "class": 'jspsych-quadruple-stimulus'
          }));
          display_element.append($('<img>', {
            "src": images[1],
            "class": 'jspsych-quadruple-stimulus'
          }));
		  display_element.append($('<img>', {
            "src": images[2],
            "class": 'jspsych-quadruple-stimulus'
          }));
		  display_element.append($('<img>', {
            "src": images[3],
            "class": 'jspsych-quadruple-stimulus'
          }));
        }

        if (trial.prompt !== "") {
          display_element.append(trial.prompt);
        }

        // if timing_abcd is > 0, then we hide the stimuli after timing_abcd milliseconds
        if (trial.timing_abcd > 0) {
          setTimeoutHandlers.push(setTimeout(function() {
            $('.jspsych-quadruple-stimulus').css('visibility', 'hidden');
          }, trial.timing_abc));
        }
		
		 // if timing_response > 0, then we end the trial after timing_response milliseconds
        if (trial.timing_response > 0) {
			var t2 = setTimeout(function() {
				end_trial({rt: -1, correct: false, key: -1});
			}, trial.timing_response);
			setTimeoutHandlers.push(t2);
		}

        // create the function that triggers when a key is pressed.
        var after_response = function(info) {

          // kill any remaining setTimeout handlers
          for (var i = 0; i < setTimeoutHandlers.length; i++) {
            clearTimeout(setTimeoutHandlers[i]);
          }

		// kill keyboard listeners
			if(typeof keyboardListener !== 'undefined'){
				jsPsych.pluginAPI.cancelKeyboardResponse(keyboardListener);
			}
		 
		 end_trial(info);
		  
		  };
		  
		  

        var end_trial = function(info) {
          // kill any remaining setTimeout handlers
          for (var i = 0; i < setTimeoutHandlers.length; i++) {
            clearTimeout(setTimeoutHandlers[i]);
          }
		  
       jsPsych.pluginAPI.cancelKeyboardResponse(keyboardListener);

          // create object to store data from trial
          var trial_data = {
            "rt": info.rt,
            "stimulus": JSON.stringify([trial.a_path, trial.b_path, trial.c_path, trial.d_path]),
            "key_press": info.key
          };
          jsPsych.data.write(trial_data);

          display_element.html(''); // remove all

          // move on to the next trial after timing_post_trial milliseconds
          jsPsych.finishTrial();

        };
		
		
		
		  keyboardListener = jsPsych.pluginAPI.getKeyboardResponse({
          callback_function: after_response,
          valid_responses: trial.choices,
          rt_method: 'date',
          persist: false,
          allow_held_key: false
          });
      
      }

    return plugin;
  })();
})(jQuery);


