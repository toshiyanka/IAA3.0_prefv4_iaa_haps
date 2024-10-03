#!/usr/intel/bin/perl -w

#PJ updated to work with SBR networks.

package CompInstGLS;

# Pragmas
# =======
use strict;       # Strict coding style
use XML::XPath;   # XML XPath parsing module
use Data::Dumper; # Data dumper (for debugging)

# Sub Prototypes
# ==============
sub new;
sub parse;

# Sub Implementation 
# ==================

sub new {
   # Resolve the class
   my $proto = shift;
   my $class = ref($proto) || $proto;

   # Init
   my $self = {};

   $self->{instanceName}   = undef;
   $self->{componentRef}   = {};
   $self->{config}         = {};  

   
   # Return object reference
   bless ($self, $class);
   return $self;
}

#
# Parse passed XML node to populate class data members
#
sub parse {
   # Get params
   my ($self, $CompInstGLSNode) = @_ ;

   # Locals
   my ($nodeSet, @nodeList, $node); # For XPath search results

   # Get instance name
   $nodeSet = $CompInstGLSNode->find ("spirit:instanceName");
   if( $nodeSet->size() != 0 ) { 
      $self->{instanceName} = $nodeSet->string_value();
   }

    # Get component ref
   $nodeSet = $CompInstGLSNode->find ("spirit:componentRef");
   if( $nodeSet->size() != 0 ) {
      # Get the first (and only) entry of 
      $node = $nodeSet->pop();

      # Name
      $nodeSet = $node->find ('@spirit:name');
      $self->{componentRef}->{name}    = $nodeSet->string_value();

   }

   # Get configurations
   $nodeSet = $CompInstGLSNode->find ("spirit:configurableElementValues/spirit:configurableElementValue");
   if( $nodeSet->size() != 0 ) { 
      @nodeList = $nodeSet->get_nodelist();
      foreach $node (@nodeList) {
         # Get value
         my $value = $node->string_value();

         # Get key
         $nodeSet = $node->find ('@spirit:referenceId');
         my $key = $nodeSet->string_value();

         # Add to hash
         $self->{config}->{$key} = $value;
      }
   }

} # sub parse

1;





# ====================================================
# Main Package 
# ====================================================
package main;

# Pragmas
# =======

use strict;          # Strict coding style
use XML::XPath;      # Import XML XPath parsing modules
use Getopt::Long;    # Import for command line options 
use Data::Dumper;    # For debugging
use Date::Format;    # For generated file time stamp
use File::Spec;      # For getting absolue file names
use File::Basename;  # For getting file dir name 
use Term::ANSIColor; # Import for output coloring
use Term::ANSIColor qw(:constants); # o/p coloring constants

# Set Print Constants
use constant PRINT_ERROR => BOLD, WHITE, ON_RED,    "get_compName.pl - ERROR: ", RESET;
use constant PRINT_INFO  => BOLD, WHITE, ON_GREEN,  "get_compName.pl - INFO : ", RESET;

# ===============
# Subs Prototypes
# ===============
sub getComponentType;   # Get component type given instance name



# Define variables
my ($result, $confName);

# Get options
$result = GetOptions ("conf=s" => \$confName);

# Check arguments are defined correctly
if (!$confName) {
  print PRINT_ERROR, "config argument not defined.\n";
  printUsage();
}

my ($fileName, $PSF_DIR);
$PSF_DIR =".";

# =========
# Parse XML 
# =========

# Define variables
my ($nodeSet, $rootNode, $designNode);

# Read XML file and populate root node
unless( -e "../../verif/tests/networks/${confName}.xml" ) {
   print PRINT_ERROR, "confName does not point to a valid XML file.\n";
   exit( 1 );
}
$rootNode = XML::XPath->new(filename => "../../verif/tests/networks/${confName}.xml");

# get design node
$nodeSet = $rootNode->find ('/spirit:design');
$designNode = $nodeSet->pop();

#
# Data Structures holding parse results
#
my $CompInstGLSMap      = {}; # Maps comp inst name to comp inst object ref

#
# Get component instance nodes from XML
#
$nodeSet = $designNode->find ('spirit:componentInstances/spirit:componentInstance');

#
# Construct a component instance object for each XML comp inst node
#
foreach my $CompInstGLSNode ($nodeSet->get_nodelist) {
   # Construct object/Parse XML node
   my $CompInstGLS = CompInstGLS->new();
   $CompInstGLS->parse($CompInstGLSNode);

   # Add entry to map 
   $CompInstGLSMap->{$CompInstGLS->{instanceName}} = $CompInstGLS;
}

my ($compFile, $cpToolsDir);
$compFile = "sbr.array";

open ( FLO1, ">$compFile" ) or 
   die("Error: cannot open file $compFile\n");


# Calculate @PSF_INST@
# ====================

#
# Loop through all components
#
print FLO1 "; SBR array file\n";
print FLO1 "SIP_COMP_NAME ";
while ( my ($instName,$instRef) = each(%$CompInstGLSMap) ) {

   # 
   # For each psf_rtl component
   #
   if ( $instRef->{componentRef}->{name} eq "rtr_rtl" ) {
      print FLO1 "${instName}, ";
   }
} 
print FLO1 "\n";
print FLO1 "; SIP_COMP_NAME script xml\n";
print PRINT_INFO, "component names were generated for network: $confName \n";


# ===================
# Subs Implementation
# ===================

# 
# Get component type for a specific instance name 
#
sub getComponentType () {
   my ( $instName ) = @_;
   my $compRef = $CompInstGLSMap->{$instName};
   if ( defined $compRef ) {
      return $compRef->{componentRef}->{name};
   } else {
      print PRINT_ERROR, "$instName is not found !!\n";
      return "UNDEF";
   }
}

