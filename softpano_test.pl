#!/usr/bin/perl
## softpano_test.pl -- Test for Softpano.pm modules.
## Implements functionaly of Unix cat -- puts one or more files into the standard output
##
## Copyright Nikolai Bezroukov, 2021.
## Licensed under Perl Artistic license
##
## The module requres initialization
##
## --- INVOCATION:
##
##   pythonizer [options] [file_to_process]
##
##--- OPTIONS:

##    -v -- verbosity 0 -minimal (only serious messages) 3 max verbosity (warning, errors and serious); default -v 3
##    -h -- this help
##    -d    level of debugging  default is 0 -- production mode
##          0 -- Production mode
##          1 -- Testing mode. Program is autosaved in Archive (primitive versioning mechanism)
##          2 -- Stop at the beginning of test loop

##--- PARAMETERS:
##
##    1st -- name of  file (only one argument accepted)
##
##--- Invocation (from the directory were softpano_test.pl and Softpano.pl were downloaded )
##    perl softpano_test.pl softpano_test.pl
##
#--- Development History
#
# Ver      Date        Who        Modification
# =====  ==========  ========  ==============================================================
# 1.000  2021/06/05  BEZROUN   Initial implementation
#!start ===============================================================================================================================

   use v5.10.1;
   use warnings;
   use strict 'subs';
   use feature 'state';

#
# Modules used ( from the current directory to make debugging more convenient; will change later)
#
   use Softpano qw(autocommit abend banner logme summary out getopts standard_options);
   $VERSION='1.0';
   $SCRIPT_NAME='softpano_test';
#
# options
#
   $breakpoint=9999; # line from which to debug code. See Pythonizer user guide
   $debug=0;  # 0 -- production mode
              # 1 -- testing mode
              # 2 -- first pass debugging
              # 3 -- provides tracing during the second pass (useful for users for trableshooing infinite loops)
              # 4 -- stop at Perlscan.pm
              # 5 -- stop at particular error message.
   $HOME=$ENV{'HOME'}; # the directory used for autobackup (only if debug>0)
   if( $^O eq 'cygwin' ){
      # $^O is built-in Perl Variable that contains OS name
      $HOME="/cygdrive/f/_Scripts";  # CygWin development mode -- the directory used for backups
   }


   $LOG_DIR='/tmp/'.ucfirst($SCRIPT_NAME);
   banner($LOG_DIR,$SCRIPT_NAME,"Test of $SCRIPT_NAME module. Version $VERSION",30); # Opens SYSLOG and print STDERRs banner; parameter 4 is log retention period
   prolog(); # sets all options, including breakpoint

   if( $debug > 0 ){
      autocommit("$HOME/Archive",$ENV{'PERL5LIB'},qw(Softpano.pm));
   }

out( "===================== Test of mesages generation ==============================");
   logme('I',"Info massage");
   logme('W','A warning');
   logme('E', "This is an error");
   logme('S', "this is a serious error");

   while( $line=<> ){
      if( $debug>=1 && $.>=$breakpoint ){
         say STDERR "\n\n === Line $. $line\n";
         step();
      }
      say $line   # Copy the line
   } # while

   $rc=summary(); # print diagnostic messages summary
   exit $rc;

sub prolog
{
      getopts("hd:v:t:b:",\%options);
      $TabSize=4; # test variable for option -t
      $breakpoint=9999; # test variable for stopping  the program in debug mode at the nessary line of the input
#
# Three standard options -h, -v and -d
#
      standard_options(\%options);
#
# Custom options specific for the application
#
      if(   exists $options{'b'}  ){
        unless ($options{'b'}){
          logme('S',"Option -b should have a numberic value. There is no default.");
          exit 255;
        }
        if(  $options{'b'}>0  && $options{'b'}<9000 ){
           $::breakpoint=$options{'b'};
           ($::debug) && logme('W',"Breakpoint set to line  $::breakpoint");
        }else{
           logme('S',"Wrong value of option -b ( breakpoint): $options('b')\n");
           exit 255;
        }
      }

      if(   exists $options{'t'}  ){
         $options{'t'}=1 if $options{'t'} eq '';
         if(  $options{'t'}>1  && $options{'t'}<10 ){
            $TabSize=$options{'t'};
         }else{
            logme('S',"Range for options -t (tab size) is 2-10. You specified: $options('t')\n");
            exit 255;
         }
      }

#
#
# Application arguments
#
      if(  scalar(@ARGV)==1 ){
         $fname=$ARGV[0];
         unless( -f $fname ){
            abend("Input file $fname does not exist");
         }
      }

} # prolog
