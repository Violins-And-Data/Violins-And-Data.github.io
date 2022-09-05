Library of Random Variate Generation Routines
Author: Noelle Richards

User Guide: 

1. Set seed number (line 11)
2. Run lines 1-181 in order to load the function. 
3. Run function using 
RVG()
This function requires no inputs, and outputs a vector of random variates.
4. Follow prompts.

	a. Prompt 1: 
		"Please select which distribution from which to generate random variates.  1: Bernoulli     2: Binomial      3: Geometric     
		4: Poisson       5: Uniform       6: Exponential   7: Normal        8: Erlang        9: Triangular	10: Gamma        11: Weibull"
	Select option using number in the console.

	b. Prompt 2: 
		"Please enter the number of random variates you would like generated: "
	Enter an integer > 0 in the console.

	c. Prompt 3: 
	This prompt is dependent on the distribution selected. For example, if Normal is selected, the next prompt will read:
		"Please enter the lower bound: "
		"Please enter the upper bound: "
	Enter the appropriate values in the console.

*To graph the results of the random variate generation, run the entire file. A graph will be produced using lines 186-188. 

   