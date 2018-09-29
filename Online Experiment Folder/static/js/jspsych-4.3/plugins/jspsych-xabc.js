/*  jspsych-xabc.js
 *	Josh de Leeuw
 *
 *  This plugin runs a single XABC trial, where X is an image presented in isolation, and A, B, and C are choices, with A or B or C being equal to X.
 *	The subject's goal is to identify whether A, B, or C is identical to X.
 *
 * documentation: docs.jspsych.org
 *
 */

(function($) {
  jsPsych.xabc = (function() {

    var plugin = {};

    plugin.create = function(params) {

      params = jsPsych.pluginAPI.enforceArray(params, ['data']);

      // the number of trials is determined by how many entries the params.stimuli array has
      var trials = new Array(params.stimuli.length);

      for (var i = 0; i < trials.length; i++) {
        trials[i] = {};
        trials[i].stimuli = params.stimuli[i];

        trials[i].left_key = params.left_key || 73; // defaults to 'i'
		trials[i].center_key = params.center_key || 79; // defaults to 'o'
        trials[i].right_key = params.right_key || 80; // defaults to 'p'
        // timing parameters
        trials[i].timing_x = params.timing_x || 1000; // defaults to 1000msec.
        trials[i].timing_xabc_gap = params.timing_xabc_gap || 1000; // defaults to 1000msec.
        trials[i].timing_abc = params.timing_abc || -1; // defaults to -1, meaning infinite time on ABC. If a positive number is used, then ABC will only be displayed for that length.
        trials[i].timing_response = params.timing_response || -1; //
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

      // if any trial variables are functions
      // this evaluates the function and replaces
      // it with the output of the function
      trial = jsPsych.pluginAPI.evaluateFunctionParameters(trial);

      // unpack the stimuli array
      trial.x_path = trial.stimuli[0];

      // if there is only three stimuli, then the first is the target and is shown twice.
      // if there is a quadruplet, then the first is X, the second is the target, and the third and fourth are foil (useful for non-exact-match XABC).
      if (trial.stimuli.length == 3) {
        trial.a_path = trial.stimuli[0];
        trial.b_path = trial.stimuli[1];
		trial.c_path = trial.stimuli[2]
      } else {
        trial.a_path = trial.stimuli[1];
        trial.b_path = trial.stimuli[2];
		trial.c_path = trial.stimuli[3];
      }

      // this array holds handlers from setTimeout calls
      // that need to be cleared if the trial ends early
      var setTimeoutHandlers = [];

      // how we display the content depends on whether the content is
      // HTML code or an image path.
      if (!trial.is_html) {
        display_element.append($('<img>', {
          src: trial.x_path,
          "class": 'jspsych-xabc-stimulus'
        }));
      } else {
        display_element.append($('<div>', {
          "class": 'jspsych-xabc-stimulus',
          html: trial.x_path
        }));
      }

      // start a timer of length trial.timing_x to move to the next part of the trial
      setTimeout(function() {
        showBlankScreen();
      }, trial.timing_x);


      function showBlankScreen() {
        // remove the x stimulus
        $('.jspsych-xabc-stimulus').remove();

        // start timer
        setTimeout(function() {
          showSecondStimulus();
        }, trial.timing_xabc_gap);
      }


      function showSecondStimulus() {

        // randomize whether the target is on the left, center,or the right
        var images = [trial.a_path, trial.b_path, trial.c_path];
        images = shuffleArray(images);
		var target_pos = images.indexOf(trial.a_path);

        // show the options
        if (!trial.is_html) {
          display_element.append($('<img>', {
            "src": images[0],
            "class": 'jspsych-xabc-stimulus'
          }));
          display_element.append($('<img>', {
            "src": images[1],
            "class": 'jspsych-xabc-stimulus'
          }));
		  display_element.append($('<img>', {
            "src": images[2],
            "class": 'jspsych-xabc-stimulus'
          }));
        } else {
          display_element.append($('<img>', {
            "src": images[0],
            "class": 'jspsych-xabc-stimulus'
          }));
          display_element.append($('<img>', {
            "src": images[1],
            "class": 'jspsych-xabc-stimulus'
          }));
		  display_element.append($('<img>', {
            "src": images[2],
            "class": 'jspsych-xabc-stimulus'
          }));
        }

        if (trial.prompt !== "") {
          display_element.append(trial.prompt);
        }

        // if timing_abc is > 0, then we hide the stimuli after timing_abc milliseconds
        if (trial.timing_abc > 0) {
          setTimeoutHandlers.push(setTimeout(function() {
            $('.jspsych-xabc-stimulus').css('visibility', 'hidden');
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
            "stimulus": JSON.stringify([trial.x_path, trial.a_path, trial.b_path, trial.c_path]),
            "key_press": info.key
          };
          jsPsych.data.write(trial_data);

          display_element.html(''); // remove all

          // move on to the next trial after timing_post_trial milliseconds
          jsPsych.finishTrial();
        }

        var keyboardListener = jsPsych.pluginAPI.getKeyboardResponse({
          callback_function: after_response,
          valid_responses: [trial.left_key, trial.center_key, trial.right_key],
          rt_method: 'date',
          persist: false,
          allow_held_key: false
        });
      }
    };

    return plugin;
  })();
})(jQuery);