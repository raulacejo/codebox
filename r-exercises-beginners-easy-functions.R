# source: http://r-tutorials.com/r-exercises-beginners-easy-functions/


# 1.

# a. Write a function “myfun” of x to the power of its index position (x, x^2, x^3, …)

myfun = function(x){
  x ^ (1 : length(x))
}

# b. Test the function with an x of 1:10

myfun(1:10)

# c. Enlarge the function “myfun” with a division through the index position (x, x^2 / 2, x^3 /3, …)

myfun = function(x){
  (x ^ (1 : length(x))/(1 : length(x)))
}

myfun(1:10)	

# --------------------------------------------------------------------------------------------------

# 2.

# a. Write a simple moving average function (length = 3)

mySMA = function(x){
  n = length(x)
  (x[1:(n-2)] + x[2:(n-1)] + x[3:n] )/3
}

# b. Use it on the lynx dataset

mySMA(lynx)

# c. Plot the SMA line against the original datset in a base plot
# Hint: get the SMA object in a time series class and start at the beginning of lynx+2

SMAline = ts(mySMA(lynx), start = 1823)

plot(lynx)
lines(SMAline, col ="red")

