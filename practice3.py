##so I want a class that just gathers the info from a user
##with that information I'll do something useful later but for now, just have a discrete search instance

from pandas import DataFrame,Series
from food2fork import food2fork

class Recipe_search(object):
    def __init__(self):
        self.ingredients = []
        
    def call_api(self):
        ## search food2fork api for 30 results.
        ## could jus be searched independently at have the results shown
    
        f2f = food2fork("42fbfb9eb6159d93b1dfbabc502ee380")
        searched_item = str(self.ingredients)
        recipe = f2f.search(searched_item)
        foodtable=DataFrame(recipe['recipes'])
        recipe_ids = list(foodtable['recipe_id'])
        
        recipe_list =[f2f.getRecipe(i) for i in recipe_ids]
        
        ing = []
        inglist=[]
        
        for x in range(30):
            ing.append(DataFrame(recipe_list[x]).loc['ingredients'])
        
        for i in ing:
            inglist.append(i)
        
        df = DataFrame({'title': foodtable['title'],
                    'recipe_id': foodtable['recipe_id'],
                    'ingredients': Series(ing)})

        return df
    def get_ingredients(self):
        ##shoud prompt for users to input what they have
        ctr = 0
        while(ctr < 2 ):#limiting a number of ingredients, we'll assume they have seasoning unless it's rare.
            self.ingredients.append(raw_input("what do you have? Enter: "))
            ctr += 1
        return 'you have: ',self.ingredients
        ## at this point it returns the ingredient list
        ## i want to compare ingredients with what I have in the list
    
    
    
## looking at the data for one item to test!
f2f = food2fork("42fbfb9eb6159d93b1dfbabc502ee380")

    ##shoud prompt for users to input what they have
ctr = 0
ingredients = []
while(ctr < 2 ):#limiting a number of ingredients, we'll assume they have seasoning unless it's rare.
    ingredients.append(raw_input("what do you have? Enter: "))
    ctr += 1

searched_item = ", ".join(ingredients)
recipe = f2f.search(searched_item)

foodtable=DataFrame(recipe['recipes'])
recipe_ids = list(foodtable['recipe_id'])



recipe_list =[f2f.getRecipe(i) for i in recipe_ids]



food_names = foodtable['title']
ing = []
inglist=[]

for x in range(30):
    ing.append(DataFrame(recipe_list[x]).loc['ingredients'])

    for i in ing:
        inglist.append(i)

df = DataFrame({'title': foodtable['title'],
                'recipe_id': foodtable['recipe_id'],
                'ingredients': Series(ing)})
print df