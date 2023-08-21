---
assembly_status: <em style="color:maroon">No assembly</em>
common_name: ''
data_arima-1_bases: 210.05 Gbp
data_arima-1_bytes: 113.3 GiB
data_arima-1_coverage: N/A
data_arima-1_links: s3://genomeark/species/Xenopus_petersii/aXenPet1/genomic_data/arima/<br>
data_arima-1_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Xenopus_petersii/aXenPet1/genomic_data/arima/
data_arima-1_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Xenopus_petersii/aXenPet1/genomic_data/arima/
data_arima-1_scale: 1.7270
data_arima_bases: 210.05 Gbp
data_arima_bytes: 113.3 GiB
data_arima_coverage: N/A
data_illumina-2_bases: 141.64 Gbp
data_illumina-2_bytes: 66.1 GiB
data_illumina-2_coverage: N/A
data_illumina-2_links: s3://genomeark/species/Xenopus_petersii/aXenPet2/genomic_data/illumina/<br>
data_illumina-2_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Xenopus_petersii/aXenPet2/genomic_data/illumina/
data_illumina-2_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Xenopus_petersii/aXenPet2/genomic_data/illumina/
data_illumina-2_scale: 1.9963
data_illumina-3_bases: 201.98 Gbp
data_illumina-3_bytes: 93.2 GiB
data_illumina-3_coverage: N/A
data_illumina-3_links: s3://genomeark/species/Xenopus_petersii/aXenPet3/genomic_data/illumina/<br>
data_illumina-3_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Xenopus_petersii/aXenPet3/genomic_data/illumina/
data_illumina-3_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Xenopus_petersii/aXenPet3/genomic_data/illumina/
data_illumina-3_scale: 2.0193
data_illumina_bases: 343.63 Gbp
data_illumina_bytes: 159.2 GiB
data_illumina_coverage: N/A
data_pacbiohifi_fqgz-1_bases: 104.71 Gbp
data_pacbiohifi_fqgz-1_bytes: 79.3 GiB
data_pacbiohifi_fqgz-1_coverage: N/A
data_pacbiohifi_fqgz-1_links: s3://genomeark/species/Xenopus_petersii/aXenPet1/genomic_data/pacbio_hifi/<br>
data_pacbiohifi_fqgz-1_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Xenopus_petersii/aXenPet1/genomic_data/pacbio_hifi/
data_pacbiohifi_fqgz-1_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Xenopus_petersii/aXenPet1/genomic_data/pacbio_hifi/
data_pacbiohifi_fqgz-1_scale: 1.2303
data_pacbiohifi_fqgz_bases: 104.71 Gbp
data_pacbiohifi_fqgz_bytes: 79.3 GiB
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
last_raw_data: 1682106454
last_updated: 1692382702
mds:
- data: "species: Xenopus petersii\nspecimen: aXenPet1\nprojects: \n  - vgp\ndata_location:
    S3\nrelease_to: S3\nmaternal: s3://genomeark/species/Xenopus_petersii/aXenPet1/assembly_vgp_HiC_2.0/aXenPet1.trio.mat.20230815.fasta.gz\npretext:
    s3://genomeark/species/Xenopus_petersii/aXenPet1/assembly_vgp_HiC_2.0/evaluation/hap2/pretext/aXenPet1_hap2__s2_heatmap.pretext\nkmer_spectra_img:
    s3://genomeark/species/Xenopus_petersii/aXenPet1/assembly_vgp_HiC_2.0/evaluation/merqury/aXenPet1_png/\nmito:
    s3://genomeark/species/Xenopus_petersii/aXenPet1/assembly_MT_rockefeller/aXenPet1.MT.20230815.fasta.gz\npacbio_read_dir:
    s3://genomeark/species/Xenopus_petersii/aXenPet1/genomic_data/pacbio_hifi/\npacbio_read_type:
    hifi\nhic_read_dir: s3://genomeark/species/Xenopus_petersii/aXenPet1/genomic_data/arima/\npipeline:\n
    \ - hifiasm (0.19.3+galaxy0)\n  - purge_dups (2.2) for paternal haplotype\n  -
    yahs (1.2a.2+galaxy1)\nassembled_by_group: Rockefeller\nnotes: This was a trio
    assembly of aXenPet1 using parental illumina data. Sample metadata says a female
    specimen. This individual did not have bionano data. HiC scaffolding was performed
    with yahs. The HiC prep was Arima kit 2. The HiC reads needed to have 5 bp trimmed
    from the 5' end due to adapter left over from the Arima library prep kit. In the
    intermediate files, hap1 is the paternal haplotype and hap2 is the maternal haplotype.
    The paternal haplotype went through purge_dups due to presence of 2-copy k-mers
    at diploid coverage in the merqury plots. The BUSCO values were troublesome, and
    likely indicate presence of many paralogs. We are submitting both haplotypes for
    trio curation, and this is the ticket for the maternal haplotype."
  ident: md4
  title: assembly_vgp_trio_2.0/aXenPet1_mat.yml
