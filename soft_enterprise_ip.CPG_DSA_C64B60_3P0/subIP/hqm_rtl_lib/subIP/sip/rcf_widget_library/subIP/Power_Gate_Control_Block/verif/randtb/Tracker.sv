module Tracker #(
                 DEF_PWRON = 1,
                 ICDC      = 1,
                 NCDC      = 1 
             )(
    input logic  early_reset_b,
    input logic  pgcb_clk,
    input logic[ICDC-1:0][3:0] cdc_cs,
    input logic[NCDC-1:0][3:0] ncdc_cs,
    //IOSF CDC Clocks, Resets and Controls
    input  Rtb_pkg::CdcCtlIn_t[ICDC-1:0]   ictl_in,
    input  Rtb_pkg::CdcCtlOut_t[ICDC-1:0]  ictl_out,
    //Non-IOSF CDC Clocks, Resets and Controls
    input  Rtb_pkg::CdcCtlIn_t[NCDC-1:0]   nctl_in,
    input  Rtb_pkg::CdcCtlOut_t[NCDC-1:0]  nctl_out,
    //PGCB Config and Control
    input  Rtb_pkg::PgcbCfg_t              pcfg,
    input  Rtb_pkg::PgdCtlIn_t             pctl_in,
    input  Rtb_pkg::PgdCtlOut_t            pctl_out,
    //CDC Config Control
    input  Rtb_pkg::CdcCfg_t               cfg
    );

    import Rtb_pkg::*;

// PGCB TRACKER: PGCB_DEF_PWRON_trk.out - amshah2
// THE TRACKER FILE SHOULD START DUMPING TRANSACTION STATES FOR THE PGCB WITH DEF_PWRON HIERARCHY
    int lines_A = 0;
    int PGCBTrackerFile_A;
    logic pgcb_clk;
    string pPG_ACTIVE_A, pRESTORE_A, pIDLE_A, pPMC_PG_REQ_A, pPMC_PG_ACK_A, pISM_ULCK_A,pPOKS_DEASS_A,state_ICDC0_A,state_ICDC1_A,state_ICDC2_A,state_ICDC3_A,state_NICDC0_A,state_NICDC1_A,state_NICDC2_A,state_NICDC3_A;

    initial begin
        PGCBTrackerFile_A = $fopen("PGCB_DEF_PWRON_trk.out", "w");
        Header_A(PGCBTrackerFile_A);
        //$fclose(CDCTrackerFile);
    end

    always begin
        @(posedge pgcb_clk iff (early_reset_b && DEF_PWRON));
                TRACK_A(PGCBTrackerFile_A);
        end

    function void Header_A(int file);
        if ((lines_A % 120) == 0) begin
        lines_A++;
                $fdisplay(file, "|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|");
                $fdisplay(file, "| CYCLE TIME | PGCB PG REQ | PMC PG ACK | PGCB ACTIVE | PGCB RESTORE | PG IDLE | ISMS UNLOCKED | POKS DEASS | **IOSF CDC0 STATE*** | **IOSF CDC1 STATE*** | **IOSF CDC2 STATE*** | **IOSF CDC3 STATE*** | **NIOSF CDC0 STATE** | **NIOSF CDC1 STATE** | **NIOSF CDC2 STATE** | **NIOSF CDC3 STATE** |");
                $fdisplay(file, "|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|");

        end
        endfunction: Header_A

