READ ME

Recipe Optimization for Animal Crossing: New Horizon (ACNH)

Description: Create a program that takes input from the player and outputs the optimal mix of crafting recipes to maximize profit (in Bells). 

Required Dependencies: 
  Microsoft Excel
  Python - written in version 3.9.xx
    Required Libraries:
      pandas
      numpy
      cvxpy
      cvxopt
      cplex
      timeit

files:
  data (folder)
    diff.csv : csv file containing data on the difference between performance of the optimization model and the default model.
    items.csv : csv file containing all raw materials and their sell prices (140 total).
    recipes.csv : csv file containing all crafting recipes in ACNH and their sell prices (610 total).
  Richards_Noelle_Project_Report.doc,.pdf : Final project report.
  Project.py : python script that executes the optimization and default models.
  userMats.csv : csv file the end user should use to input all raw materials available for crafting.

Model Execution Instructions:
  1. Player opens userMats.csv and inputs all raw materials that are available in their inventory they wish to use for crafting. Save.
  2. Using Anaconda prompt or any other software that executes python files, run Project.py. In Anaconda, the command is  python Project.py  .
  3. The program will execute and the console will show the recipes and quantities the player should make to maximize their profit.

Reading the Output: 
  The first section of the output is the results of the optimization model. The recipe name will be in the first column and the amount that should be crafted in the second.
This is followed by the expected profit of selling these items. The last part of this section is a list of leftover materials. As it won't always be profitable to use all the materials,
some will be leftover and the player can use this list to check their crafting.

-------------------------------
Optimal Recipes and Quantities
-------------------------------
                         Quantity
Name                             
Recipe 1                 ##
Recipe 2                 ##
-------------------------------
Expected Profit:  XXXX Bells
-------------------------------
Leftover Materials: 
                        Quantity
Material                  
Material 1              ##
Material 2              ##

  The next section is very similar, except that it uses the default model, meaning that only one recipe is selected.

-------------------------------
Default Recipe and Quantity
-------------------------------
                        Quantity
Recipe 1                ##
-------------------------------
Expected Default Action Profit:  XXXX Bells
-------------------------------
Leftover Materials: 
                        Quantity
Material                  
Material 1              ##
Material 2              ##

Code Function Explanation:
  cleanData(recipes, prices, userMats) : This function takes in the raw data from three different csv files (recipes.csv, items.csv, userMats.csv), fixes any issues like NA values,
    and returns the variables R, S, P, K which are vectors and matrices defined in the project report.
  ACNHopt(recipes, prices, userMats) : This function uses the cleanData function in it and runs the optimization model. It outputs a list of the optimal recipes and how many times 
    they should be made (optRecipes), the expected profit (result), and a list of the leftover materials and their quantities (leftovers).
  default(recipes, prices, userMats) : This function is similar to the ACNHopt function, but instead runs the default model (outlined in the project report). Its outputs are the
    same as the previous function.

At the bottom of the code, there is a section commented out that was used to run the test of multiple K vectors to verify the efficacy of the optimization model.
