import re

# if multiallelic:
#     vcf_4_inference = f'{vcfdir}/{{chromosome}}_allbi.vcf.gz'
# else:
#     vcf_4_inference = f'{vcfdir}/{{chromosome}}_ancestral.vcf.gz'

rule prepare_sample_file:
    input:
        #vcf=vcf_4_inference,
        vcf = f'{vcfdir}/{{chromosome}}_ancestral.vcf.gz',
        meta = config['meta']
    output:
        f"../{Project}/Tsinfer/samples/{{chromosome}}.samples"
    params:
        chrLength= lambda wildcards:  config['chromosome_length'][int(re.findall(r'\d+', wildcards.chromosome)[0])],
        ploidy=config['ploidy']
    conda: "HLab_tsinfer"
    threads: 1
    resources: cpus=1, mem_mb=128000, time_min=200, job_name=lambda wildcards: f"Prepare_samples_Chr{wildcards.chromosome}"
    log: 'logs/Prepare_sample_file_{chromosome}.log'
    shell:
        "python scripts/Prepare_tsinfer_sample_file.py "
        "{input.vcf} {input.meta} {output} {params.ploidy} {params.chrLength}"

rule generate_ancestors:
    input:
        f"../{Project}/Tsinfer/samples/{{chromosome}}.samples"
    conda: "HLab_tsinfer"
    threads: 1
    resources: cpus=8, mem_mb=64000, time_min=20000
    log: 'logs/Infer_{chromosome}.log'
    benchmark: 'benchmark/Generate_ancestors_{chromosome}.log'
    output:
        f"../{Project}/Tsinfer/trees/{{chromosome}}.ancestors"
    shell:
        "python scripts/Generate_ancestors.py {input} {output}"


rule match_ancestors:
    input: 
	samples=f"../{Project}/Tsinfer/samples/{{chromosome}}.samples",
	ancestors=rules.generate_ancestors.output
    conda: "HLab_tsinfer"
    threads: 1
    resources: cpus=8, mem_mb=64000, time_min=20000
    log: 'logs/Infer_{chromosome}.log'
    benchmark: 'benchmark/Match_ancestors_{chromosome}.log'
    output:
	f"../{Project}/Tsinfer/trees/{{chromosome}}_ancestors.trees"
    shell:
	"python scripts/Match_ancestors.py {input.samples} {input.ancestors} {output}"



rule match_samples:
    input: 
         samples=f"../{Project}/Tsinfer/samples/{{chromosome}}.samples",
         ancestorTree=rules.infer_match_ancestors.output
    conda: "HLab_tsinfer"
    threads: 1
    resources: cpus=8, mem_mb=64000, time_min=20000
    log: 'logs/Infer_{chromosome}.log'
    benchmark: 'benchmark/Match_samples_{chromosome}.log'
    output:
        f"../{Project}/Tsinfer/trees/{{chromosome}}.trees"
    shell:
	"python scripts/Match_samples.py {input.samples} {input.ancestorTree} {output}"
