#!/usr/bin/env python
# coding: utf-8
import sys
print(sys.executable)
import cyvcf2
import tsinfer
import pandas as pd
import json
import numpy as np
import sys
import os
from tsparam import *
# sampleFile = snakemake.input[0]
# outputFile = snakemake.output[0]

args = sys.argv
sampleFile = args[1]
outputAncestors = args[2]

#######################################################################
# Do the inference and write the outputs
#######################################################################

print(sampleFile)
print(outputAncestors)
print(outputTree)
# Do the inference on the 10 SNPs
sampleFile = tsinfer.load(sampleFile)
print("Samples: " + str(len(list(sampleFile.samples()))))

ancestors = tsinfer.generate_ancestors(
    sampleFile,
    num_threads=threads,
    progress_monitor=True,
#    path = "Chr.ancestors",
).truncate_ancestors(
    lower_time_bound=lwertime,
    upper_time_bound=uprtime
)
print("Done generating ancestors")


# # Check the metadata
# for sample_node_id in ts.samples():
#     individual_id = ts.node(sample_node_id).individual
#     population_id = ts.node(sample_node_id).population
#     print(
#         "Node",
#         sample_node_id,
#         "labels genome sampled from",
#         json.loads(ts.individual(individual_id).metadata),
#         "in",
#         json.loads(ts.population(population_id).metadata)["subpop"],
#     )

