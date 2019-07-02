/*
 * Example plugin template
 */

jsPsych.plugins["multi-item-presentation"] = (function() {

  var plugin = {};
  
  //Use this method in a plugin file to mark a parameter as containing an element that should be preloaded.   	The method should be called in the plugin file such that it gets called when the file is loaded.
  //jsPsych.pluginAPI.registerPreload('same-different', 'stimuli', 'image');

  plugin.trial = function(display_element, trial) {

	jsPsych.pluginAPI.registerPreload('same-different', 'stimuli', 'image');
    
	// set default values for parameters
    //trial.parameter = trial.parameter || 'default value';
	
    // default parameters
    trial.same_key = trial.same_key || 81; // default is 'q'
    trial.different_key = trial.different_key || 80; // default is 'p'
    // timing parameters
    trial.timing_first_stim = trial.timing_first_stim || 1000; // if -1, the first stim is shown until any key is pressed
    trial.timing_second_stim = trial.timing_second_stim || 1000; // if -1, then second stim is shown until response.
    trial.timing_gap = trial.timing_gap || 500;
    // optional parameters
    trial.is_html = (typeof trial.is_html === 'undefined') ? false : trial.is_html;
    trial.prompt = (typeof trial.prompt === 'undefined') ? "" : trial.prompt;

    // allow variables as functions
    // this allows any trial variable to be specified as a function
    // that will be evaluated when the trial runs. this allows users
    // to dynamically adjust the contents of a trial as a result
    // of other trials, among other uses. you can leave this out,
    // but in general it should be included
    trial = jsPsych.pluginAPI.evaluateFunctionParameters(trial);

    // data saving
    var trial_data = {
      parameter_name: 'parameter value'
    };

    // end trial
    jsPsych.finishTrial(trial_data);
  };

  return plugin;
})();
