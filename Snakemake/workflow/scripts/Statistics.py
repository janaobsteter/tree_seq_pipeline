import pandas as pd
import sys
import json
import tskit
import tsinfer


sampleFile = sys.argv[1]
treeFile = sys.argv[2]
metaFile = sys.argv[3]

outFstPop = sys.argv[4]
outFstSubpop = sys.argv[5]
outTajimaPop = sys.argv[6]
outTajimaSubpop = sys.argv[7]
outDiversityPop = sys.argv[8]
outDiversitySubpop = sys.argv[9]
outGnn = sys.argv[10]

samples = tsinfer.load(sampleFile)
ts = tskit.load(treeFile)
meta = pd.read_csv(metaFile)

sample_nodes = [ts.node(n) for n in ts.samples()]
sample_ids = [n.id for n in sample_nodes]
sample_names = [
    json.loads(ts.individual(n.individual).metadata)["name"]
    for n in sample_nodes
]
sample_pops = [
    json.loads(ts.population(n.population).metadata)["pop"]
    for n in sample_nodes
]
sample_subpops = [
    json.loads(ts.population(n.population).metadata)["subpop"]
    for n in sample_nodes
]
# samples_listed_by_population = [
#     ts.samples(population=pop_id)
#     for pop_id in range(ts.num_populations)
# ]
samples_listed_by_all = [ind.nodes for ind in ts.individuals()]
# sample_ids_names = [
#     (n.id, json.loads(ts.individual(n.individual).metadata)["name"])
#     for n in sample_nodes
# ]
#
# sample_id_country = [
#     (id, list(meta.Country[meta.ID == name])[0]) if name in list(meta.ID) else (id, "FRAReud") for id, name in sample_ids_names
# ]


pops = dict()
for (node, pop) in zip(sample_ids, sample_pops):
    if not pop in pops.keys():
        pops[pop] = [node]
    else:
        pops[pop].append(node)
numPops = len(pops.keys())

subpops = dict()
for (node, pop) in zip(sample_ids, sample_subpops):
    if not pop in subpops.keys():
        subpops[pop] = [node]
    else:
        subpops[pop].append(node)
numSubpops = len(subpops.keys())

popsPairs = [(x, y) for x in range(numPops) for y in range(numPops) if x < y]
subpopsPairs = [(x, y) for x in range(numSubpops) for y in range(numSubpops) if x < y]

############################################################
############################################################
# Fst
fstPops = ts.Fst([pops[Pop] for Pop in pops.keys()],
                          indexes=popsPairs)
fstPopsDF = pd.DataFrame({"Fst": fstPops})
fstPopsDF['Pop1'] = [list(pops.keys())[x] for x,y in popsPairs]
fstPopsDF['Pop2'] = [list(pops.keys())[y] for x,y in popsPairs]
fstPopsDF.to_csv(outFstPop, index = False)


fstSubpop = ts.Fst([subpops[subpop] for subpop in subpops.keys()],
                            indexes=subpopsPairs)
fstSubpopDF = pd.DataFrame({"Fst": fstSubpop})
fstSubpopDF['Subpop1'] = [list(subpops.keys())[x] for x,y in subpopsPairs]
fstSubpopDF['Subpop2'] = [list(subpops.keys())[y] for x,y in subpopsPairs]
fstSubpopDF.to_csv(outFstSubpop, index = False)

#TajimasD
tajimaPop = ts.Tajimas_D(list(pops.values()))
tajimaPopDF = pd.DataFrame({"TajimaD": tajimaPop})
tajimaPopDF['Pop'] = pops.keys()
tajimaPopDF.to_csv(outTajimaPop, index = False)

tajimaSubpop = ts.Tajimas_D(list(subpops.values()))
tajimaSubpopDF = pd.DataFrame({"TajimaD": tajimaSubpop})
tajimaSubpopDF['Subpop'] = subpops.keys()
tajimaSubpopDF.to_csv(outTajimaSubpop, index = False)

#Diversity
diversityPop = ts.diversity(list(pops.values()))
diversityPopDF = pd.DataFrame({"Diversity": diversityPop})
diversityPopDF['Pop'] = pops.keys()
diversityPopDF.to_csv(outDiversityPop, index = False)

diversitySubop = ts.diversity(list(subpops.values()))
diversitySubpopDF = pd.DataFrame({"Diversity": diversitySubop})
diversitySubpopDF['Subpop'] = subpops.keys()
diversitySubpopDF.to_csv(outDiversitySubpop, index = False)

#GNN
gnn = ts.genealogical_nearest_neighbours(
    ts.samples(), samples_listed_by_all
)

cols = {ts.node(u).individual: gnn[:, u] for u in ts.samples()}
cols["pop"] = [json.loads(ts.population(ts.node(u).population).metadata)["pop"] for u in ts.samples()]
cols["subpop"] = [json.loads(ts.population(ts.node(u).population).metadata)["subpop"] for u in ts.samples()]
cols["individual"] = [ts.node(u).individual for u in ts.samples()]
GnnDF = pd.DataFrame(cols)
GnnDF.to_csv(outGnn, index = False)