function void TRACK_A(int file);
        Header_A(file);
	lines_A++;
	if (!pctl_out.pgcb_pmc_pg_req_b)	begin pPMC_PG_REQ_A	= "PGCB_PG_REQ";	end
	else	
						begin pPMC_PG_REQ_A	= "--";			end
	if (!pctl_in.pmc_ip_pg_ack_b)		begin pPMC_PG_ACK_A	= "PMC_PG_ACK";		end
	else
						begin pPMC_PG_ACK_A	= "--";			end
	if (pctl_out.pgcb_pwrgate_active)	begin pPG_ACTIVE_A	= "PG";			end
	else
						begin pPG_ACTIVE_A	= "PG_NACTIVE"; 	end

	if (pctl_out.pgcb_restore) 		begin pRESTORE_A	= "RESTORE";		end
	else
						begin pRESTORE_A	= "--";			end
         
	if (pctl_out.pgcb_idle) 		begin pIDLE_A		= "IDLE";		end
	else
						begin pIDLE_A		= "--";			end
	if (pctl_out.all_isms_unlocked)		begin pISM_ULCK_A	= "ISM_ULCK";		end
	else
						begin pISM_ULCK_A	= "ISM_LOCK";		end
	if (pctl_out.all_poks_deasserted)	begin pPOKS_DEASS_A	= "POKS_DEASS";		end
	else	
						begin pPOKS_DEASS_A	= "POKS";		end


    for(int i=0; i < ICDC; i++) begin : LOOP_TRACK_A
        if      (cdc_cs[i][3:0] == 4'h0)         state_ICDC0_A = "CDC_OFF";
        else if (cdc_cs[i][3:0] == 4'h1)         state_ICDC0_A = "CDC_OFF_PENDING";
        else if (cdc_cs[i][3:0] == 4'h2)         state_ICDC0_A = "CDC_ON_PENDING";
        else if (cdc_cs[i][3:0] == 4'h3)         state_ICDC0_A = "CDC_ON";
        else if (cdc_cs[i][3:0] == 4'h4)         state_ICDC0_A = "CDC_CGATE_PENDING";
        else if (cdc_cs[i][3:0] == 4'h5)         state_ICDC0_A = "CDC_CGATE";
        else if (cdc_cs[i][3:0] == 4'h6)         state_ICDC0_A = "CDC_PGATE_PENDING";
        else if (cdc_cs[i][3:0] == 4'h7)         state_ICDC0_A = "CDC_PGATE";
        else if (cdc_cs[i][3:0] == 4'h8)         state_ICDC0_A = "CDC_RESTORE";
        else if (cdc_cs[i][3:0] == 4'h9)         state_ICDC0_A = "CDC_RESTORE_NOCLK";
        else if (cdc_cs[i][3:0] == 4'hA)         state_ICDC0_A = "CDC_SYNCOFF_PENDING";
        else if (cdc_cs[i][3:0] == 4'hB)         state_ICDC0_A = "CDC_SYNCOFF";
        else if (cdc_cs[i][3:0] == 4'hC)         state_ICDC0_A = "CDC_SYNCON_ISM";
        else if (cdc_cs[i][3:0] == 4'hD)         state_ICDC0_A = "CDC_FORCE_PENDING";
        else if (cdc_cs[i][3:0] == 4'hE)         state_ICDC0_A = "CDC_FORCE_READY";
        else                                     state_ICDC0_A = "CDC_ERROR";
    end
	
    for(int j=0; j < NCDC; j++) begin : LOOP_TRACK_B
	if      (ncdc_cs[j][3:0] == 4'h0)        state_NICDC0_A = "CDC_OFF";
        else if (ncdc_cs[j][3:0] == 4'h1)        state_NICDC0_A = "CDC_OFF_PENDING";
        else if (ncdc_cs[j][3:0] == 4'h2)        state_NICDC0_A = "CDC_ON_PENDING";
        else if (ncdc_cs[j][3:0] == 4'h3)        state_NICDC0_A = "CDC_ON";
        else if (ncdc_cs[j][3:0] == 4'h4)        state_NICDC0_A = "CDC_CGATE_PENDING";
        else if (ncdc_cs[j][3:0] == 4'h5)        state_NICDC0_A = "CDC_CGATE";
        else if (ncdc_cs[j][3:0] == 4'h6)        state_NICDC0_A = "CDC_PGATE_PENDING";
        else if (ncdc_cs[j][3:0] == 4'h7)        state_NICDC0_A = "CDC_PGATE";
        else if (ncdc_cs[j][3:0] == 4'h8)        state_NICDC0_A = "CDC_RESTORE";
        else if (ncdc_cs[j][3:0] == 4'h9)        state_NICDC0_A = "CDC_RESTORE_NOCLK";
        else if (ncdc_cs[j][3:0] == 4'hA)        state_NICDC0_A = "CDC_SYNCOFF_PENDING";
        else if (ncdc_cs[j][3:0] == 4'hB)        state_NICDC0_A = "CDC_SYNCOFF";
        else if (ncdc_cs[j][3:0] == 4'hC)        state_NICDC0_A = "CDC_SYNCON_ISM";
        else if (ncdc_cs[j][3:0] == 4'hD)        state_NICDC0_A = "CDC_FORCE_PENDING";
        else if (ncdc_cs[j][3:0] == 4'hE)        state_NICDC0_A = "CDC_FORCE_READY";
        else                                     state_NICDC0_A = "CDC_ERROR"; 
    end

	$fdisplay(file, "| %10.2f | %11s | %10s | %11s | %12s | %7s | %13s | %10s | %20s | %20s | %20s | %20s | %20s | %20s | %20s | %20s |", $time/1000.0,pPMC_PG_REQ_A,pPMC_PG_ACK_A,pPG_ACTIVE_A,pRESTORE_A,pIDLE_A,pISM_ULCK_A,pPOKS_DEASS_A,state_ICDC0_A,state_ICDC1_A,state_ICDC2_A,state_ICDC3_A,state_NICDC0_A,state_NICDC1_A,state_NICDC2_A,state_NICDC3_A);

	endfunction: TRACK_A


//PGCB TRACKER - amshah2

// PGCB TRACKER: PGCB_DEF_PWROFF_trk.out - amshah2
// THE TRACKER FILE SHOULD START DUMPING TRANSACTION STATES FOR THE PGCB WITH DEF_PWRON HIERARCHY
int lines_B = 0;
int PGCBTrackerFile_B;
string pPG_ACTIVE_B, pRESTORE_B, pIDLE_B, pPMC_PG_REQ_B, pPMC_PG_ACK_B, pISM_ULCK_B,pPOKS_DEASS_B,state_ICDC0_B,state_ICDC1_B,state_ICDC2_B,state_ICDC3_B,state_NICDC0_B,state_NICDC1_B,state_NICDC2_B,state_NICDC3_B;

initial begin
        PGCBTrackerFile_B = $fopen("PGCB_DEF_PWROFF_trk.out", "w");
        Header_B(PGCBTrackerFile_B);
        //$fclose(CDCTrackerFile);
end

always begin
        @(posedge pgcb_clk iff (early_reset_b && !DEF_PWRON));
                TRACK_B(PGCBTrackerFile_B);
        end

function void Header_B(int file);
        if ((lines_B % 120) == 0) begin
        lines_B++;
                $fdisplay(file, "|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|");
                $fdisplay(file, "| CYCLE TIME | PGCB PG REQ | PMC PG ACK | PGCB ACTIVE | PGCB RESTORE | PG IDLE | ISMS UNLOCKED | POKS DEASS | **IOSF CDC0 STATE*** | **IOSF CDC1 STATE*** | **IOSF CDC2 STATE*** | **IOSF CDC3 STATE*** | **NIOSF CDC0 STATE** | **NIOSF CDC1 STATE** | **NIOSF CDC2 STATE** | **NIOSF CDC3 STATE** |");
                $fdisplay(file, "|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|");

        end
        endfunction: Header_B

function void TRACK_B(int file);
        Header_B(file);
        lines_B++;
        if (!pctl_out.pgcb_pmc_pg_req_b)        begin pPMC_PG_REQ_B	= "PGCB_PG_REQ"; end
        else
                                                begin pPMC_PG_REQ_B	= "--";     end
	if (!pctl_in.pmc_ip_pg_ack_b)		begin pPMC_PG_ACK_B	= "PMC_PG_ACK";	end
	else
						begin pPMC_PG_ACK_B	= "--";		end	
        if (pctl_out.pgcb_pwrgate_active)       begin pPG_ACTIVE_B	= "PGCB_PG_ACT";         end
        else
                                                begin pPG_ACTIVE_B	= "--"; end

        if (pctl_out.pgcb_restore)              begin pRESTORE_B	= "RESTORE";    end
        else
                                                begin pRESTORE_B	= "--"; end

        if (pctl_out.pgcb_idle)                 begin pIDLE_B		= "IDLE";       end
        else
                                                begin pIDLE_B		= "--";   end
        if (pctl_out.all_isms_unlocked)         begin pISM_ULCK_B	= "ISM_ULCK";   end
        else
                                                begin pISM_ULCK_B	= "ISM_LOCK"; end
        if (pctl_out.all_poks_deasserted)       begin pPOKS_DEASS_B	= "POKS_DEASS"; end
        else
                                                begin pPOKS_DEASS_B	= "POKS";       end

    for (int n=0; n < ICDC; n++) begin : LOOP_TRACK_C
        if      (cdc_cs[n][3:0] == 4'h0)         state_ICDC0_B = "CDC_OFF";
        else if (cdc_cs[n][3:0] == 4'h1)         state_ICDC0_B = "CDC_OFF_PENDING";
        else if (cdc_cs[n][3:0] == 4'h2)         state_ICDC0_B = "CDC_ON_PENDING";
        else if (cdc_cs[n][3:0] == 4'h3)         state_ICDC0_B = "CDC_ON";
        else if (cdc_cs[n][3:0] == 4'h4)         state_ICDC0_B = "CDC_CGATE_PENDING";
        else if (cdc_cs[n][3:0] == 4'h5)         state_ICDC0_B = "CDC_CGATE";
        else if (cdc_cs[n][3:0] == 4'h6)         state_ICDC0_B = "CDC_PGATE_PENDING";
        else if (cdc_cs[n][3:0] == 4'h7)         state_ICDC0_B = "CDC_PGATE";
        else if (cdc_cs[n][3:0] == 4'h8)         state_ICDC0_B = "CDC_RESTORE";
        else if (cdc_cs[n][3:0] == 4'h9)         state_ICDC0_B = "CDC_RESTORE_NOCLK";
        else if (cdc_cs[n][3:0] == 4'hA)         state_ICDC0_B = "CDC_SYNCOFF_PENDING";
        else if (cdc_cs[n][3:0] == 4'hB)         state_ICDC0_B = "CDC_SYNCOFF";
        else if (cdc_cs[n][3:0] == 4'hC)         state_ICDC0_B = "CDC_SYNCON_ISM";
        else if (cdc_cs[n][3:0] == 4'hD)         state_ICDC0_B = "CDC_FORCE_PENDING";
        else if (cdc_cs[n][3:0] == 4'hE)         state_ICDC0_B = "CDC_FORCE_READY";
        else                                     state_ICDC0_B = "CDC_ERROR";
    end	

    for (int m=0; m < NCDC; m++) begin : LOOP_TRACK_D
        if      (ncdc_cs[m][3:0] == 4'h0)        state_NICDC0_B = "CDC_OFF";
        else if (ncdc_cs[m][3:0] == 4'h1)        state_NICDC0_B = "CDC_OFF_PENDING";
        else if (ncdc_cs[m][3:0] == 4'h2)        state_NICDC0_B = "CDC_ON_PENDING";
        else if (ncdc_cs[m][3:0] == 4'h3)        state_NICDC0_B = "CDC_ON";
        else if (ncdc_cs[m][3:0] == 4'h4)        state_NICDC0_B = "CDC_CGATE_PENDING";
        else if (ncdc_cs[m][3:0] == 4'h5)        state_NICDC0_B = "CDC_CGATE";
        else if (ncdc_cs[m][3:0] == 4'h6)        state_NICDC0_B = "CDC_PGATE_PENDING";
        else if (ncdc_cs[m][3:0] == 4'h7)        state_NICDC0_B = "CDC_PGATE";
        else if (ncdc_cs[m][3:0] == 4'h8)        state_NICDC0_B = "CDC_RESTORE";
        else if (ncdc_cs[m][3:0] == 4'h9)        state_NICDC0_B = "CDC_RESTORE_NOCLK";
        else if (ncdc_cs[m][3:0] == 4'hA)        state_NICDC0_B = "CDC_SYNCOFF_PENDING";
        else if (ncdc_cs[m][3:0] == 4'hB)        state_NICDC0_B = "CDC_SYNCOFF";
        else if (ncdc_cs[m][3:0] == 4'hC)        state_NICDC0_B = "CDC_SYNCON_ISM";
        else if (ncdc_cs[m][3:0] == 4'hD)        state_NICDC0_B = "CDC_FORCE_PENDING";
        else if (ncdc_cs[m][3:0] == 4'hE)        state_NICDC0_B = "CDC_FORCE_READY";
        else                                     state_NICDC0_B = "CDC_ERROR";
    end
	
        $fdisplay(file, "| %10.2f | %11s | %10s | %11s | %12s | %7s | %13s | %10s | %20s | %20s | %20s | %20s | %20s | %20s | %20s | %20s |", $time/1000.0,pPMC_PG_REQ_B,pPMC_PG_ACK_B,pPG_ACTIVE_B,pRESTORE_B,pIDLE_B,pISM_ULCK_B,pPOKS_DEASS_B,state_ICDC0_B,state_ICDC1_B,state_ICDC2_B,state_ICDC3_B,state_NICDC0_B,state_NICDC1_B,state_NICDC2_B,state_NICDC3_B);

        endfunction: TRACK_B

//PGCB TRACKER - amshah2
endmodule
