# jaccard_index_p_values.R

# Purpose: Helper function for clusterSystems
# not useful elsewhere

# Author: Rachel Silverstein

jaccard_index_p_values <- function(systems,
                                   jaccard_indexes,
                                   best_matches,
                                   clusters,
                                   trials = 1000) {
  p_values <- numeric(length = length(systems))
  names(p_values) <- names(systems)
  all_genes <- unique(unlist(systems))

  for (i in seq_along(systems)) {
    observed_jaccard <- jaccard_indexes[i]
    clust_num <- best_matches[i]
    clust <- clusters[clusters == clust_num]
    system <- unlist(systems[[i]])
    count <- 0 # count how many random permutations have greater jaccard index than observed
    for (j in seq(1:trials)) {
      random_genes <- sample(all_genes, size = length(clust), replace = FALSE)
      int <- length(intersect(random_genes, system))
      union_size <- length(union(system, random_genes))
      jaccard <- int / union_size
      if (jaccard >= observed_jaccard) {
        count <- count + 1
      }
    }
    p_values[i] <- count / trials
  }
  return(p_values)
}
