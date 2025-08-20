# CheckM provides a set of tools for assessing the quality of genomes recovered from isolates, single cells, or metagenomes.

    checkm lineage_wf -x fna Genomes_MAGs CheckMOut --tab_table -f MAGs_checkm.tab --reduced_tree -t 4






    checkm lineage_wf -x fna Data CheckMOut --tab_table -f MAGs_checkm_Metabat2.tab --reduced_tree -t 10 &&

checkm lineage_wf -x fa Metabat2.1 CheckMOut_Metabat2.1 --tab_table -f MAGs_checkm_Metabat2.1.tab --reduced_tree -t 5

checkm lineage_wf -x fa DASTool_Bin/_DASTool_bin CheckMOut_DASTool_bin --tab_table -f MAGs_checkm_DASTool_bin.tab --reduced_tree -t 5 &&

checkm lineage_wf -x fa Concoct CheckMOut_Concoct --tab_table -f MAGs_checkm_Concoct.tab --reduced_tree -t 5