- data: "species: Xenopus petersii\nspecimen: aXenPet1\nprojects: \n  - vgp\ndata_location:
    S3\nrelease_to: S3\npaternal: s3://genomeark/species/Xenopus_petersii/aXenPet1/assembly_vgp_HiC_2.0/aXenPet1.trio.pat.20230815.fasta.gz\npretext:
    s3://genomeark/species/Xenopus_petersii/aXenPet1/assembly_vgp_HiC_2.0/evaluation/hap1/pretext/aXenPet1_hap1__s2_heatmap.pretext\nkmer_spectra_img:
    s3://genomeark/species/Xenopus_petersii/aXenPet1/assembly_vgp_HiC_2.0/evaluation/merqury/aXenPet1_png/\nmito:
    s3://genomeark/species/Xenopus_petersii/aXenPet1/assembly_MT_rockefeller/aXenPet1.MT.20230815.fasta.gz\npacbio_read_dir:
    s3://genomeark/species/Xenopus_petersii/aXenPet1/genomic_data/pacbio_hifi/\npacbio_read_type:
    hifi\nhic_read_dir: s3://genomeark/species/Xenopus_petersii/aXenPet1/genomic_data/arima/\npipeline:\n
    \ - hifiasm (0.19.3+galaxy0)\n  - purge_dups (2.2) for paternal haplotype\n  -
    yahs (1.2a.2+galaxy1)\nassembled_by_group: Rockefeller\nnotes: This was a trio
    assembly of aXenPet1 using parental illumina data. Sample metadata says a female
    specimen. This individual did not have bionano data. HiC scaffolding was performed
    with yahs. The HiC prep was Arima kit 2. The HiC reads needed to have 5 bp trimmed
    from the 5' end due to adapter left over from the Arima library prep kit. In the
    intermediate files, hap1 is the paternal haplotype and hap2 is the maternal haplotype.
    The paternal haplotype went through purge_dups due to presence of 2-copy k-mers
    at diploid coverage in the merqury plots. The BUSCO values were troublesome, and
    likely indicate presence of many paralogs. We are submitting both haplotypes for
    trio curation, and this is the ticket for the paternal haplotype."
  ident: md5
  title: assembly_vgp_trio_2.0/aXenPet1_pat.yml
mito1date: 2023-08-15
mito1filesize: 5.7 KiB
mito1length: '17717'
mito1n50ctg: 17717
mito1n50scf: 17717
mito1seq: https://s3.amazonaws.com/genomeark/species/Xenopus_petersii/aXenPet1/assembly_MT_rockefeller/aXenPet1.MT.20230815.fasta.gz
mito1sizes: |
  <table class="sequence-sizes-table">
  <thead>
  <tr>
  <th></th>
  <th colspan=2 align=center>Contigs</th>
  <th colspan=2 align=center>Scaffolds</th>
  </tr>
  <tr>
  <th>NG</th>
  <th>LG</th>
  <th>Len</th>
  <th>LG</th>
  <th>Len</th>
  </tr>
  </thead>
  <tbody>
  <tr><td> 10 </td><td> 1 </td><td> 17.72 Kbp </td><td> 1 </td><td> 17.72 Kbp </td></tr><tr><td> 20 </td><td> 1 </td><td> 17.72 Kbp </td><td> 1 </td><td> 17.72 Kbp </td></tr><tr><td> 30 </td><td> 1 </td><td> 17.72 Kbp </td><td> 1 </td><td> 17.72 Kbp </td></tr><tr><td> 40 </td><td> 1 </td><td> 17.72 Kbp </td><td> 1 </td><td> 17.72 Kbp </td></tr><tr style="background-color:#cccccc;"><td> 50 </td><td> 1 </td><td style="background-color:#ff8888;"> 17.72 Kbp </td><td> 1 </td><td style="background-color:#ff8888;"> 17.72 Kbp </td></tr><tr><td> 60 </td><td> 1 </td><td> 17.72 Kbp </td><td> 1 </td><td> 17.72 Kbp </td></tr><tr><td> 70 </td><td> 1 </td><td> 17.72 Kbp </td><td> 1 </td><td> 17.72 Kbp </td></tr><tr><td> 80 </td><td> 1 </td><td> 17.72 Kbp </td><td> 1 </td><td> 17.72 Kbp </td></tr><tr><td> 90 </td><td> 1 </td><td> 17.72 Kbp </td><td> 1 </td><td> 17.72 Kbp </td></tr><tr><td> 100 </td><td> 1 </td><td> 17.72 Kbp </td><td> 1 </td><td> 17.72 Kbp </td></tr></tbody>
  <tfoot>
  <tr><th> 1.000x </th><th> 1 </th><th> 17.72 Kbp </th><th> 1 </th><th> 17.72 Kbp </th></tr>
  </tfoot>
  </table>
mito1version: assembly_MT_rockefeller
name: Xenopus petersii
name_: Xenopus_petersii
project: ~
short_name: aXenPet
taxon_id: ''
---
