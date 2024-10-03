##-----------------------------------------------
## CSME Cluster-specific Custom Work Module: "TestBuilder"
## This file is used as a supplemental ASM generation facility.
## This file is not intended to be directly re-used by our Customers,
## but that may be possible with minimal adjustment.
##-----------------------------------------------
## Need help?
##   Use Intelpedia:    https://intelpedia.intel.com/Ace_Simulation_Environment
##   Use AceUsersGuide: http://nsec.ch.intel.com/cad_nfs/ace/doc/AceUsersGuide.pdf 
##
## Find ACE bugs?
##   File HSD ticket: https://vthsd.fm.intel.com/hsd/datm/#da_help/default.aspx?ldudef=1
##-----------------------------------------------
## AceUserGuide: Chapter 6.5 

package csme::TestBuilder;
use strict;
use Utilities::ProgramTools qw(check_args test_eval deepcopy);
use Utilities::Print;
use Utilities::System qw(Exit);

# Useful for debugging
use Data::Dumper;
require "dumpvar.pl";

use vars qw(@ISA @EXPORT_OK);
# Include the parents
use Ace::GenericScrag qw($CWD);
use Ace::WorkModules::DefaultTestBuilder;
use Ace::CheckerManager;

require Exporter;
@ISA = qw(Exporter Ace::WorkModules::DefaultTestBuilder);
#--------------------------------------------------------------------------------
sub new {
    my ($class, %args) = @_;
    # Print more info when exit on error
    $Utilities::System::CROAK_ON_EXIT = 1;  
    
    # dprint -> prints to STDOUT when -tool_debug on command-line
    dprint "# $class\::new\n";
  
    # Call the parent's constructor
    my $self = $class->SUPER::new(%args);
    
    # Set the parent scope (to self is single scope)
    $self->{_super_scope} = "$ENV{ACE_PROJECT}";
  
    # Set new MEMBER Vars
    return $self;
}
#--------------------------------------------------------------------------------
# Add in customize processes into default scrag
#--------------------------------------------------------------------------------
sub create_scrag {
    my ($self, %args) = @_;
    my ($cur_scope, $base_scope) = ($self->{_cur_scope}, Ace::UDF::get_base_scope());
    my $merged_test_opts = $args{-merged_test_opts};
    my $test_data = $args{-test_data};
    my $tid = $test_data->{$base_scope}{stid};
    my $fragment;
    my $testname = $args{-test_data}->{$cur_scope}{'name'};    # Note: $cur_scope is expected to be 'csme'.
    my $testrun_dir = $args{-test_data}->{$base_scope}{'top_testrun_dir'};   # Note: $base_scope is expected to be "NON_SCOPED".
    my $testsrc_dir = $args{-test_data}->{$cur_scope}{'path'};
    my $IP_ROOT = $ENV{IP_ROOT};  # This environment-variable use renders this custom work-module non-reusable.  We're not expecting to provide this to the Customer, however, so this is acceptable.
    my $iasm_assembler;
    my $lrbasm_assembler;

    # Sanity-check.
    if ($cur_scope ne 'csme' || $base_scope ne 'NON_SCOPED') {
        die "ERROR(", __FILE__, ":", __LINE__, "): \$cur_scope is not 'csme' but $cur_scope instead, or \$base_scope is not 'NON_SCOPED' but $base_scope instead.\n";
    }

    if (exists($ENV{CSME_TESTBUILDER_DEBUG})) {
        print "DEBUGGING(", __FILE__, ":", __LINE__, "): Test name is ", $testname, ", test source dir is ", $testsrc_dir, ", and test run-dir. is ", $testrun_dir, "\n";
        &main::dumpValue(\%args);  # Uncomment this to expose the structure in %args, to examine the entries for potential use.
    }

    if (-e "$testsrc_dir/${testname}.asm") {
        # First, locate the CSE-supplied 'iasm' executable.  Searching for it is both fast, and avoids the need to track the specific 'cfmia' release version information.
        # Which assembler to use?  'lrbasm' is what we used on IE; it appears to support more interesting pragmas embedded within .asm file comments, and half of Lakemont's tests use this.
        # The 'iasm' assembler is used for the other half of Lakemont's tests (roughly speaking.)  For now, both are provided, so support both.
        if (exists($ENV{CSME_TESTBUILDER_ASM_OVERRIDE_IASM_ASSEMBLER}) && -x $ENV{CSME_TESTBUILDER_ASM_OVERRIDE_IASM_ASSEMBLER}) {
            $iasm_assembler = $ENV{CSME_TESTBUILDER_ASM_OVERRIDE_IASM_ASSEMBLER};
        } else {
            $iasm_assembler = `find $IP_ROOT/subIP/sip/cse/units/cse/cfmia/ -maxdepth 4 -mindepth 4 -type f -wholename '*/CPU_IP_RELEASE/tools/iasm/iasm' -print`;
        }
        chomp($iasm_assembler);
        die "ERROR(", __FILE__, ":", __LINE__, "): unable to locate the CSE-supplied 'iasm' assembler executable.\n" if ($iasm_assembler eq '' || ! -x "$iasm_assembler");

        if (exists($ENV{CSME_TESTBUILDER_ASM_OVERRIDE_LRBASM_ASSEMBLER}) && -x $ENV{CSME_TESTBUILDER_ASM_OVERRIDE_LRBASM_ASSEMBLER}) {
            $lrbasm_assembler = $ENV{CSME_TESTBUILDER_ASM_OVERRIDE_LRBASM_ASSEMBLER};
        } else {
            $lrbasm_assembler = `find $IP_ROOT/subIP/sip/cse/units/cse/cfmia/ -maxdepth 4 -mindepth 4 -type f -wholename '*/CPU_IP_RELEASE/valid/bin/lrbasm' -print`;
        }
        chomp($lrbasm_assembler);
        die "ERROR(", __FILE__, ":", __LINE__, "): unable to locate the CSE-supplied 'lrbasm' assembler executable.\n" if ($lrbasm_assembler eq '' || ! -x "$lrbasm_assembler");

        # In IE days, we used a .asm filename prefix to select which assembler to use.  Perhaps we should simplify and just use only one of their two assemblers: that used by CSE.
        #$fragment .= Ace::GenericScrag::add_cmd('CSME_ASM', "$iasm_assembler -mo -32 ${testname}.asm");

        # Ace, at the time of this run-script being run, is not sitting in the run-dir, so use a sub-shell (being careful to use tcsh/sh-compatible syntax) to 'cd' to it before running the assembler.
        # (Include the pre-run of the m4 macros, just because that's what I used in IE, and that is quicker at this moment than replacing the macro invocations in my IE .asm file.)
        $fragment .= Ace::GenericScrag::add_cmd('CSME_ASM_HEX_PERMS', "chmod u+w $testrun_dir/*.hex");  # This is required when running on GateKeeper-built models, due to permissions being restrictive on the copied-over .hex files from the default area.
        $fragment .= Ace::GenericScrag::add_cmd('CSME_ASM_ASSEMBLER', "(cd $testrun_dir; m4 $IP_ROOT/scripts/asm_macros.m4 ${testname}.asm > ${testname}.asm.m4 && mv ${testname}.asm.m4 ${testname}.asm && $lrbasm_assembler ${testname}.asm && $IP_ROOT/scripts/32obj_2_rdmem.pl -res . -obj ${testname}.32.obj)");

        if (exists($ENV{CSME_TESTBUILDER_DEBUG})) {
            print "DEBUGGING(", __FILE__, ":", __LINE__, "): generated \$fragment:\n";
            &main::dumpValue(\$fragment);
        }
    }

    # There may be needs to hand-craft .hex files (think FPGA issue-reproduction, and so on), in which case, use them in preference of any such files generated from the .asm file (handled above.)
    # (It's okay if they don't exist though.)
    for (my $i = 0; $i < 4; $i++) {
        $fragment .= Ace::GenericScrag::add_cmd('CSME_ASM_CP_TEST_HEX', "test -f $testsrc_dir/c71p8rgfrom2048x128cm8csme${i}.hex && cp $testsrc_dir/c71p8rgfrom2048x128cm8csme${i}.hex $testrun_dir || true");
    }

    return $fragment;
}
#--------------------------------------------------------------------------------

1;

