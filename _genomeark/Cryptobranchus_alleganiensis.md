---
assembly_status: <em style="color:maroon">No assembly</em>
common_name: ''
data_arima-3_bases: 6602.53 Gbp
data_arima-3_bytes: 3.1 TiB
data_arima-3_coverage: N/A
data_arima-3_links: s3://genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/genomic_data/arima/<br>
data_arima-3_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/genomic_data/arima/
data_arima-3_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Cryptobranchus_alleganiensis/aCryAll3/genomic_data/arima/
data_arima-3_scale: 1.9499
data_arima_bases: 6602.53 Gbp
data_arima_bytes: 3.1 TiB
data_arima_coverage: N/A
data_pacbiohifi_bam-3_bases: 3158.29 Gbp
data_pacbiohifi_bam-3_bytes: 4.0 TiB
data_pacbiohifi_bam-3_coverage: N/A
data_pacbiohifi_bam-3_links: s3://genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/genomic_data/pacbio_hifi/<br>
data_pacbiohifi_bam-3_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/genomic_data/pacbio_hifi/
data_pacbiohifi_bam-3_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Cryptobranchus_alleganiensis/aCryAll3/genomic_data/pacbio_hifi/
data_pacbiohifi_bam-3_scale: 0.7270
data_pacbiohifi_bam_bases: 3158.29 Gbp
data_pacbiohifi_bam_bytes: 4.0 TiB
data_pacbiohifi_bam_coverage: N/A
data_pacbiohifi_fqgz-3_bases: 878.36 Gbp
data_pacbiohifi_fqgz-3_bytes: 560.8 GiB
data_pacbiohifi_fqgz-3_coverage: N/A
data_pacbiohifi_fqgz-3_links: s3://genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/genomic_data/pacbio_hifi/<br>
data_pacbiohifi_fqgz-3_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/genomic_data/pacbio_hifi/
data_pacbiohifi_fqgz-3_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Cryptobranchus_alleganiensis/aCryAll3/genomic_data/pacbio_hifi/
data_pacbiohifi_fqgz-3_scale: 1.4588
data_pacbiohifi_fqgz_bases: 878.36 Gbp
data_pacbiohifi_fqgz_bytes: 560.8 GiB
data_pacbiohifi_fqgz_coverage: N/A
data_status: '<em style="color:forestgreen">PacBio HiFi</em> ::: <em style="color:forestgreen">Arima</em>'
data_use_source: from-default
data_use_text: Samples and data come from a variety of sources. To support fair and
  productive use of this data, please abide by the <a href="https://genome10k.soe.ucsc.edu/data-use-policies/">Data
  Use Policy</a> and contact Erich D. Jarvis, ejarvis@rockefeller.edu, with any questions.
