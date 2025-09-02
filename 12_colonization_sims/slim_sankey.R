library(plotly)


sankey <- plot_ly(
  type="sankey",
  orientation="h",
  arrangement="snap",
  
  node = list(
    label = c("Source",
              "B", "BN", "BL", "BK","BNL","BNK", "BNLK", "BNKL", "BLN", "BLK", "BLNK", "BLKN", "BKL", "BKLN",
              "N", "NB","NBL","NBK","NBLK","NBKL",
              "L", "LB", "LBK", "LBKN",
              "K", "KL", "KLB", "KLBN",
              "NK","NKB","NKBL",
              "KN","KNB", "KNBL", "KB", "KBN", "KBNL"),
    color = c("black",
              "green", "orange", "tan", "purple", "tan", "purple", "purple", "tan", "orange", "purple", "purple", "orange", "tan", "orange",
              "orange", "green", "tan", "purple", "purple", "tan",
              "tan", "green", "purple", "orange",
              "purple", "tan", "green", "orange",
              "purple", "green", "tan")
  ),
  
  link = list(
    source = c(0,1,1,1,2,2,5,6,3,3, 9, 10,#4, 13,
               0, 15,16,16,17,18,15,29,30,
               0, 21,22,23,
               0, 25,26,27,25,32,33,25,35,36),
    target = c(1,2,3,4,5,6,7,8,9,10,11,12,#13,14,
               15,16,17,18,19,20,29,30,31,
               21,22,23,24,
               25,26,27,28,32,33,34,35,36,37),
    value = c(649,621,28,0,610,11,610,11,10,18,10,18,#0,0,
              273,272,267,5,267,5,1,1,1,
              1,1,1,1,
              7,2,2,2,2,2,2,3,3,3
              )
  )
)
sankey

sankey <- plot_ly(
  type="sankey",
  orientation="h",
  
  node = list(
    label = c("OG","B1", "N1", "L1", "K1", "B2", "N2", "L2", "K2", "B3", "N3", "L3", "K3", "B4", "N4", "L4", "K4"),
    color = c("black","green", "orange", "tan", "purple", "green", "orange", "tan", "purple", "green", "orange", "tan", "purple", "green", "orange", "tan", "purple")
  ),
  
  link = list(
    source = c(0,0,0,0,1,1,1,2,3),
    target = c(1,2,3,4,6,7,8,5,5),
    value = c(75,25,1,1,70,4,1,25,1)
  )
)
sankey
