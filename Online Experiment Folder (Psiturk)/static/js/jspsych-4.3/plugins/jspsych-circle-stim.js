/**
 *
 * jspsych-visual-search-circle
 * Josh de Leeuw
 *
 * display a set of objects, with or without a target, equidistant from fixation
 * subject responds to whether or not the target is present
 *
 * based on code written for psychtoolbox by Ben Motz
 *
 * requires Snap.svg library (snapsvg.io)
 *
 * documentation: docs.jspsych.org
 *
 **/

(function($) {
  jsPsych["circle-stim"] = (function() {

    var plugin = {};

    plugin.create = function(params) {

      var trials = new Array(params.stimuli.length);

      for (var i = 0; i < trials.length; i++) {
        trials[i] = {};

        trials[i].stimuli = params.stimuli[i];
		trials[i].fixation_size = params.fixation_size || 8;
		trials[i].fixation_color = params.fixation_color || 'red';
		trials[i].targetStimPos = params.targetStimPos;
        trials[i].target_size = params.target_size || [50, 50];
        trials[i].circle_diameter = params.circle_diameter || 250;
        trials[i].cont_key = params.cont_key || 32;
        trials[i].timing_max_search = (typeof params.timing_max_search === 'undefined') ? -1 : params.timing_max_search;
		trials[i].display_element = params.display_element;
      }

      return trials;
    };
	
    plugin.trial = function(display_element, trial) {

      trial = jsPsych.pluginAPI.evaluateFunctionParameters(trial);
	  var targetStim = trial.stimuli[trial.targetStimPos];

      // screen information
      var screenw = display_element.width();
      var screenh = display_element.height();
      var centerx = screenw / 2;
      var centery = screenh / 2;

      // circle params
      var diam = trial.circle_diameter; // pixels
      var radi = diam / 2;
      var paper_size = diam + trial.target_size[0];

      // stimuli width, height
      var stimh = trial.target_size[0];
      var stimw = trial.target_size[1];
      var hstimh = stimh / 2;
      var hstimw = stimw / 2;

      // possible stimulus locations on the circle
      var display_locs = [];
      var possible_display_locs = trial.stimuli.length;
      var random_offset = 90;//Math.floor(Math.random() * 360);
      for (var i = 0; i < possible_display_locs; i++) {
        display_locs.push([
          Math.floor(paper_size / 2 + (cosd(random_offset + (i * (360 / possible_display_locs))) * radi) - hstimw),
          Math.floor(paper_size / 2 - (sind(random_offset + (i * (360 / possible_display_locs))) * radi) - hstimh)
        ]);
      }

      // get target to draw on
      display_element.append($('<svg id="jspsych-visual-search-circle-svg" width=' + paper_size + ' height=' + paper_size + '></svg>'));
      var paper = Snap('#jspsych-visual-search-circle-svg');

	  show_search_array();
	  
      function show_search_array() {

        var search_array_images = [];

		var fixation = draw_fixation(trial.fixation_size, trial.fixation_color);
		var img = paper.image(fixation, hstimw, hstimh, trial.circle_diameter, trial.circle_diameter);
		search_array_images.push(img);
		
        for (var i = 0; i < display_locs.length; i++) {
			
		  
		  
          var which_image = trial.stimuli[i];

          var img = paper.image(which_image, display_locs[i][0], display_locs[i][1], trial.target_size[0], trial.target_size[1]);

          search_array_images.push(img);

        }
		
		

		
		
        var trial_over = false;

        var after_response = function(info) {

          trial_over = true;

          clear_display();

          end_trial(info.rt, info.key);

        }

        var valid_keys = [trial.cont_key];

        key_listener = jsPsych.pluginAPI.getKeyboardResponse({
					callback_function: after_response,
					valid_responses: valid_keys,
					rt_method: 'date',
					persist: false,
					allow_held_key: false
				});

        if (trial.timing_max_search > -1) {

          if (trial.timing_max_search == 0) {
            if (!trial_over) {

              jsPsych.pluginAPI.cancelKeyboardResponse(key_listener);

              trial_over = true;

              var rt = -1;
              var key_press = -1;

              clear_display();

              end_trial(rt, correct, key_press);
            }
          } else {

            setTimeout(function() {

              if (!trial_over) {

                jsPsych.pluginAPI.cancelKeyboardResponse(key_listener);

                trial_over = true;

                var rt = -1;
                var key_press = -1;

                clear_display();

                end_trial(rt, key_press);
              }
            }, trial.timing_max_search);
          }
        }

        function clear_display() {
          display_element.html('');
        }
      }


      function end_trial(rt, key_press) {

        // data saving
        var trial_data = {
          rt: rt,
          key_press: key_press,
          locations: JSON.stringify(display_locs),
          set_size: trial.stimuli.length,
		  cuedStim: targetStim,
		  target_position: trial.targetStimPos
        };

        // this line merges together the trial_data object and the generic
        // data object (trial.data), and then stores them.
        jsPsych.data.write(trial_data);

        // go to next trial
        jsPsych.finishTrial();
      }
    };

    // helper function for determining stimulus locations

    function cosd(num) {
      return Math.cos(num / 180 * Math.PI);
    }

    function sind(num) {
      return Math.sin(num / 180 * Math.PI);
    }

    return plugin;
  })();
})(jQuery);
