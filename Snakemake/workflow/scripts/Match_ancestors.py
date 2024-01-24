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
ancestorFile = args[2]
outputAncestorsTree = args[3]

#######################################################################
# Do the inference and write the outputs
#######################################################################

sampleFile = tsinfer.load(sampleFile)
print("Samples: " + str(len(list(sampleFile.samples()))))

ancestors = tsinfer.load(ancestorsFile)

ancestors_ts = tsinfer.match_ancestors(
    sampleFile,
    ancestors,
    num_threads=threads,
    progress_monitor=True
)
print("Done matching ancestors")
ancestors_ts.dump(outputAncestorsTree)

