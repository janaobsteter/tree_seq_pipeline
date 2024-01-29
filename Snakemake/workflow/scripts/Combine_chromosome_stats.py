import pandas as pd
import sys

noChromosomes = sys.argv[1]
fileDir = sys.argv[2]
chrNums = range(1, int(noChromosomes) + 1)

# fstPop = sys.argv[1]
# fstSubpop = sys.argv[2]
# tajimaDPop = sys.argv[3]
# tajimaDSubpop = sys.argv[4]
# diversityPop = sys.argv[5]
# diversitySubpop = sys.argv[6]
# gnn = sys.argv[7]
#
fstPopOutput = sys.argv[3]
fstSubpopOutput = sys.argv[4]
tajimaDPopOutput = sys.argv[5]
tajimaDSubpopOutput = sys.argv[6]
diversityPopOutput = sys.argv[7]
diversitySubpopOutput = sys.argv[8]
gnnOutput = sys.argv[9]




genome = {
    "assembly_accession": "GCA_003254395.2",
    "assembly_name": "Amel_HAv3.1",
    "chromosomes": {
        "CM009931.2": {"length": 27754200, "synonyms": ["NC_037638.1"]},
        "CM009932.2": {"length": 16089512, "synonyms": ["NC_037639.1"]},
        "CM009933.2": {"length": 13619445, "synonyms": ["NC_037640.1"]},
        "CM009934.2": {"length": 13404451, "synonyms": ["NC_037641.1"]},
        "CM009935.2": {"length": 13896941, "synonyms": ["NC_037642.1"]},
        "CM009936.2": {"length": 17789102, "synonyms": ["NC_037643.1"]},
        "CM009937.2": {"length": 14198698, "synonyms": ["NC_037644.1"]},
        "CM009938.2": {"length": 12717210, "synonyms": ["NC_037645.1"]},
        "CM009939.2": {"length": 12354651, "synonyms": ["NC_037646.1"]},
        "CM009940.2": {"length": 12360052, "synonyms": ["NC_037647.1"]},
        "CM009941.2": {"length": 16352600, "synonyms": ["NC_037648.1"]},
        "CM009942.2": {"length": 11514234, "synonyms": ["NC_037649.1"]},
        "CM009943.2": {"length": 11279722, "synonyms": ["NC_037650.1"]},
        "CM009944.2": {"length": 10670842, "synonyms": ["NC_037651.1"]},
        "CM009945.2": {"length": 9534514, "synonyms": ["NC_037652.1"]},
        "CM009946.2": {"length": 7238532, "synonyms": ["NC_037653.1"]},
        "CM009947.2": {"length": 16343, "synonyms": ["NC_001566.1", "MT"]},
    },
}

chromosomes = genome['chromosomes']
chrLengths = [value['length'] for value in chromosomes.values()]
chrPer = [x / sum(chrLengths) for x in chrLengths]

##############################
# FstPop
for chrNum in chrNums:
    fstPopDF = pd.read_csv(fileDir + "/Chr" + str(chrNum) + "_FstPop.csv")
    fstSubpopDF = pd.read_csv(fileDir + "/Chr" + str(chrNum) + "_FstSubpop.csv")
    tajimaDPopDF = pd.read_csv(fileDir + "/Chr" + str(chrNum) + "_TajimaDPop.csv")
    tajimaDSubpopDF = pd.read_csv(fileDir + "/Chr" + str(chrNum) + "_TajimaDSubpop.csv")
    diversityPopDF = pd.read_csv(fileDir + "/Chr" + str(chrNum) + "_DiversityPop.csv")
    diversitySubpopDF = pd.read_csv(fileDir + "/Chr" + str(chrNum) + "_DiversitySubpop.csv")
    gnnDF = pd.read_csv(fileDir + "/Chr" + str(chrNum) + "_Gnn.csv")
    if chrNum == 1:
        #FstPop
        fstPopDFChrPer = fstPopDF
        fstPopDFChrPer['Fst'] = fstPopDFChrPer['Fst'] * chrPer[chrNum - 1]
        #FstSubpop
        fstSubpopDFChrPer = fstSubpopDF
        fstSubpopDFChrPer['Fst'] = fstSubpopDFChrPer['Fst'] * chrPer[chrNum - 1]
        #TajimaDPop
        tajimaDPopDFChrPer = tajimaDPopDF
        tajimaDPopDFChrPer['TajimaD'] = tajimaDPopDFChrPer['TajimaD'] * chrPer[chrNum - 1]
        #TajimaDSubpop
        tajimaDSubpopDFChrPer = tajimaDSubpopDF
        tajimaDSubpopDFChrPer['TajimaD'] = tajimaDSubpopDFChrPer['TajimaD'] * chrPer[chrNum - 1]
        #DiversityPop
        diversityPopDFChrPer = diversityPopDF
        diversityPopDFChrPer['Diversity'] = diversityPopDFChrPer['Diversity'] * chrPer[chrNum - 1]
        #TajimaDSubpop
        diversitySubpopDFChrPer = diversitySubpopDF
        diversitySubpopDFChrPer['Diversity'] = diversitySubpopDFChrPer['Diversity'] * chrPer[chrNum - 1]
        #Gnn
        gnnDFChrPer = gnnDF.iloc[:, :-3] * chrPer[chrNum - 1]
    else:
        fstPopDFChrPer['Fst'] = fstPopDFChrPer['Fst']  + fstPopDF['Fst'] *  chrPer[chrNum - 1]
        fstSubpopDFChrPer['Fst'] = fstSubpopDFChrPer['Fst']  + fstSubpopDF['Fst'] *  chrPer[chrNum - 1]
        tajimaDPopDFChrPer['TajimaD'] = tajimaDPopDFChrPer['TajimaD']  + tajimaDPopDF['TajimaD'] *  chrPer[chrNum - 1]
        tajimaDSubpopDFChrPer['TajimaD'] = tajimaDSubpopDFChrPer['TajimaD']  + tajimaDSubpopDF['TajimaD'] *  chrPer[chrNum - 1]
        diversityPopDFChrPer['Diversity'] = diversityPopDFChrPer['Diversity']  + diversityPopDF['Diversity'] *  chrPer[chrNum - 1]
        diversitySubpopDFChrPer['Diversity'] = diversitySubpopDFChrPer['Diversity']  + diversitySubpopDF['Diversity'] *  chrPer[chrNum - 1]
        gnnDFChrPer = gnnDFChrPer + gnnDF.iloc[:, :-3] * chrPer[chrNum - 1]


# Add GNN meta back if __name__ == '__main__':
gnnMeta = gnnDF.iloc[:, -3:]
gnnFinal = pd.concat([gnnDFChrPer, gnnMeta], axis = 1)

fstPopDFChrPer.to_csv(fstPopOutput, index = None)
fstSubpopDFChrPer.to_csv(fstSubpopOutput, index = None)
tajimaDPopDFChrPer.to_csv(tajimaDPopOutput, index = None)
tajimaDSubpopDFChrPer.to_csv(tajimaDSubpopOutput, index = None)
diversityPopDFChrPer.to_csv(diversityPopOutput, index = None)
diversitySubpopDFChrPer.to_csv(diversitySubpopOutput, index = None)
gnnFinal.to_csv(gnnOutput, index = None)
