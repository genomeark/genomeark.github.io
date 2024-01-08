---
assembly_status: <em style="color:maroon">No assembly</em>
common_name: ''
data_arima-1_bases: 86.16 Gbp
data_arima-1_bytes: 42.6 GiB
data_arima-1_coverage: N/A
data_arima-1_links: s3://genomeark/species/Anolis_sagrei/rAnoSag1/genomic_data/arima/<br>
data_arima-1_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Anolis_sagrei/rAnoSag1/genomic_data/arima/
data_arima-1_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Anolis_sagrei/rAnoSag1/genomic_data/arima/
data_arima-1_scale: 1.8849
data_arima_bases: 86.16 Gbp
data_arima_bytes: 42.6 GiB
data_arima_coverage: N/A
data_illumina-2_bases: 117.81 Gbp
data_illumina-2_bytes: 54.8 GiB
data_illumina-2_coverage: N/A
data_illumina-2_links: s3://genomeark/species/Anolis_sagrei/rAnoSag2/genomic_data/illumina/<br>
data_illumina-2_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Anolis_sagrei/rAnoSag2/genomic_data/illumina/
data_illumina-2_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Anolis_sagrei/rAnoSag2/genomic_data/illumina/
data_illumina-2_scale: 2.0010
data_illumina-3_bases: 123.45 Gbp
data_illumina-3_bytes: 57.5 GiB
data_illumina-3_coverage: N/A
data_illumina-3_links: s3://genomeark/species/Anolis_sagrei/rAnoSag3/genomic_data/illumina/<br>
data_illumina-3_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Anolis_sagrei/rAnoSag3/genomic_data/illumina/
data_illumina-3_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Anolis_sagrei/rAnoSag3/genomic_data/illumina/
data_illumina-3_scale: 1.9986
data_illumina_bases: 241.26 Gbp
data_illumina_bytes: 112.4 GiB
data_illumina_coverage: N/A
data_pacbiohifi_fqgz-1_bases: 68.08 Gbp
data_pacbiohifi_fqgz-1_bytes: 53.2 GiB
data_pacbiohifi_fqgz-1_coverage: N/A
data_pacbiohifi_fqgz-1_links: s3://genomeark/species/Anolis_sagrei/rAnoSag1/genomic_data/pacbio_hifi/<br>
data_pacbiohifi_fqgz-1_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Anolis_sagrei/rAnoSag1/genomic_data/pacbio_hifi/
data_pacbiohifi_fqgz-1_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Anolis_sagrei/rAnoSag1/genomic_data/pacbio_hifi/
data_pacbiohifi_fqgz-1_scale: 1.1921
data_pacbiohifi_fqgz_bases: 68.08 Gbp
data_pacbiohifi_fqgz_bytes: 53.2 GiB
data_pacbiohifi_fqgz_coverage: N/A
data_status: '<em style="color:forestgreen">PacBio HiFi</em> ::: <em style="color:forestgreen">Arima</em>
  ::: <em style="color:forestgreen">Illumina</em>'
data_use_source: from-default
data_use_text: Samples and data come from a variety of sources. To support fair and
  productive use of this data, please abide by the <a href="https://genome10k.soe.ucsc.edu/data-use-policies/">Data
  Use Policy</a> and contact Erich D. Jarvis, ejarvis@rockefeller.edu, with any questions.
genome_size: 0
genome_size_display: ''
genome_size_method: ''
last_raw_data: 1689690031
last_updated: 1703274659
mds:
- data: "species: Anolis sagrei\nspecimen: rAnoSag1\nprojects: \n  - vgp\ndata_location:
    S3\nrelease_to: S3\nmaternal: s3://genomeark/species/Anolis_sagrei/rAnoSag1/assembly_vgp_trio_2.0/rAnoSag1.trio.mat.20231222.fasta.gz\npretext:
    s3://genomeark/species/Anolis_sagrei/rAnoSag1/assembly_vgp_trio_2.0/evaluation/hap2/pretext/rAnoSag1_hap2__s2_heatmap.pretext\nkmer_spectra_img:
    s3://genomeark/species/Anolis_sagrei/rAnoSag1/assembly_vgp_trio_2.0/evaluation/merqury/rAnoSag1_png/\npacbio_read_dir:
    s3://genomeark/species/Anolis_sagrei/rAnoSag1/genomic_data/pacbio_hifi/\npacbio_read_type:
    hifi\nhic_read_dir: s3://genomeark/species/Anolis_sagrei/rAnoSag1/genomic_data/arima/\npipeline:\n
    \ - hifiasm (0.19.7+galaxy1), with trio-dual parameter on\n  - purge_dups (2.2)\n
    \ - yahs (1.2a.2+galaxy1)\nassembled_by_group: Rockefeller\nnotes: This was a
    trio assembly of rAnoSag1 (internal ID: VGL-rAnoSag4) using parental illumina
    data and hifiasm in trio mode with the \"trio-dual\" parameter on. Sample metadata
    says a female specimen. This individual did not have bionano data. HiC scaffolding
    was performed with yahs. The HiC prep was Arima kit 2. In the intermediate files,
    hap1 is the paternal haplotype and hap2 is the maternal haplotype. Both haplotypes
    individually went through a round of purge_dups. We are submitting both haplotypes
    for trio curation, and this is the ticket for the maternal haplotype (hap2)."
  ident: md2
  title: assembly_vgp_trio_2.0/rAnoSag1_mat.yml
- data: "species: Anolis sagrei\nspecimen: rAnoSag1\nprojects: \n  - vgp\ndata_location:
    S3\nrelease_to: S3\npaternal: s3://genomeark/species/Anolis_sagrei/rAnoSag1/assembly_vgp_trio_2.0/rAnoSag1.trio.pat.20231222.fasta.gz\npretext:
    s3://genomeark/species/Anolis_sagrei/rAnoSag1/assembly_vgp_trio_2.0/evaluation/hap2/pretext/rAnoSag1_hap1__s2_heatmap.pretext\nkmer_spectra_img:
    s3://genomeark/species/Anolis_sagrei/rAnoSag1/assembly_vgp_trio_2.0/evaluation/merqury/rAnoSag1_png/\npacbio_read_dir:
    s3://genomeark/species/Anolis_sagrei/rAnoSag1/genomic_data/pacbio_hifi/\npacbio_read_type:
    hifi\nhic_read_dir: s3://genomeark/species/Anolis_sagrei/rAnoSag1/genomic_data/arima/\npipeline:\n
    \ - hifiasm (0.19.7+galaxy1), with trio-dual parameter on\n  - purge_dups (2.2)\n
    \ - yahs (1.2a.2+galaxy1)\nassembled_by_group: Rockefeller\nnotes: This was a
    trio assembly of rAnoSag1 (internal ID: VGL-rAnoSag4) using parental illumina
    data and hifiasm in trio mode with the \"trio-dual\" parameter on. Sample metadata
    says a female specimen. This individual did not have bionano data. HiC scaffolding
    was performed with yahs. The HiC prep was Arima kit 2. In the intermediate files,
    hap1 is the paternal haplotype and hap2 is the maternal haplotype. Both haplotypes
    individually went through a round of purge_dups. We are submitting both haplotypes
    for trio curation, and this is the ticket for the paternal haplotype (hap1)."
  ident: md3
  title: assembly_vgp_trio_2.0/rAnoSag1_pat.yml
name: Anolis sagrei
name_: Anolis_sagrei
project: ~
short_name: rAnoSag
taxon_id: ''
---
