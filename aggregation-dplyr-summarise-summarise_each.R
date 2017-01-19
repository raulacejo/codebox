# source: http://www.milanor.net/blog/aggregation-dplyr-summarise-summarise_each/

# dataset

mtcars <- mtcars %>% 
  tbl_df() %>% 
  select(cyl , mpg, disp) 

# Case 1: Apply one function to one variable

# without group
mtcars %>% 
  summarise (mean_mpg = mean(mpg))

# with  group
mtcars %>% 
  group_by(cyl) %>% 
  summarise (mean_mpg = mean(mpg))

# We could use function summarise_each() as well but, its usage results in a loss of clarity.

# without group
mtcars %>% 
  summarise_each (funs(mean) , mean_mpg = mpg)

# with  group
mtcars %>% 
  group_by(cyl) %>% 
  summarise_each (funs(mean) , mean_mpg = mpg)


# Case 2: apply many functions to one variable

# without group
mtcars %>% 
  summarise (min_mpg = min(mpg), max_mpg = max(mpg))

# with  group
mtcars %>% 
  group_by(cyl) %>% 
  summarise (min_mpg = min(mpg), max_mpg = max(mpg))

# When we apply many functions to one variable, the use of summarise_each() 
# provides a more compact and tidy notation:

# without group
mtcars %>% 
  summarise_each (funs(min, max), mpg)

# with  group
mtcars %>% 
  group_by(cyl) %>% 
  summarise_each (funs(min, max), mpg)

# If we prefer something like: min_mpg and max_mpg we shall rename the functions we call within funs():

# without group
mtcars %>% 
  summarise_each (funs(min_mpg = min, max_mpg = max), mpg)

# with  group
mtcars %>% 
  group_by(cyl) %>% 
  summarise_each (funs(min_mpg = min, max_mpg = max), mpg)


# Case 3: apply one function to many variables

# without group
mtcars %>% 
  summarise(mean_mpg = mean(mpg), mean_disp = mean(disp))

# with  group
mtcars %>% 
  group_by(cyl) %>% 
  summarise(mean_mpg = mean(mpg), mean_disp = mean(disp))

# the use of summarise_each() provides a more compact and tidy notation:

# without group
mtcars %>% 
  summarise_each(funs(mean) , mpg, disp)

# with  group
mtcars %>% 
  group_by(cyl) %>% 
  summarise_each (funs(mean), mpg, disp)

# Possibly we would prefer something like: mean_mpg and mean_disp. 
# In order to achieve this result we shall appropriately rename the 
# variables we pass to ... within summarise_each():

# without group
mtcars %>% 
  summarise_each(funs(mean) , mean_mpg = mpg, mean_disp = disp)

# with  group
mtcars %>% 
  group_by(cyl) %>% 
  summarise_each(funs(mean) , mean_mpg = mpg, mean_disp = disp)


# Case 4: apply many functions to many variables

# without group
mtcars %>% 
  summarise(min_mpg = min(mpg) , min_disp = min(disp), max_mpg = max(mpg) , max_disp = max(disp))

# with a single group
mtcars %>% 
  group_by(cyl) %>% 
  summarise(min_mpg = min(mpg) , min_disp = min(disp), max_mpg = max(mpg) , max_disp = max(disp))

# the use of summarise_each() provides a more compact and tidy notation:

# without group
mtcars %>% 
  summarise_each(funs(min, max) , mpg, disp)

# with a single group
mtcars %>% 
  group_by(cyl) %>% 
  summarise_each(funs(min, max) , mpg, disp)

# Naming output variables with a different notation: i.e. function_variable does not appear 
# to be possible within the call tosummarise_each() This goal has to be achieved with a separate instruction


# without group
mtcars %>% 
  summarise_each(funs(min, max) , mpg, disp) %>%
  setNames(c("min_mpg", "min_disp", "max_mpg", "max_disp"))

# with  group
mtcars %>% 
  group_by(cyl) %>% 
  summarise_each(funs(min, max) , mpg, disp) %>%
  setNames(c("gear", "min_mpg", "min_disp", "max_mpg", "max_disp"))

--

