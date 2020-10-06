setwd("/Users/benbaer/Box Sync/school/research/Hexagon/")
periods <- read.csv("periods30-60_3814.csv", header=FALSE)
colnames(periods) <- c('x', 'y', 'lo', 'hi')

#### transform x and y to different fundamental domains of \theta ####
## 60-90
# # from hitting first 60 left leaning incline...
# # find tan(\theta+30) using angle sum formula
# # conclusion: there's nothing here
old.x <- periods$x
old.y <- periods$y

periods$x <- 3*old.x-old.y
periods$y <- 3*old.y+old.x

periods <- periods[periods$x>0 & periods$y>0,]

## 0-30
# old.x <- periods$x
# old.y <- periods$y
# 
# periods$x <- 3*old.x+old.y
# periods$y <- 3*old.y-old.x
# 
# periods[periods$x>0 & periods$y>0,]


#### do the computation ####
# code to find partitions that are linear inside part
check_if_planar <- function(small.dat) {
  a <- small.dat[1,]
  b <- small.dat[2,]
  c <- small.dat[3,]
  d <- small.dat[4,]
  # takes in 4 points and returns TRUE/FALSE for whether plane, and line if on a plane
  crossProduct <- function(ab,ac){
    abci = ab[2] * ac[3] - ac[2] * ab[3]
    abcj = ac[1] * ab[3] - ab[1] * ac[3]
    abck = ab[1] * ac[2] - ac[1] * ab[2]
    return(c(abci, abcj, abck))
  }
  cp <- crossProduct(b-a, c-a)
  names(cp) <- c('x', 'y', 'period')
  if (sum(abs(cp))<10^(-5)) return(list(is.planar=FALSE, coefs=NA)) # sometimes cp is zero if they're colinear...
  if (abs(sum((d-a)*cp))==0) { # if planar
    #if ((cp[1]*cp[3]<0) & (cp[2]*cp[3]<0)) { # all real formulas should have positive coefs on x and y
      return(list(is.planar=TRUE, coefs=c(cp, 'k'=sum(cp*a))))
    #}
  }
  return(list(is.planar=FALSE, coefs=NA))
}

remove_rows <- function(dat, coefs.lo, coefs.hi) {
  is.on.plane <- function(point, coefs.lo, coefs.hi) {
    if (sum(coefs.lo[-4]*point[-4])==coefs.lo[4] & sum(coefs.hi[-4]*point[-3])==coefs.hi[4]) return(TRUE)
    return(FALSE)
  }
  to_remove <- apply(dat, 1, function(point) is.on.plane(point, coefs.lo, coefs.hi))
  return(list(dat[!to_remove,,drop=FALSE], to_remove))
}

# run main code
dat <- as.matrix(periods)
rownames(dat) <- 1:nrow(dat)
groups <- list()
planes.lo <- list()
planes.hi <- list()
groups_num <- rep(NA, nrow(dat))
iter.count <- 0
while (TRUE) {
  iter.count <- iter.count+1

  inds <- sample(nrow(dat), 4, replace=FALSE) # randomly pick 4 points to check if planar
  whether.planar.lo <- check_if_planar(dat[inds,-4])
  whether.planar.hi <- check_if_planar(dat[inds,-3])
  if (whether.planar.lo$is.planar & whether.planar.hi$is.planar) { # if hi and lo are both planar
    out <- remove_rows(dat, whether.planar.lo$coefs, whether.planar.hi$coefs) # find which points are on plane
    if (sum(out[[2]])>30) { # at least this many points on plane... increase if finding bad planes
      groups <- c(groups, list(rownames(dat)[out[[2]]]))
      planes.lo <- c(planes.lo, list(whether.planar.lo$coefs))
      planes.hi <- c(planes.hi, list(whether.planar.hi$coefs))
      groups_num[(1:length(groups_num)) %in% rownames(dat)[out[[2]]]] <- iter.count
      
      dat <- out[[1]]
    }
    #print(paste("iter count=",iter.count,'; nrows=',nrow(dat)))
  }
  if (iter.count>=10^4 | nrow(dat)<=4) break
}

# check number of groups it found
length(groups)

# lol just checking mixture moddeling for fun--not necessary with lots of data
# flexmix::parameters(flexmix::flexmix(lo~x+y, data=periods, cluster=groups_num), component=2)
# clusters(flexmix::flexmix(lo~x+y, data=periods, k=10))

#### analysing the output ####
# grouping into separate dfs
grouped_periods <- lapply(groups, function(grp) periods[grp,])

# quick overlook of example point and the formula
groups.presented <- cbind(plyr::laply(grouped_periods, 
                  function(d) {
                    d <-unlist(d[1,1:2]); 
                    names(d)<-c('x.example','y.example');
                    return(d)
                  }), 
      plyr::laply(planes.lo, 
                  function(v) {
                    v <- v/v[3]; 
                    v<-v[-3]; 
                    v[3]<--v[3];
                    names(v) <- c('x.lo', 'y.lo', 'k.lo')
                    return(-v[c(2,1,3)])
                  }), 
      plyr::laply(planes.hi, 
                  function(v) {
                    v <- v/v[3]; 
                    v<-v[-3]; 
                    v[3]<--v[3];
                    names(v) <- c('x.hi', 'y.hi', 'k.hi')
                    return(-v[c(2,1,3)])
                  })
      )

# get modulo values for ones we know matter
get_mod_vals <- function(c) { ## change this to llply if giving an error--this is assuming unique output
  plyr::laply(grouped_periods, function(dat) paste0(unique(((c[1]*dat[,1]+c[2]*dat[,2])%%c[3])), collapse=','))
}
interesting.cs <- matrix(byrow=TRUE, ncol=3, c(c(1,0,3),c(1,-1,2),c(-1,3,3),c(-1,6,3)))
rownames(interesting.cs) <- c('x.mod.3', 'y.M.x.mod.2', '3y.M.x.mod.3', '6y.M.x.mod.3')
mod.vals <- apply(interesting.cs, 1, get_mod_vals)

all_together <- data.frame(groups.presented, mod.vals)
all_together <- all_together[order(all_together$x.mod.3,all_together$y.M.x.mod.2),]
all_together

#write.csv(all_together,'lowandhigh_hexagon_30_60.csv')





#### check for any linear combo to separate groups that don't appear separated in mod.vals ####
# my_groups <- c(8,11)
# cool.func <- function(rr) {
#   c1 <- rr[1]; c2 <- rr[2]; c3 <- rr[3];
#   a <- lapply(grouped_periods[my_groups], function(dat) levels(as.factor(((c1*dat[,1]+c2*dat[,2])%%c3))))
#   length(intersect(a[[1]], a[[2]]))==0
# }
# val <- 36
# my.grid <- expand.grid((-val):val, (-val):val, 2:(val/3))
# my.grid <- cbind(my.grid, apply(my.grid, 1, cool.func))
# my.grid[my.grid[,4],]


#### plot output! ####
# library(ggplot2)
# cond <- periods$x==sample(periods$x,1)
# top <- periods[cond,]
# my.color <- groups_num[cond]#paste0((top$x-top$y) %% 2,',', (6*top$y-top$x) %% 3)
# qplot(top$y, top$lo, col=as.factor(my.color))
