


# Setup -------------------------------------------------------------------


pacman::p_load(dplyr, wrapr, readr, feather, stringr, parallel, foreach, doParallel)


countries <- list.dirs('Data/Trolls', recursive = F)




# Extract troll IDs -------------------------------------------------------


# Unzip


# foreach(country = countries, .verbose = T) %dopar% {
for (country in countries) {
  
  print(country)
    
  sapply(list.files(country, recursive = T, pattern = 'tweets.*\\.zip',
             full.names = T), function(x)
    unzip(zipfile = x, exdir = country, overwrite = F) ) 
  
  
  invisible(
    lapply(list.files(country,
               recursive = T, pattern = 'tweets.*csv$',
               full.names = T), function(y) {
      
      read_csv(y, col_names = T, col_types = cols(.default = 'c')) %>% 
      select(tweetid, userid, user_screen_name) %>% 
      bind_rows() %>% 
      subset(nchar(userid) <= 70 ) %>% 
      
      write_rds(., path = str_replace(y, 'Trolls/.*/', 'TrollHandles/') %>% 
                  str_replace('.csv$', '.Rds') )
                 
               } )
  )
  
  
  # clean up
  file.remove( list.files(country, recursive = T, pattern = 'tweets.*\\.csv',
                full.names = T) )
  
  

}













