
library(RCurl)
library(RJSONIO)
library(plyr)

url <- function(address, return.call = "json", sensor = "false") {
  root <- "http://food2fork.com/api/search"
  u <- paste(root, return.call, "?address=", address, "&sensor=", sensor, sep = "")
  return(URLencode(u))
}


geoCode <- function(address,verbose=FALSE) {
  if(verbose) cat(address,"\n")
  u <- url(address)
  doc <- getURL(u)
  x <- fromJSON(doc,simplify = FALSE)
  if(x$status=="OK") {
    lat <- x$results[[1]]$geometry$location$lat
    lng <- x$results[[1]]$geometry$location$lng
    location_type  <- x$results[[1]]$geometry$location_type
    formatted_address  <- x$results[[1]]$formatted_address
    return(c(lat, lng, location_type, formatted_address))
    Sys.sleep(0.5)
  } else {
    return(c(NA,NA,NA, NA))
  }
}


#Facebook API 
fqlQuery='select share_count,like_count,comment_count from link_stat where url="'
url="http://www.theguardian.com/world/2014/mar/03/ukraine-navy-officers-defect-russian-crimea-berezovsky"
queryUrl = paste0('http://graph.facebook.com/fql?q=',fqlQuery,url,'"')  #ignoring the callback part
lookUp <- URLencode(queryUrl) #What do you think this does?
lookUp

#Read it in:
require(rjson)
rd <- readLines(lookUp, warn="F") 
dat <- fromJSON(rd)
dat


class food2fork():
  
  '''
Usage:
import food2fork
f2f = food2fork("My Api Key")
recipes = f2f.search("chicken, rice")
moreRecipes = f2f.search("chicken, rice", 2)
'''

def __init__(self,apiKey, debug=False):
  self.apiKey = apiKey

self.debugMode = debug

self.SEARCH_ENDPOINT = 'http://food2fork.com/api/search'
self.VIEW_ENDPOINT   = 'http://food2fork.com/api/get'
self.MAX_PAGESIZE = 30

def search(self,query,page = 1,pageSize = 30):
  try:
  url = self._urlHelper(self.SEARCH_ENDPOINT,q=query,page=page,count=pageSize)

contents = self._getUrlContents(url)

data = json.loads(contents)

if(self.debugMode): print contents

return data

except Exception as inst:
  if(self.debugMode): print inst

return None

def getTopRated(self,page = 1,pageSize = 30):
  if(pageSize > self.MAX_PAGESIZE): pageSize = self.MAX_PAGESIZE

try:
  url = self._urlHelper(self.SEARCH_ENDPOINT,page=page,count=pageSize,sort='r')

contents = self._getUrlContents(url)

data = json.loads(contents)

if(self.debugMode): print contents

return data

except Exception as inst:
  if(self.debugMode): print inst

return None

def getTrending(self,page = 1,pageSize = 30):
  try:
  url = self._urlHelper(self.SEARCH_ENDPOINT,page=page,count=pageSize,sort='t')

contents = self._getUrlContents(url)

data = json.loads(contents)

if(self.debugMode): print contents

return data
except Exception as inst:
  if(self.debugMode): print inst

return None

def getRecipe(self,recipeId):
  try:
  url = self._urlHelper(self.VIEW_ENDPOINT,rId=recipeId)

contents = self._getUrlContents(url)

data = json.loads(contents)

return data

except Exception as inst:
  if(self.debugMode): print inst

return None

def _urlHelper(self,endpoint,**kwargs):
  data = { 'key' : self.apiKey }

for key, value in kwargs.iteritems():
  data[key] = value

if(self.debugMode):
  print "Url:", endpoint + '?' + urllib.urlencode(data)

return endpoint + '?' + urllib.urlencode(data)

def _getUrlContents(self,url):
  try:
  response = urllib2.urlopen(url)

contents = response.read()

return contents

except Exception as inst:
  if(self.debugMode): print inst

return None

## looking at the data for one item to test!
f2f = food2fork("42fbfb9eb6159d93b1dfbabc502ee380")

recipe = f2f.search("shredded Chicken")

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



