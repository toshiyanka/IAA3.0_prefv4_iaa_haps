// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_DFM_MCUTS.rs.rca 1.4 Wed Oct 30 13:37:07 2013 gmonroy Experimental $
//
// $Log: p1273dx_DFM_MCUTS.rs.rca $
// 
//  Revision: 1.4 Wed Oct 30 13:37:07 2013 gmonroy
//  Refactored DFM code to allow future features
// 
//  Revision: 1.3 Fri Aug  9 19:15:56 2013 gmonroy
//  Added p1273.6 support
// 
//  Revision: 1.2 Tue Mar 26 19:49:14 2013 gmonroy
//  Fixed false flags in DFM_MX_48 by reimplementing opposite-end overlay function.
// 
//  Revision: 1.1 Mon Mar 18 16:03:39 2013 gmonroy
//  1273-specific metal cut DFM rules.
//

//Dipto Thakurta 17Jan13
//Code for cuts M2 and above.

#ifndef _P1273DX_DFM_MCUTS_RS_
#define _P1273DX_DFM_MCUTS_RS_

#if defined(_drDFM)

//Line end overlap
drMinOverlapOpposite2Marker_(metal2bc, non_gate_dir, M2_41, M2_21,
  <=0.028, (0.028, 0.048], M2_48+0.030, M2_48+0.016, DFM_M2_48N1p30, DFM_M2_48N2p16);
dfm_register(DFM_M2_48N1p30); // $
dfm_register(DFM_M2_48N2p16); // $

drMinOverlapOpposite2Marker_(metal3bc, gate_dir, M3_41, M3_21,
  <=0.028, (0.028, 0.048], M3_48+0.030, M3_48+0.016, DFM_M3_48N1p30, DFM_M3_48N2p16);
dfm_register(DFM_M3_48N1p30); // $
dfm_register(DFM_M3_48N2p16); // $

drMinOverlapOpposite2Marker_(metal4bc, non_gate_dir, M4_41, M4_21,
  <=0.028, (0.028, 0.048], M4_48+0.030, M4_48+0.016, DFM_M4_48N1p30, DFM_M4_48N2p16);
dfm_register(DFM_M4_48N1p30); // $
dfm_register(DFM_M4_48N2p16); // $

#if (_drPROCESS != 6)
  drMinOverlapOpposite2Marker_(metal5bc, gate_dir, M5_41, M5_21,
    <=0.028, (0.028, 0.048], M5_48+0.030, M5_48+0.016, DFM_M5_48N1p30, DFM_M5_48N2p16);
  dfm_register(DFM_M5_48N1p30); // $
  dfm_register(DFM_M5_48N2p16); // $

#endif

//Skip track offset
drLineEndOffsetBCB(metal2bc, [0.0,   0.032], <(M2_147+0.020), M2_46, non_gate_dir, gate_dir, DFM_M2_147p20);
dfm_register(DFM_M2_147p20); // $

drLineEndOffsetBCB(metal2bc, (0.032, 0.046], <(M2_148+0.020), M2_46, non_gate_dir, gate_dir, DFM_M2_148p20);
dfm_register(DFM_M2_148p20); // $

drLineEndOffsetBCB(metal3bc, [0.0,   0.032], <(M3_147+0.020), M3_46, gate_dir, non_gate_dir, DFM_M3_147p20);
dfm_register(DFM_M3_147p20); // $

drLineEndOffsetBCB(metal3bc, (0.032, 0.046], <(M3_148+0.020), M3_46, gate_dir, non_gate_dir, DFM_M3_148p20);
dfm_register(DFM_M3_148p20); // $

drLineEndOffsetBCB(metal4bc, [0.0,   0.032], <(M4_147+0.020), M4_46, non_gate_dir, gate_dir, DFM_M4_147p20);
dfm_register(DFM_M4_147p20); // $

drLineEndOffsetBCB(metal4bc, (0.032, 0.046], <(M4_148+0.020), M4_46, non_gate_dir, gate_dir, DFM_M4_148p20);
dfm_register(DFM_M4_148p20); // $

#if (_drPROCESS != 6)
  drLineEndOffsetBCB(metal5bc, [0.0,   0.032], <(M5_147+0.020), M5_46, gate_dir, non_gate_dir, DFM_M5_147p20);
  dfm_register(DFM_M5_147p20); // $

  drLineEndOffsetBCB(metal5bc, (0.032, 0.046], <(M5_148+0.020), M5_46, gate_dir, non_gate_dir, DFM_M5_148p20);
  dfm_register(DFM_M5_148p20); // $

#endif

#endif  

#endif