genome_size: 0
genome_size_display: ''
genome_size_method: ''
last_raw_data: 1762205013
last_updated: 1776783951
mds:
- data: species:&nbsp;Cryptobranchus&nbsp;alleganiensis<br>specimem:&nbsp;aCryAll3<br>projects:<br>&nbsp;&nbsp;-&nbsp;vgp<br>assembled_by_group:&nbsp;Rockefeller<br>data_location:&nbsp;S3<br>release_to:&nbsp;S3<br>combine_for_curation:&nbsp;true<br>hap1:&nbsp;s3://genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/assembly_rockefeller/aCryAll3.standard.hap1.20260420.fasta.gz<br>hap2:&nbsp;s3://genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/assembly_rockefeller/aCryAll3.standard.hap2.20260420.fasta.gz<br>pretext_hap1:&nbsp;s3://genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/assembly_rockefeller/evaluation/hap1/pretext/s2/aCryAll3_hap1_s2_heatmap.pretext<br>pretext_hap2:&nbsp;s3://genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/assembly_rockefeller/evaluation/hap2/pretext/s2/aCryAll3_hap2_s2_heatmap.pretext<br>kmer_spectra_img:&nbsp;s3://genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/assembly_rockefeller/evaluation/merqury/aCryAll3_png/<br>pacbio_read_dir:&nbsp;s3://genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/genomic_data/pacbio_hifi/<br>pacbio_read_type:&nbsp;hifi<br>hic_read_dir:&nbsp;s3://genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/genomic_data/arima/<br>pipeline:<br>&nbsp;&nbsp;-&nbsp;hifiasm&nbsp;(0.25.0-r726)&nbsp;`hifiasm&nbsp;-o&nbsp;hellbender_HiFi.asm&nbsp;-t&nbsp;64&nbsp;$DIR/genomic_data/pacbio_hifi/*.fastq.gz`<br>&nbsp;&nbsp;-&nbsp;yahs&nbsp;(1.2.2)&nbsp;`yahs&nbsp;$HAP1&nbsp;$DIR/hap1_merged_markdup_q10.bam&nbsp;-o&nbsp;hap1_yahs&nbsp;-e&nbsp;'GATC,GANTC,CTNAG,TTAA'&nbsp;--no-contig-ec`&nbsp;`yahs&nbsp;$HAP2&nbsp;$DIR/hap2_merged_markdup_q10.bam&nbsp;-o&nbsp;hap2_yahs&nbsp;-e&nbsp;'GATC,GANTC,CTNAG,TTAA'&nbsp;--no-contig-ec`<br>&nbsp;&nbsp;-&nbsp;gfastats&nbsp;(1.3.12)<br>&nbsp;&nbsp;-&nbsp;bwa&nbsp;(0.7.19-r1273)<br>&nbsp;&nbsp;-&nbsp;samtools&nbsp;(1.22)<br>&nbsp;&nbsp;-&nbsp;bandage&nbsp;(0.9.0)<br>&nbsp;&nbsp;-&nbsp;genomescope&nbsp;(2.1.0+galaxy0)<br>&nbsp;&nbsp;-&nbsp;meryl&nbsp;(1.4.1)<br>&nbsp;&nbsp;-&nbsp;merqury&nbsp;(1.3)<br>&nbsp;&nbsp;-&nbsp;compleasm&nbsp;(0.2.6)<br>&nbsp;&nbsp;-&nbsp;PretextMap&nbsp;(0.2.4)<br>&nbsp;&nbsp;-&nbsp;PretextSnapshot&nbsp;(0.0.5)<br>&nbsp;&nbsp;-&nbsp;teloscope&nbsp;(0.1.4)<br>&nbsp;&nbsp;-&nbsp;minimap2&nbsp;(2.30-r1287)<br>&nbsp;&nbsp;-&nbsp;bamcoverage&nbsp;(3.5.6)<br>&nbsp;&nbsp;-&nbsp;VGP0&nbsp;mitoHiFi&nbsp;workflow&nbsp;(v0.2.1)<br>notes:&nbsp;This&nbsp;was&nbsp;a&nbsp;Hifiasm&nbsp;(HiFi&nbsp;only)&nbsp;assembly&nbsp;of&nbsp;aCryAll3&nbsp;resulting&nbsp;in&nbsp;two&nbsp;haplotype&nbsp;assemblies.&nbsp;HiC&nbsp;data&nbsp;were&nbsp;generated&nbsp;using&nbsp;the&nbsp;Arima&nbsp;library&nbsp;prep&nbsp;kit,&nbsp;and&nbsp;require&nbsp;trimming&nbsp;the&nbsp;first&nbsp;5&nbsp;bp&nbsp;off&nbsp;from&nbsp;the&nbsp;5'&nbsp;end&nbsp;of&nbsp;both&nbsp;read&nbsp;files.&nbsp;The&nbsp;restriction&nbsp;enzymes&nbsp;used&nbsp;were&nbsp;the&nbsp;Arima&nbsp;v2&nbsp;kit,&nbsp;so&nbsp;the&nbsp;cutting&nbsp;sites&nbsp;are&nbsp;GATC,&nbsp;GANTC,&nbsp;CTNAG,&nbsp;TTAA.&nbsp;<br>
  ident: md4
  title: assembly_rockefeller/aCryAll3.yml
mito3date: 2025-08-04
mito3filesize: 5.2 KiB
mito3length: '16319'
mito3n50ctg: 16319
mito3n50scf: 16319
mito3seq: https://s3.amazonaws.com/genomeark/species/Cryptobranchus_alleganiensis/aCryAll3/assembly_MT_rockefeller/aCryAll3.MT.20250804.fasta.gz
mito3sizes: |
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
  <tr><td> 10 </td><td> 1 </td><td> 16.32 Kbp </td><td> 1 </td><td> 16.32 Kbp </td></tr><tr><td> 20 </td><td> 1 </td><td> 16.32 Kbp </td><td> 1 </td><td> 16.32 Kbp </td></tr><tr><td> 30 </td><td> 1 </td><td> 16.32 Kbp </td><td> 1 </td><td> 16.32 Kbp </td></tr><tr><td> 40 </td><td> 1 </td><td> 16.32 Kbp </td><td> 1 </td><td> 16.32 Kbp </td></tr><tr style="background-color:#cccccc;"><td> 50 </td><td> 1 </td><td style="background-color:#ff8888;"> 16.32 Kbp </td><td> 1 </td><td style="background-color:#ff8888;"> 16.32 Kbp </td></tr><tr><td> 60 </td><td> 1 </td><td> 16.32 Kbp </td><td> 1 </td><td> 16.32 Kbp </td></tr><tr><td> 70 </td><td> 1 </td><td> 16.32 Kbp </td><td> 1 </td><td> 16.32 Kbp </td></tr><tr><td> 80 </td><td> 1 </td><td> 16.32 Kbp </td><td> 1 </td><td> 16.32 Kbp </td></tr><tr><td> 90 </td><td> 1 </td><td> 16.32 Kbp </td><td> 1 </td><td> 16.32 Kbp </td></tr><tr><td> 100 </td><td> 1 </td><td> 16.32 Kbp </td><td> 1 </td><td> 16.32 Kbp </td></tr></tbody>
  <tfoot>
  <tr><th> 1.000x </th><th> 1 </th><th> 16.32 Kbp </th><th> 1 </th><th> 16.32 Kbp </th></tr>
  </tfoot>
  </table>
mito3version: assembly_MT_rockefeller
name: Cryptobranchus alleganiensis
name_: Cryptobranchus_alleganiensis
project: ~
short_name: aCryAll
taxon_id: ''
---
