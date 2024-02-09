

files <- dir(path = '~/Bridge/Research/Data/CoCoPops/Billboard/Data', full.names = TRUE, 
             pattern = 'hum$|harm$')

path.to.compare <- '~/Bridge/Research/Data/CoCoPops/Billboard/Resources/Scripts/timestamps/'

# comparisons <- paste0(path.to.compare, basename(files))
# comparisons <- gsub('_timestamped', '', comparisons) # removing any differences in file names
comparisons <-  dir(path = '~/Bridge/Research/Data/CoCoPops/Billboard/Resources/Scripts/timestamps/', full.names = TRUE, 
                    pattern = 'hum$|harm$')

if (any(!file.exists(comparisons))) stop("This requires that all your 'files' have equivalent files in the path.to.compare.")

files <- files[basename(files) %in% gsub('_timestamped', '.varms', basename(comparisons))]

comparisons <- comparisons[gsub('_timestamped', '.varms', basename(comparisons)) %in% basename(files)]
comparisons <- comparisons[match(basename(files), gsub('_timestamped', '.varms', basename(comparisons)))]

comp <- function(i) {
  file <- files[i]
  comp <- comparisons[i]
  
  file <- gsub('\t\t*$', '', file)
  
  file <- readLines(file) |> strsplit(split = '\t') |> stringi::stri_list2matrix() |> t()
  orig <- readLines(comp) |> strsplit(split = '\t') |>  stringi::stri_list2matrix() |> t()
  
  # orig <- orig[ , c(1, 2, 4,3, 5)]
  
  out <- file 
  
  # which(comp != orig, arr.ind = TRUE)[,'col'] |> unique()
  
  if (all(dim(file) == dim(orig))) {
  out[file == orig] <- ''
  output <- array('', dim = dim(file))
  
  
  
  diff <- !is.na(file) & !is.na(orig) & file != orig
  
  if (!any(diff)) {print('yay!');return(TRUE)}
  output[diff] <- paste(file[diff], orig[diff], sep = ':::')
  
  good <- all(output[diff] %in% c('r:::N', '1N:::1r', '2N:::2r', '4N:::4r', '2.N:::2.r', '1.N:::1.r', '4.N:::4.r'))
  
  if (!good) print(unique(output[diff]))
 
  cat('Copying', comp, 'to', file, '\n')
  file.rename(comp, files[i])
  good
  } else {
    FALSE
  }
    
  # out <- cbind(file[,3], orig[,3])
  # out[!(is.na(out[,1]) | is.na(out[,2])), ]
}


nontrivial <- which(!sapply(seq_along(files),comp))
print(length(nontrivial))
k <- length(nontrivial); paste0('vimdiff ', files[nontrivial[k]], ' ', comparisons[nontrivial[k]]) |> clipr::write_clip()
