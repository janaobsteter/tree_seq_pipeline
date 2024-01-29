rule filter_snps:
    input:
        vcf=temp(f'{vcfdir}/{{chromosome}}_final.vcf.gz'),
        index=temp(f'{vcfdir}/{{chromosome}}_final.vcf.gz.csi'),
        fasta=config['ref_fasta']
    output:
        tmp(f'{vcfdir}/{{chromosome}}_final_snps.vcf.gz')
    conda: "gatk-env"
    shell:
        """
        gatk SelectVariants \
             -R {input.fasta} \
             -V {input.vcf} \
             --select-type-to-include SNP \
             -O {output}
        """

rule index_filtered_vcf:
    input:
        rules.filter_snps.output
    output:
        tmp(f'{vcfdir}/{{chromosome}}_final_snps.vcf.gz.csi')
    conda: "bcftools"
    shell:
        """
        bcftools index -f {input}
        """
