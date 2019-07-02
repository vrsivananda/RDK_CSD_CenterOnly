/**
 * jspsych-range-slider
 * Jason Carpenter
 *
 * plugin for displaying two sliders and getting a response
 *
 *
 **/

(function($) {
	jsPsych["range-slider"] = (function() {

		var plugin = {};

		plugin.create = function(params) {

			params = jsPsych.pluginAPI.enforceArray(params, ['stimuli', 'choices']);

			var trials = new Array(1);
			for (var i = 0; i < trials.length; i++) {
				trials[i] = {};
				// Initial value paramter
				trials[i].initial_value = params.initial_value || Math.random() * 180;
				// timing parameters
				trials[i].timing_response = params.timing_response || -1; // if -1, then wait for response forever
				// optional parameters
				trials[i].prompt1 = (typeof params.prompt1 === 'undefined') ? "" : params.prompt1;
				trials[i].prompt2 = (typeof params.prompt2 === 'undefined') ? "" : params.prompt2;
				
				trials[i].display_element = params.display_element;
			}
			return trials;
		};



		plugin.trial = function(display_element, trial) {

			var initialTime =  new Date().getTime();
			var response1Time = -1;
			var response2Time = -1;
			// if any trial variables are functions
			// this evaluates the function and replaces
			// it with the output of the function
			trial = jsPsych.pluginAPI.evaluateFunctionParameters(trial);

			// this array holds handlers from setTimeout calls
			// that need to be cleared if the trial ends early
			var setTimeoutHandlers = [];

			
			
			display_element.append($('<div id="box1" class="box"><div id="slider1"></div></div>'));
			$("#slider1").roundSlider({
			  sliderType: "default",
			  circleShape: "half-top",
			  handleSize: "34,10",
			  value: trial.initial_value,
			  min: 0,
			  max: 180,
		      showTooltip: false
			});
			//show prompt if there is one
			if (trial.prompt1 !== "") {
				$("#box1").append(trial.prompt1);
			}
			$("#box1").append($('<center><input type="button" class="btn" value="Finalize Answer" onclick="change1(); this.disabled=true;"/></center>'));
			//Putting slider2 inside this function keeps it from appearing until the first answer is given by clicking
			window.change1 = function() 
			{
				response1Time =  new Date().getTime();
				response.rt1 = response1Time - initialTime;
				
				var obj1 = $("#slider1").data("roundSlider");
				
				//Store this for later use.
				var origValue = obj1.getValue(1);
				response.meanResp = origValue;
				
				//I think making valueDiff a random variable is a good way to force people to choose a range.
				//The "10" is to make the sliders always start with a little bit of separation.
				var valueDiff = 10 + (Math.random() * 80);
				var start1 = origValue-(valueDiff/2);
				var start2 = origValue+(valueDiff/2);
				
				display_element.append($('<div id="box2" class="box"><div id="slider2"></div></div>'));
				
				$("#slider2").roundSlider({
					sliderType: "range",
					circleShape: "custom-half",
					startAngle: origValue - 90,
					endAngle: origValue + 90,
					min: origValue - 90,
					max: origValue + 90,
					value: "90,90",
					showTooltip: false,
					change: function(event) { 
						// Get slider handle indexs
						var obj2 = $("#slider2").data("roundSlider");
						var sliderUsedIndex = event.handle.index;
						var otherSliderIndex = event.handle.index % 2 + 1;

						// Get changed slider values
						var valueString = event.value.split(",");
						var values = [parseInt(valueString[0],10)];
						values.push(parseInt(valueString[1],10));
										
						var center = origValue;
						if (values[0] > center) // If they set left value across center, set both to center
						{
							obj2.setValue(center, 1);
							obj2.setValue(center, 2);
						}
						else if (values[1] < center) // If they set right value across center, set both to center
						{
							obj2.setValue(center, 1);
							obj2.setValue(center, 2);
						}
						else // Otherwise, make symmetric
						{
							var valueChanged = values[sliderUsedIndex-1];
							var diffFromCenter = valueChanged - center;
							var newValue = center-(diffFromCenter);
							obj2.setValue(newValue, otherSliderIndex);
						}
					}
					
					
				 });
				 //show prompt if there is one
				 if (trial.prompt2 !== "") {
					$("#box2").append(trial.prompt2);
				}
				 $("#box2").append($('<center><input type="button" class="btn" value="Finalize Answer" onclick="change2()"/></center>'));
				 
				 // After creating the slider, set the initial values to start1 and start2 individually (for some reason using the value property doesn't work right).
				 var obj2 = $("#slider2").data("roundSlider");
				 var val = [start1,start2];
				 obj2.setValue(val[0],1);
				 obj2.setValue(val[1],2)
				 
			}
			window.change2 = function(event) 
			{
				response2Time =  new Date().getTime();
				response.rt2 = response2Time - response1Time;
				
				var obj2 = $("#slider2").data("roundSlider");
				var rangeString = obj2.getValue().split(",");
				var precisionValues = [parseInt(rangeString[0],10)];
				precisionValues.push(parseInt(rangeString[1],10));
				var confResp = precisionValues[1] - precisionValues[0];
				response.confResp = confResp;
				end_trial();
			}

			
			

			// store response
			var response = {rt1: -1, rt2: -1, meanResp: -1, confResp: -1};

			// function to end trial when it is time
			var end_trial = function() {

				// kill any remaining setTimeout handlers
				for (var i = 0; i < setTimeoutHandlers.length; i++) {
					clearTimeout(setTimeoutHandlers[i]);
				}

				// kill keyboard listeners
				if(typeof keyboardListener !== 'undefined'){
					jsPsych.pluginAPI.cancelKeyboardResponse(keyboardListener);
				}

				// gather the data to store for the trial
				var trial_data = {
					"rt1": response.rt1,
					"rt2": response.rt2,
					"meanResp": response.meanResp,
					"confResp": response.confResp
				};

				jsPsych.data.write(trial_data);

				// clear the display
				display_element.html('');

				// move on to the next trial
				jsPsych.finishTrial();
			};


			// end trial if time limit is set
			if (trial.timing_response > 0) {
				var t2 = setTimeout(function() {
					end_trial();
				}, trial.timing_response);
				setTimeoutHandlers.push(t2);
			}

		};

		return plugin;
	})();
})(jQuery);
