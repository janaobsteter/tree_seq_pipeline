setwd("~/EddieDir/jobsteter/HBTS/tree_seq_pipeline_Reduced/Snakemake/Project/Tsinfer/statistics/")

#FstPop
fstPop <- read.csv("FstPop.csv")
fstPop$GroupPair1 <- paste0(fstPop$Pop1, "_", fstPop$Pop2)
fstPop$GroupPair2 <- paste0(fstPop$Pop2, "_", fstPop$Pop1)

pops = unique(c(fstPop$Pop1, fstPop$Pop2))
fstHeatMap <- expand.grid(pops, pops)
fstHeatMap$GroupPair <- paste0(fstHeatMap$Var1, "_", fstHeatMap$Var2)
fstHeatMap <- merge(fstHeatMap, fstPop[, c("GroupPair1", "Fst")], by.x = "GroupPair", by.y = "GroupPair1", all.x=T)
fstHeatMap <- merge(fstHeatMap, fstPop[, c("GroupPair2", "Fst")], by.x = "GroupPair", by.y = "GroupPair2", all.x=T)
fstHeatMap$Fst <- ifelse(!is.na(fstHeatMap$Fst.x), fstHeatMap$Fst.x, fstHeatMap$Fst.y)


triAngNames <- apply(t(combn(pops, 2, simplify = TRUE)), MARGIN = 1, FUN = function(x) paste(x[1], x[2],sep="_"))

#fstNonHybrid <- fstHeatMap[(fstHeatMap$Var1 != "hybrid") & (fstHeatMap$Var2 != "hybrid"),]
popsFst <- ggplot(fstHeatMap[fstHeatMap$GroupPair %in% triAngNames,], aes(x = Var2, y = Var1)) +
  geom_tile(aes(fill = Fst)) + scale_fill_viridis(na.value="black") + 
  theme_bw(base_size = 18) + 
  theme(panel.grid = element_blank(), axis.title = element_blank(),
        axis.text.x = element_text(angle = 90)) + theme(legend.position = "top")
popsFst

#FstSubPop
fstSubpop <- read.csv("FstSubpop.csv")
fstSubpop$GroupPair1 <- paste0(fstSubpop$Subpop1, "_", fstSubpop$Subpop2)
fstSubpop$GroupPair2 <- paste0(fstSubpop$Subpop2, "_", fstSubpop$Subpop1)

subpops = unique(c(fstSubpop$Subpop1, fstSubpop$Subpop2))
fstHeatMapS <- expand.grid(subpops, subpops)
fstHeatMapS$GroupPair <- paste0(fstHeatMapS$Var1, "_", fstHeatMapS$Var2)
fstHeatMapS <- merge(fstHeatMapS, fstSubpop[, c("GroupPair1", "Fst")], by.x = "GroupPair", by.y = "GroupPair1", all.x=T)
fstHeatMapS <- merge(fstHeatMapS, fstSubpop[, c("GroupPair2", "Fst")], by.x = "GroupPair", by.y = "GroupPair2", all.x=T)
fstHeatMapS$Fst <- ifelse(!is.na(fstHeatMapS$Fst.x), fstHeatMapS$Fst.x, fstHeatMapS$Fst.y)


triAngNamesS <- apply(t(combn(subpops, 2, simplify = TRUE)), MARGIN = 1, FUN = function(x) paste(x[1], x[2],sep="_"))

#fstNonHybrid <- fstHeatMap[(fstHeatMap$Var1 != "hybrid") & (fstHeatMap$Var2 != "hybrid"),]
subpopsFst <- ggplot(fstHeatMapS[fstHeatMapS$GroupPair %in% triAngNamesS,], aes(x = Var2, y = Var1)) +
  geom_tile(aes(fill = Fst)) + scale_fill_viridis(na.value="black") + 
  theme_bw(base_size = 18) + 
  theme(panel.grid = element_blank(), axis.title = element_blank(),
        axis.text.x = element_text(angle = 90)) + theme(legend.position = "top")
subpopsFst


#TajimasD
tajimaDPop <- read.csv("TajimaDPop.csv")
tajimaDSubpop <- read.csv("TajimaDSubpop.csv")

pops <- tajimaDPop$Pop
popTajimaD <- ggplot(tajimaDPop, aes(x = Pop, y = TajimaD, fill = Pop)) +
  geom_col() + scale_fill_viridis("", na.value="black", discrete = T) + 
  theme_bw(base_size = 18) + 
  theme(panel.grid = element_blank(), axis.title = element_blank(),
        axis.text.x = element_text(angle = 90)) + 
  theme(legend.position = "right")
popTajimaD

subpops <- tajimaDSubpop$Subpop
subpopTajimaD <- ggplot(tajimaDSubpop, aes(x = Subpop, y = TajimaD, fill = Subpop)) +
  geom_col() + scale_fill_viridis("", na.value="black", discrete = T) + 
  theme_bw(base_size = 18) + 
  theme(panel.grid = element_blank(), axis.title = element_blank(),
        axis.text.x = element_text(angle = 90)) + 
  theme(legend.position = "right")
subpopTajimaD


#TajimasD
tajimaDPop <- read.csv("TajimaDPop.csv")
tajimaDSubpop <- read.csv("TajimaDSubpop.csv")

pops <- tajimaDPop$Pop
popTajimaD <- ggplot(tajimaDPop, aes(x = Pop, y = TajimaD, fill = Pop)) +
  geom_col() + scale_fill_viridis("", na.value="black", discrete = T) + 
  theme_bw(base_size = 18) + 
  theme(panel.grid = element_blank(), axis.title = element_blank(),
        axis.text.x = element_text(angle = 90)) + 
  theme(legend.position = "right")
popTajimaD

subpops <- tajimaDSubpop$Subpop
subpopTajimaD <- ggplot(tajimaDSubpop, aes(x = Subpop, y = TajimaD, fill = Subpop)) +
  geom_col() + scale_fill_viridis("", na.value="black", discrete = T) + 
  theme_bw(base_size = 18) + 
  theme(panel.grid = element_blank(), axis.title = element_blank(),
        axis.text.x = element_text(angle = 90)) + 
  theme(legend.position = "right")
subpopTajimaD
