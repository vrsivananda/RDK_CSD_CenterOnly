function pest(dataObject){
	
	//Starting variables
	var currentIntensity = assignParameterValue(dataObject.starting_intensity, 0.7); //Starting intensity

	//Variables for Down/Up
	var downThreshold = assignParameterValue(dataObject.down_threshold, 3); // 3 Down
	var upThreshold = assignParameterValue(dataObject.up_threshold, 1); // 1 Up
	var upperIntensityLimit = assignParameterValue(dataObject.upper_intensity_limit, 1);
	var lowerIntensityLimit = assignParameterValue(dataObject.lower_intensity_limit, 0);

	//Variables for PEST
	var currentStepSize = assignParameterValue(dataObject.starting_step_size, 0.32); //Starting step size
	var minimumStepSize = assignParameterValue(dataObject.min_step_size, 0.01); //Smallest step size
	var maximumStepSize = assignParameterValue(dataObject.max_step_size, 0.32); //Largest step size

	//Initialize fixed Down/Up variables 
	//(Do not change unless you want to deviate from the normal PEST procedure)
	var correctStreakCounter = 0;
	var incorrectStreakCounter = 0;
	
	//Initialize fixed PEST variables  
	//(Do not change unless you want to deviate from the normal PEST procedure)
	var originalStepThreshold = 3; //If stepping in the same direction, double on which step (If 3, doubles on the 3rd step)
	var incrementedStepThreshold = originalStepThreshold + 1; //The threshold when a reversal follows a doubling of step size
	var currentStepThreshold = originalStepThreshold; //Global variable to hold the current step threshold
	var firstTrial = true;
	var firstStep = true;
	var limitHit = false; //Whether or not it has hit the upper or lower limit
	var previousStepDirection; //Global variable to hold the previous step direction 
	var currentStepDirection; //Global variable to hold the current step direction
	var stepStreakCounter = 0; //Counter for streaks of steps in the same direction
	var stepSizeJustDoubled = false;


	//----------------Staircasing Functions Begin------------------

	//Function to decide on the coherent direction
	this.staircase = function (lastTrialWasCorrect){
		
		console.log("-----------------------------");
		console.log("lastTrialWasCorrect: " + lastTrialWasCorrect);
		
		//Only run these if it is not the first trial
		if (!firstTrial){
			
			//Check if the subject responded correctly on the previous trial
			if (lastTrialWasCorrect == true){
				responseWasCorrect(); //This function will housekeep for x-Down/y-Up and call the changeStepSizePEST function
			}
			else if (lastTrialWasCorrect == false){
				responseWasIncorrect(); //This function will housekeep for x-Down/y-Up and call the changeStepSizePEST function
			}
			else{
				console.log("Error: lastTrialWasCorrect is neither true nor false!");
			}
			
			previousStepDirection = currentStepDirection; //Pass the current step direction to the previous step direction for use in the next trial
		}
		//Set firstTrial to be false since every subsequent trial won't be the first trial
		else{
			firstTrial = false;
		}//End of if(!firstTrial)
		
		console.log("Current step size = " + currentStepSize);
		
		console.log("currentIntensity in staircase() is " + currentIntensity);
		
		//Return the currentIntensity into the trial
		return currentIntensity; 
		
		console.log("-----------------------------");
		
	}//End of staircase

	//Function to carry out steps if the response in the previous trial was correct
	function responseWasCorrect(){
		
		//Set the incorrect streak counter to zero
		incorrectStreakCounter = 0;
		
		//Increment the streak counter for correct responses
		correctStreakCounter++;
		
		//If it reaches the down threshold, then determine the step size and reset streak counter to zero.
		if(correctStreakCounter == downThreshold){
			
			//Set the current step direction for the staircase
			currentStepDirection = "down"; 
			
			//Use the PEST procedure to determine the step size
			changeStepSizePEST();
			
			//Decrease the intensity by the step size
			decreaseIntensity();
			
			//Reset the correct streak counter
			correctStreakCounter = 0;
		}
		
	}//End of responseWasCorrect

	//Function to carry out steps if the response in the previous trial was incorrect
	function responseWasIncorrect(){
		
		//Set the correct streak counter to zero
		correctStreakCounter = 0;
		
		//Increment the streak counter for incorrect responses
		incorrectStreakCounter++;
		
		//If it reaches the up threshold, then determine the step size, change the intensity level, and reset streak counter to zero.
		if(incorrectStreakCounter == upThreshold) {
			
			//Set the current step direction for the staircase
			currentStepDirection = "up"; 
			
			//Use the PEST procedure to determine the step size
			changeStepSizePEST();
			
			//Increase the intensity by the step size
			increaseIntensity();
			
			//Reset the incorrect streak counter
			incorrectStreakCounter = 0;
		}
		
	}//End of responseWasIncorrect

	//Function to change the stimuli step size according to PEST
	function changeStepSizePEST(){
		
		//Variable to store if this step is a reversal of the previous step
		var reversal;
		
		//For the first step, just set the reversal to false
		if (firstStep){
			reversal = false;
			//Change firstStep to be false because subsequent steps will have a previousStepDirection to compare it to
			firstStep = false;
		}
		//Else, set the reversal to whether the previous step direction corresponds to the current step direction
		else{
			reversal = (previousStepDirection == currentStepDirection) ? false : true;
		}
		
		console.log("Reversal: " + reversal);
		
		//If current step is a reversal of the previous step
		if(reversal){
			
			//Reset the streak counter to include this step (therefore it is 1 instead of zero)
			stepStreakCounter = 1;
			
			//If the reversal did not follow a double in step size, then the threshold should be 3
			if (!stepSizeJustDoubled){
				currentStepThreshold = 3;
			}
			//If the step size just doubled in the previous step, increase the step threshold to 4 [Rule 4]
			else{
				currentStepThreshold = 4;
			}
			
			//Half the step size everytime it reverses [Rule 1]
			halveStepSize();
			
			//Step size did not double, so we reset it back to false (this variable is used below in the else statement)
			stepSizeJustDoubled = false;
		}
		//If step was not a reversal (went in the same direction) AND it is not at the limit
		else if(!limitHit){
			
			//Increment the streak counter
			stepStreakCounter++;
			
			//If the streak has hit the streak threshold, then increase the step size by doubling it [Rule 3]
			if (stepStreakCounter >= currentStepThreshold){
				console.log("Doubling step size.");
				doubleStepSize();
				stepSizeJustDoubled = true;
			}
			//Else step size did not double
			else{
				stepSizeJustDoubled = false;
				console.log("Step size remained the same because not hit threshold yet.");
			}
			
			//If we go in the same direction, we stay with the same step size [Rule 2]
			//Unless we go 3 steps in the same direction, in which case we implement Rule 3 above
			
		}//End of else (not reversal)
		
	}//End of changeStepSizePEST

	//Function to make sure that the intensity is still in range
	function intensityInRange(theIntensity){
		return ((theIntensity < upperIntensityLimit) && (theIntensity > lowerIntensityLimit));
	}

	//Function that halves the step size
	function halveStepSize(){
		//Check to make sure that it is above the minimum
		if(currentStepSize * 0.5 > minimumStepSize){
			currentStepSize *= 0.5;
			console.log("Step size halved.");
		}
		//If not, then set it to the minimum
		else{
			console.log("Minimum step size reached. Setting currentStepSize to minimumStepSize.");
			currentStepSize = minimumStepSize;
		}
	}//End of halveStepSize

	//Function that doubles the step size
	function doubleStepSize(){
		//Check to make sure that it is below the maximum
		if(currentStepSize*2 < maximumStepSize){
			currentStepSize *= 2;
			console.log("Step size doubled.");
		}
		//If not, then set it to the maximum
		else{
			currentStepSize = maximumStepSize;
			console.log("Maximum step size reached. currentStepSize set to maximumStepSize.");
		}
	}//End of doubleStepSize

	//Function to decrease the intensity by the step size
	function decreaseIntensity(){
		//Check that it will still be in the range after decrease
		if(intensityInRange(currentIntensity - currentStepSize)){
			currentIntensity -= currentStepSize;
			
			//Set the variable to keep track that we have not hit the limit such that we update the step size
			limitHit = false;
		}
		//Else just set it to the minimum intensity allowed
		else{
			
			//Only update the step size if we have not hit the lower or upper limit
			if(!limitHit){
				//Calculate the distance from threshold
				var distanceFromThreshold = currentIntensity - lowerIntensityLimit;
				console.log('distanceFromThreshold: ' + distanceFromThreshold);
				//Set the current step size to be the larger of distance from threshold and minimum step size
				currentStepSize = distanceFromThreshold > minimumStepSize ? distanceFromThreshold : minimumStepSize;
				console.log("lowerIntensityLimit reached. currentStepSize: " + currentStepSize);
			}
			
			currentIntensity = lowerIntensityLimit;
				
			//Set the variable to keep track that we have hit the limit such that we do not update the step size
			limitHit = true;
			
		}
	}//End of decreaseIntensity

	//Function to decrease the intensity by the step size
	function increaseIntensity(){
		//Check that it will still be in the range after increase
		if(intensityInRange(currentIntensity + currentStepSize)){
			currentIntensity += currentStepSize;
			
			//Set the variable to keep track that we have not hit the limit such that we update the step size
			limitHit = false;
		}
		//Else just set it to the minimum intensity allowed
		else{
			
			//Only update the step size if we have not hit the lower or upper limit
			if(!limitHit){
				//Calculate the distance from threshold
				var distanceFromThreshold = upperIntensityLimit - currentIntensity;
				console.log('upperIntensityLimit: ' + upperIntensityLimit);
				console.log('currentIntensity: ' + currentIntensity);
				console.log('distanceFromThreshold: ' + distanceFromThreshold);
				//Set the current step size to be the larger of distance from threshold and minimum step size
				currentStepSize = distanceFromThreshold > minimumStepSize ? distanceFromThreshold : minimumStepSize;
				console.log("upperIntensityLimit reached. currentStepSize: " + currentStepSize);
			}
			
			currentIntensity = upperIntensityLimit;
			
			//Set the variable to keep track that we have hit the limit such that we do not update the step size
			limitHit = true;
		}
	}//End of decreaseIntensity

	//----------------Staircasing Functions End------------------
	
	//----------------General Functions Begin------------------
	
	//Function to assign the default values for the staircase parameters
	function assignParameterValue(argument, defaultValue){
		return typeof argument !== 'undefined' ? argument : defaultValue;
	}
	
	//----------------General Functions End------------------
	
}//End of function pest(dataObject)