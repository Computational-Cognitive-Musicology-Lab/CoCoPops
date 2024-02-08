

files <- dir(path = '~/Bridge/Research/Data/CoCoPops/Billboard/Data', full.names = TRUE, 
             pattern = 'merged_')

path.to.compare <- '~/Bridge/Research/Data/CoCoPops/Billboard/Data/'

comparisons <- paste0(path.to.compare, basename(files))
comparisons <- gsub('_timestamped', '', comparisons) # removing any differences in file names

if (any(!file.exists(comparisons))) stop("This requires that all your 'files' have equivalent files in the path.to.compare.")

comp <- function(i) {
  file <- files[i]
  comp <- comparisons[i]
  
  file <- gsub('\t\t*$', '', file)
  
  file <- readLines(file) |> strsplit(split = '\t') |> stringi::stri_list2matrix() |> t()
  orig <- readLines(comp) |> strsplit(split = '\t') |>  stringi::stri_list2matrix() |> t()
  
  # orig <- orig[ , c(1, 2, 4,3, 5)]
  
  out <- file 
  out[file == orig] <- ''
  
  which(con != orig, arr.ind = TRUE)[,'col'] |> unique()
  
  # out <- cbind(file[,3], orig[,3])
  # out[!(is.na(out[,1]) | is.na(out[,2])), ]
}

sapply(seq_along(files), comp)
