
import pandas as pd
import numpy as np
import matplotlib
from matplotlib import pylab
from sklearn import cross_validation

matplotlib.use('agg')


val =  pd.read_csv('sixup.csv')
col_names = val.columns.values

X = np.array([val.icol(i) for i in range(2,10)])
N = len(X)
X = X.transpose()

Y = np.array(val['Max of Federal Loan 3-Year Default Rate'])
##break into training and testing sets of data
X_train, X_test, y_train, y_test = cross_validation.train_test_split(X, Y, test_size=0.3, random_state=0)


from sklearn.linear_model import LinearRegression
regression = LinearRegression()
regression.fit(X_train,y_train)
print 'training coefficients: ', regression.coef_
print 'rsquared: ', regression.score(X_train,y_train), '\n'

regression_test = LinearRegression()
regression_test.fit(X_test,y_test)

print 'test coefficients: ', regression_test.coef_
print 'rsquared: ', regression_test.score(X_test,y_test)

matplotlib.pyplot.plot(regression.predict(X_test)-y_test)
