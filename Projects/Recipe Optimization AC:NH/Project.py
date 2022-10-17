# -*- coding: utf-8 -*-
"""
Created on Sun Apr 24 20:31:47 2022

@author: noell
"""

###Steps for data cleaning: -All prices double checked (materials and DIYs), 
#### -Creation of R, S, P, K -Adjust recipes that use other recipes down to raw mats

import pandas as pd
import numpy as np
import cvxpy as cp
import cvxopt 
import cplex
import timeit

start = timeit.default_timer()

#THINGS TO THINK ABOUT:
    #Recipes that require other recipes to make 
    #Native fruits selling for less
    #Are the prices/recipes accurate? Yes

#Load recipes and clean
recipes = pd.read_csv('data/recipes.csv', keep_default_na=False)
prices = pd.read_csv('data/items.csv')
userMats = pd.read_csv('userMats.csv')

def cleanData(recipes, prices, userMats):
    test = []
    for i in range(len(recipes)):
        test.append([{recipes['Material 1'][i]: recipes['#1'][i], 
                    recipes['Material 2'][i]: recipes['#2'][i],
                    recipes['Material 3'][i]: recipes['#3'][i],
                    recipes['Material 4'][i]: recipes['#4'][i],
                    recipes['Material 5'][i]: recipes['#5'][i],
                    recipes['Material 6'][i]: recipes['#6'][i],
                    recipes['Material 7'][i]: recipes['#7'][i]}])
        del_key =''
        for j in test[i]:
            if del_key in j:
                del j[del_key]
        test[i] = list(filter(None, test[i]))
        
    recipes['Recipe'] = test
    recipes = recipes.drop(['#1', '#2', '#3','#4', '#5', '#6', 'Material 1','Material 2','Material 3',
                  'Material 4','Material 5','Material 6'], axis=1)
    
    names = list(recipes['Name'])
    R = pd.DataFrame(columns = userMats['Material'], index=names)
    
    for i in range(len(recipes)) :
        for mat in prices['Material']:
            if mat in recipes['Recipe'][i][0].keys():
                R[mat][i] = recipes['Recipe'][i][0][mat]
    R = R.fillna(0)
    R = R.apply(pd.to_numeric)
                
    S = recipes[['Name', 'Sell']]
    S = S.set_index('Name')
     
    P = prices[['Material', 'Sell Price']]
    P = P.set_index('Material')
    
    K = userMats.set_index('Material')
    K['Quantity'] = K['Quantity'].fillna(0)
    return R.T, S, P, K
#return R, S, P

def ACNHopt(recipes, prices, userMats):
    R, S, P, K = cleanData(recipes, prices, userMats)
    
    #--------------------------------------#
    n = R.shape[1]
    m = len(P)
    
    X=cp.Variable((n,1), integer=True)
    rawMat =cp.multiply(cp.matmul(R,X), P)
    diyRev = cp.multiply(S,X)
    
    #Optimization Problem:
    objective = cp.Maximize(cp.sum(diyRev)-cp.sum(rawMat))
    constraints = [X>=0, cp.matmul(R, X) <= K]
    
    prob=cp.Problem(objective,constraints) 
    result=prob.solve(solver='CPLEX')
    optX = pd.DataFrame(X.value, columns = ['Quantity'])
    optX = optX.set_index(recipes['Name'])
    optRecipes = optX.loc[(optX != 0).all(axis=1), :]
    
    left = K-R.dot(optX)
    leftovers = left.loc[(left != 0).all(axis=1), :]
    print('-------------------------------')
    print('Optimal Recipes and Quantities')
    print('-------------------------------')
    print(optRecipes)
    print('-------------------------------')
    print('Expected Profit: ', result, 'Bells')
    print('-------------------------------')
    print('Leftover Materials: ')
    print(leftovers)
    return [optRecipes, result, leftovers]
#####################################################

def default(recipes, prices, userMats):
    R, S, P, K = cleanData(recipes, prices, userMats)
    
    #Identify all feasible recipes:
    Y = pd.DataFrame(columns = ['Sell']).reindex_like(S)
    Y['Sell'] = [int((R[i]<=K['Quantity'].values).all()) for i in R]
    
    #Find the recipe that has the highest sell price
    defaultRecipe = Y.multiply(S).idxmax()
    defaultR = R[defaultRecipe].sort_index()
    K=K.sort_index()
    
    #Determine the quantity to make
    howmany = np.floor(np.divide(K.values, defaultR.values, where=np.multiply(defaultR.values, K.values)>=1))
    defaultQuantity = min(i[0] for i in howmany if i[0]>=1)
    sellprice = S.Sell[defaultRecipe.values[0]]
    default = pd.DataFrame({'Quantity': defaultQuantity}, index=[defaultRecipe.values[0]])
    
    #Calculate profit
    rev = sellprice*defaultQuantity
    costs = P.transpose().dot(defaultR*defaultQuantity).values[0][0]
    profit = rev-costs
    left =K.values-defaultR*defaultQuantity
    leftovers = left.loc[(left != 0).all(axis=1), :]
    leftovers = leftovers.rename(columns = {defaultRecipe.values[0]: 'Quantity'})
    print('-------------------------------')
    print('-------------------------------')
    print('Default Recipe and Quantity')
    print('-------------------------------')
    print(default)
    print('-------------------------------')
    print('Expected Default Action Profit: ', profit, ' Bells')
    print('-------------------------------')
    print('Leftover Materials: ')
    print(leftovers)
    return [default, profit, leftovers]

##################################################################

OptRecipes, Profit, LeftoverMats = ACNHopt(recipes, prices, userMats)
default, prof, left = default(recipes, prices, userMats)

stop = timeit.default_timer()
print('-------------------------------')
print('Time to Run: ', stop - start)
#####################################################################

#Test
# optVector = []
# defVector = []
# for i in range(30):
#     testArray = pd.DataFrame({'Material' :userMats.Material.values, 'Quantity': np.floor(np.random.rand(140,)*10)})

#     opt = ACNHopt(recipes,prices, testArray)
#     defaults = default(recipes, prices, testArray)
#     optVector.append(opt[1])
#     defVector.append(defaults[1])

# print('Optimal Profit: ', opt[1])
# print('Default Profit: ', defaults[1])

# diff = np.array(optVector)-np.array(defVector)
# save = pd.DataFrame({'Optimization Profit' : np.array(optVector), 'Default Profit' :np.array(defVector), 'Difference':diff})
# save.to_csv('data/diff.csv')
