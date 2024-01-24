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
ancestorsTree = args[2]
outputTree = args[3]

#######################################################################
# Do the inference and write the outputs
#######################################################################

sampleFile = tsinfer.load(sampleFile)
print("Samples: " + str(len(list(sampleFile.samples()))))

ancestors_ts = tskit.load(ancestorsTree)

ts = tsinfer.match_samples(
    sampleFile,
    ancestors_ts,
    num_threads=threads,
    progress_monitor=True,
).simplify(keep_unary=False)
print("Done matching samples")
ts.dump(outputTree)

