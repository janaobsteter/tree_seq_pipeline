rule compute_chromosome_stats:
    input: rules.match_samples.output
    conda: "HLab_tsinfer"
    threads: 1
    resources: cpus=8, mem_mb=64000, time_min=20000
    log: 'logs/Statistics_{chromosome}.log'
    benchmark: 'benchmark/Statistics_{chromosome}.log'
    output:
        f"../{Project}/Tsinfer/statistics/{{chromosome}}_FstPop.csv",
        f"../{Project}/Tsinfer/statistics/{{chromosome}}_FstSubpop.csv",
        f"../{Project}/Tsinfer/statistics/{{chromosome}}_TajimaDPop.csv",
        f"../{Project}/Tsinfer/statistics/{{chromosome}}_TajimaDSubpop.csv",
        f"../{Project}/Tsinfer/statistics/{{chromosome}}_DiversityPop.csv",
        f"../{Project}/Tsinfer/statistics/{{chromosome}}_DiversitySubpop.csv",
        f"../{Project}/Tsinfer/statistics/{{chromosome}}_Gnn.csv"
    shell:
        """
        python scripts/ComputeStatistics.py {input.samples} {input.tree} {input.meta} {output}
        """

rule combine_chromosome_stats:
    input:
        expand(f"../{Project}/Tsinfer/statistics/{{chromosome}}_FstPop.csv", chromosome=chromosomes)
        # expand(f"../{Project}/Tsinfer/statistics/{{chromosome}}_FstSubpop.csv", chromosome=chromosomes),
        # expand(f"../{Project}/Tsinfer/statistics/{{chromosome}}_TajimaDPop.csv", chromosome=chromosomes),
        # expand(f"../{Project}/Tsinfer/statistics/{{chromosome}}_TajimaDSubpop.csv", chromosome=chromosomes),
        # expand(f"../{Project}/Tsinfer/statistics/{{chromosome}}_DiversityPop.csv", chromosome=chromosomes),
        # expand(f"../{Project}/Tsinfer/statistics/{{chromosome}}_DiversitySubpop.csv", chromosome=chromosomes),
        # expand(f"../{Project}/Tsinfer/statistics/{{chromosome}}_Gnn.csv", chromosome=chromosomes)
    conda: "HLab_tsinfer"
    threads: 1
    resources: cpus=8, mem_mb=64000, time_min=20000
    log: 'logs/Combine_statistics.log'
    benchmark: 'benchmark/Combine_statistics.log'
    params:
        noChromosomes = config['noChromosomes'],
        filePath = "f../{Project}/Tsinfer/statistics"
    output:
        f"../{Project}/Tsinfer/statistics/FstPop.csv",
        f"../{Project}/Tsinfer/statistics/FstSubpop.csv",
        f"../{Project}/Tsinfer/statistics/TajimaDPop.csv",
        f"../{Project}/Tsinfer/statistics/TajimaDSubpop.csv",
        f"../{Project}/Tsinfer/statistics/DiversityPop.csv",
        f"../{Project}/Tsinfer/statistics/DiversitySubpop.csv",
        f"../{Project}/Tsinfer/statistics/Gnn.csv"
    shell:
        """
        python scripts/Combine_chromosome_stats.py {params.noChromosomes} {params.filePath}
        """
