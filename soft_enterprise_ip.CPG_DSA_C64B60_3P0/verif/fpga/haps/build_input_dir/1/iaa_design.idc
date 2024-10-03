device prepare_incremental 1
iice new {IICE_0} -type regular -mode {none} -uc_groups {}
iice controller -iice {IICE_0} none
iice sampler -iice {IICE_0} -compression 1
iice sampler -iice {IICE_0} -depth 2048
iice clock -iice {IICE_0} -edge positive {/dsab_ip/prim_clk}
signals add -iice {IICE_0} -silent -sample -trigger {/dsab_ip/tdparity}\
{/dsab_ip/tpasidtlp}\
{/dsab_ip/tsai}\
{/dsab_ip/tcparity}\
{/dsab_ip/trsvd0_7}\
{/dsab_ip/trsvd1_1}\
{/dsab_ip/trsvd1_3}\
{/dsab_ip/trsvd1_7}\
{/dsab_ip/ttd}\
{/dsab_ip/taddress}\
{/dsab_ip/tfbe}\
{/dsab_ip/tlbe}\
{/dsab_ip/ttag}\
{/dsab_ip/trqid}\
{/dsab_ip/tlength}\
{/dsab_ip/tat}\
{/dsab_ip/tchain}\
{/dsab_ip/tido}\
{/dsab_ip/tns}\
{/dsab_ip/tro}\
{/dsab_ip/tep}\
{/dsab_ip/tth}\
{/dsab_ip/ttc}\
{/dsab_ip/ttype}\
{/dsab_ip/tfmt}\
{/dsab_ip/cmd_rtype}\
{/dsab_ip/cmd_chid}\
{/dsab_ip/cmd_put}\
{/dsab_ip/credit_data}\
{/dsab_ip/credit_cmd}\
{/dsab_ip/credit_rtype}\
{/dsab_ip/credit_chid}\
{/dsab_ip/credit_put}\
{/dsab_ip/mdparity}\
{/dsab_ip/mpasidtlp}\
{/dsab_ip/msai}\
{/dsab_ip/mcparity}\
{/dsab_ip/mrsvd0_7}\
{/dsab_ip/mrsvd1_1}\
{/dsab_ip/mrsvd1_3}\
{/dsab_ip/mrsvd1_7}\
{/dsab_ip/mtd}\
{/dsab_ip/maddress}\
{/dsab_ip/mfbe}\
{/dsab_ip/mlbe}\
{/dsab_ip/mtag}\
{/dsab_ip/mrqid}\
{/dsab_ip/mlength}\
{/dsab_ip/mat}\
{/dsab_ip/mido}\
{/dsab_ip/mns}\
{/dsab_ip/mro}\
{/dsab_ip/mep}\
{/dsab_ip/mth}\
{/dsab_ip/mtc}\
{/dsab_ip/mtype}\
{/dsab_ip/mfmt}\
{/dsab_ip/gnt_type}\
{/dsab_ip/gnt_rtype}\
{/dsab_ip/gnt_chid}\
{/dsab_ip/gnt}\
{/dsab_ip/req_chain}\
{/dsab_ip/req_ro}\
{/dsab_ip/req_ns}\
{/dsab_ip/req_tc}\
{/dsab_ip/req_dlen}\
{/dsab_ip/req_cdata}\
{/dsab_ip/req_rtype}\
{/dsab_ip/req_chid}\
{/dsab_ip/req_put}

