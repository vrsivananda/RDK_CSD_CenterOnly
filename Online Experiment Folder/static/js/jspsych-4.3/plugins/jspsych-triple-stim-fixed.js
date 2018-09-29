//plugin for triple-stim-fixed
 
 
(function( $ ) {
	jsPsych["triple-stim-fixed"] = (function(){

		var plugin = {};

		plugin.create = function(params) {
			
			
      params = jsPsych.pluginAPI.enforceArray(params, ['data']);
			
			
			var trials = new Array(params.stimuli.length);
			for (var i = 0; i < trials.length; i++) {
			
				 trials[i] = {};
				 trials[i].type = "triple-stim-fixed";
			     trials[i].stimuli = params.stimuli[i];

                // other information needed for the trial method can be added here
                
                // supporting the generic data object with the following line
                // is always a good idea. it allows people to pass in the data
                // parameter, but if they don't it gracefully adds an empty object
                // in it's place.
				
                 trials[i].left_key = params.left_key || 73; // defaults to 'i'
				 trials[i].center_key = params.center_key || 79; // defaults to 'o'
				 trials[i].right_key = params.right_key || 80; // defaults to 'p'
				 
                 // timing parameters
                 trials[i].timing_abc = params.timing_abc || -1; // defaults to -1, meaning infinite time on ABC. If a positive number is used, then ABC will only be displayed for that length.
                 trials[i].timing_response = params.timing_response || -1;
			
				  // optional parameters
                  trials[i].is_html = (typeof params.is_html === 'undefined') ? false : params.is_html;
                  trials[i].prompt = (typeof params.prompt === 'undefined') ? "" : params.prompt;
				  trials[i].display_element = params.display_element;

			}
			return trials;
		};
		
		
		plugin.trial = function(display_element, trial) {
			
				
			
		trial = jsPsych.pluginAPI.evaluateFunctionParameters(trial);
		
		trial.a_path = trial.stimuli[0];
		trial.b_path = trial.stimuli[1];
		trial.c_path = trial.stimuli[2];

		var setTimeoutHandlers = [];
			
		var keyboardListener;
	    

		var images = [trial.a_path, trial.b_path, trial.c_path];
		//images = shuffleArray(images);
	    var target_pos = images.indexOf(trial.a_path);


         // show the options
        if (!trial.is_html) {
          display_element.append($('<img>', {
            "src": images[0],
            "class": 'jspsych-triple-stimulus'
          }));
          display_element.append($('<img>', {
            "src": images[1],
            "class": 'jspsych-triple-stimulus'
          }));
		  display_element.append($('<img>', {
            "src": images[2],
            "class": 'jspsych-triple-stimulus'
          }));
        } else {
          display_element.append($('<img>', {
            "src": images[0],
            "class": 'jspsych-triple-stimulus'
          }));
          display_element.append($('<img>', {
            "src": images[1],
            "class": 'jspsych-triple-stimulus'
          }));
		  display_element.append($('<img>', {
            "src": images[2],
            "class": 'jspsych-triple-stimulus'
          }));
        }

        if (trial.prompt !== "") {
          display_element.append(trial.prompt);
        }

        // if timing_abc is > 0, then we hide the stimuli after timing_abc milliseconds
        if (trial.timing_abc > 0) {
          setTimeoutHandlers.push(setTimeout(function() {
            $('.jspsych-triple-stimulus').css('visibility', 'hidden');
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
		
          var correct = false; // true when the correct response is chosen

           if (info.key == trial.left_key) // 'i' key by default
          {
            if (target_pos === 0) {
              correct = true;
            }
          } else if (info.key == trial.center_key) // 'o' key by default
          {
            if (target_pos === 1) {
              correct = true;
            }
          }
		  else if (info.key === trial.right_key) // 'p' key bey default
		  {
            if (target_pos === 2) {
              correct = true;
            }
          }

		  
		 info.correct = correct;
		 
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
            "correct": info.correct,
            "stimulus": JSON.stringify([trial.a_path, trial.b_path, trial.c_path]),
            "key_press": info.key
          };
          jsPsych.data.write(trial_data);

          display_element.html(''); // remove all

          // move on to the next trial after timing_post_trial milliseconds
          jsPsych.finishTrial();

        };
		
		
		
		  keyboardListener = jsPsych.pluginAPI.getKeyboardResponse({
          callback_function: after_response,
          valid_responses: [trial.left_key, trial.center_key, trial.right_key],
          rt_method: 'date',
          persist: false,
          allow_held_key: false
          });
      
      }

    return plugin;
  })();
})(jQuery);


