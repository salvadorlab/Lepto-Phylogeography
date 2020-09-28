library("adegenet")
library("adegraphics")
library("rgl")
library(treespace)
library(phytools)
library(phangorn)
tree_path <- "/Users/rachel/Desktop/global_iqtree/"

nuc_tree <- read.tree(paste0(tree_path,"rename_interrogans.treefile"))
aa_tree <- read.tree(paste0(tree_path,"rename_interrogans_aa.treefile"))
# nuc_tree <- midpoint.root(nuc_tree)
# aa_tree <- midpoint.root(aa_tree)
plotTreeDiff(nuc_tree,aa_tree)

diff_tip <- tipDiff(nuc_tree,aa_tree)
treeDist(nuc_tree,aa_tree) # Kendall Colijn metric
treedist(nuc_tree,aa_tree) # Robinson-Foulds or symmetric distance
