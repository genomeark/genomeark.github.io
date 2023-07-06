---
assembly_status: <em style="color:maroon">No assembly</em>
common_name: seaside sparrow
data_arima-1_bases: 141.58 Gbp
data_arima-1_bytes: 71.1 GiB
data_arima-1_coverage: 108.40x
data_arima-1_links: s3://genomeark/species/Ammodramus_maritimus/bAmmMai1/genomic_data/arima/<br>
data_arima-1_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Ammodramus_maritimus/bAmmMai1/genomic_data/arima/
data_arima-1_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Ammodramus_maritimus/bAmmMai1/genomic_data/arima/
data_arima-1_scale: 1.8545
data_arima_bases: 141.58 Gbp
data_arima_bytes: 71.1 GiB
data_arima_coverage: 108.40x
data_bionano-1_bases: N/A
data_bionano-1_bytes: 802.2 MiB
data_bionano-1_coverage: 395.89x
data_bionano-1_links: s3://genomeark/species/Ammodramus_maritimus/bAmmMai1/genomic_data/bionano/<br>
data_bionano-1_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Ammodramus_maritimus/bAmmMai1/genomic_data/bionano/
data_bionano-1_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Ammodramus_maritimus/bAmmMai1/genomic_data/bionano/
data_bionano-1_scale: 614.6642
data_bionano_bases: N/A
data_bionano_bytes: 802.2 MiB
data_bionano_coverage: 395.89x
data_pacbiohifi_fqgz-1_bases: 39.45 Gbp
data_pacbiohifi_fqgz-1_bytes: 31.0 GiB
data_pacbiohifi_fqgz-1_coverage: 30.20x
data_pacbiohifi_fqgz-1_links: s3://genomeark/species/Ammodramus_maritimus/bAmmMai1/genomic_data/pacbio_hifi/<br>
data_pacbiohifi_fqgz-1_s3gui: https://42basepairs.com/browse/s3/genomeark/species/Ammodramus_maritimus/bAmmMai1/genomic_data/pacbio_hifi/
data_pacbiohifi_fqgz-1_s3url: https://genomeark.s3.amazonaws.com/index.html?prefix=species/Ammodramus_maritimus/bAmmMai1/genomic_data/pacbio_hifi/
data_pacbiohifi_fqgz-1_scale: 1.1850
data_pacbiohifi_fqgz_bases: 39.45 Gbp
data_pacbiohifi_fqgz_bytes: 31.0 GiB
data_pacbiohifi_fqgz_coverage: 30.20x
data_status: '<em style="color:forestgreen">PacBio HiFi</em> ::: <em style="color:forestgreen">Arima</em>'
data_use_source: from-default
data_use_text: Samples and data come from a variety of sources. To support fair and
  productive use of this data, please abide by the <a href="https://genome10k.soe.ucsc.edu/data-use-policies/">Data
  Use Policy</a> and contact Erich D. Jarvis, ejarvis@rockefeller.edu, with any questions.
genome_size: 1306000000
genome_size_display: 1.31 Gbp
genome_size_method: GoAT
last_raw_data: 1683389171
last_updated: 1683913467
mds:
- data: "species: Ammodramus maritimus\nspecimen: bAmmMai1\nprojects: \n  - vgp\ndata_location:
    S3\nrelease_to: S3\nprimary: s3://genomeark/species/Ammodramus_maritimus/bAmmMai1/assembly_vgp_standard_2.0/bAmmMai1.standard.pri.20230512.fasta.gz\nhaplotigs:
    s3://genomeark/species/Ammodramus_maritimus/bAmmMai1/assembly_vgp_standard_2.0/bAmmMai1.standard.alt.20230512.fasta.gz\npretext:
    s3://genomeark/species/Ammodramus_maritimus/bAmmMai1/assembly_vgp_standard_2.0/evaluation/pri/pretext/bAmmMai1_pri__s2.heatmap.pretext\nkmer_spectra_img:
    s3://genomeark/species/Ammodramus_maritimus/bAmmMai1/assembly_vgp_standard_2.0/evaluation/merqury/bAmmMai1_png/\nmito:
    s3://genomeark/species/Ammodramus_maritimus/bAmmMai1/assembly_MT_rockefeller/bAmmMai1.MT.20230509.fasta.gz\npacbio_read_dir:
    s3://genomeark/species/Ammodramus_maritimus/bAmmMai1/genomic_data/pacbio_hifi/\npacbio_read_type:
    hifi\nhic_read_dir: s3://genomeark/species/Ammodramus_maritimus/bAmmMai1/genomic_data/arima/\nbionano_cmap_dir:
    s3://genomeark/species/Ammodramus_maritimus/bAmmMai1/genomic_data/bionano/\npipeline:\n
    \ - hifiasm (0.18.8+galaxy1)\n  - solve (3.7)\n  - yahs (1.2a.2+galaxy1)\nassembled_by_group:
    Rockefeller\nnotes: This was a primary/alternate assembly of bAmmMai1 (VGL ID
    is bAmmMar1). This individual had bionano data. HiC scaffolding was performed
    with yahs. The HiC prep was Arima kit 2. This sample arrived with metadata indicating
    it is a female. "
  ident: md4
  title: assembly_vgp_standard_2.0/bAmmMai1.yml
metadata: |
  species:
    name: Ammodramus maritimus
    individuals:
    - short_name: bAmmMai1
    short_name: bAmmMai
    taxon_id: 371905
    common_name: seaside sparrow
    genome_size: 1306000000
    genome_size_method: GoAT
    order:
      name: Passeriformes
    family:
      name: Passerellidae
    project: [ vgp ]
mito1date: 2023-05-09
mito1filesize: 5.4 KiB
mito1length: '16789'
mito1n50ctg: 0
mito1n50scf: 0
mito1seq: https://s3.amazonaws.com/genomeark/species/Ammodramus_maritimus/bAmmMai1/assembly_MT_rockefeller/bAmmMai1.MT.20230509.fasta.gz
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
  <tr><td> 10 </td><td> 0 </td><td>  </td><td> 0 </td><td>  </td></tr><tr><td> 20 </td><td> 0 </td><td>  </td><td> 0 </td><td>  </td></tr><tr><td> 30 </td><td> 0 </td><td>  </td><td> 0 </td><td>  </td></tr><tr><td> 40 </td><td> 0 </td><td>  </td><td> 0 </td><td>  </td></tr><tr style="background-color:#cccccc;"><td> 50 </td><td> 0 </td><td style="background-color:#ff8888;">  </td><td> 0 </td><td style="background-color:#ff8888;">  </td></tr><tr><td> 60 </td><td> 0 </td><td>  </td><td> 0 </td><td>  </td></tr><tr><td> 70 </td><td> 0 </td><td>  </td><td> 0 </td><td>  </td></tr><tr><td> 80 </td><td> 0 </td><td>  </td><td> 0 </td><td>  </td></tr><tr><td> 90 </td><td> 0 </td><td>  </td><td> 0 </td><td>  </td></tr><tr><td> 100 </td><td> 0 </td><td>  </td><td> 0 </td><td>  </td></tr></tbody>
  <tfoot>
  <tr><th> 0.000x </th><th> 1 </th><th> 16.79 Kbp </th><th> 1 </th><th> 16.79 Kbp </th></tr>
  </tfoot>
  </table>
mito1version: assembly_MT_rockefeller
name: Ammodramus maritimus
name_: Ammodramus_maritimus
project:
- vgp
short_name: bAmmMai
taxon_id: 371905
---
