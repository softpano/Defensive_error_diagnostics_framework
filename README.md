<h1>Defensive error diagnostic framework</h1>

<p>Many people independently came to the subset of ideas of defensive programming, so it is impossible to attribute this concept to 
a single author. As an example of early attempt to formulate some principles of defensive programming style we can list&nbsp; Tom Christiansen recommendations 
(Jan 1, 1998) for Perl language. Perl does not have strict typing of variables and, by default, does not&nbsp; require any declaration 
of variables, creating potential for misspelled variables slipping into production version of the program. (unless you use <tt>strict</tt> pragma 
-- the use the latter became standard in modern Perl). While they are more then 20 years old they are still relevant:&nbsp;&nbsp; </p>
<ul>

   <li><tt>use strict </tt></li>

   <li><tt>#!/usr/bin/perl -w </tt></li>

   <li><em>Check all syscall return values, printing</em> $! </li>

   <li><em>Watch for external program failures in</em> $? </li>

   <li>Check $@ after <code>eval&quot;&quot;</code> or <code>s///ee</code>. </li>

   <li>[Use] Parameter asserts </li>

   <li><tt>#!/usr/bin/perl -T</tt>&nbsp; (taint mode in which Perl distrust any data from outside world, see below)</li>

   <li>Always have an <code>else</code> after a chain of <code>elsif</code>s </li>

   <li>Put commas at the end of lists to so your program won&#39;t break if someone inserts another item at the end of the list.</li>
</ul>

<p><b>The program should always provide meaningful diagnostics and logging.</b> Meaningful diagnostic is typically a weak spot of many Unix utilities, 
   which were written when every byte of storage was a premium and computer used to have just one 1M bytes of memory or less (Xenix 
   -- one of the early Unixes worked well on 2MB IBM PCs)</p>

<p>If messages 
   you get in case of errors or crashes are cryptic and its takes a lot of efforts to related the message to the root case. If you 
   are the user of the program that you yourself have written that insult after injury :-) </p>

<p>Here we strive to the 
   quality of diagnostics that is typically demonstrated by debugging complier. Defensive programming also presume presence of a sophisticated 
   logging infrastructure within the program. Logs should are easy to parse and filter for relevant information. </p>

<p>Defensive diagnostic framework module provides&nbsp; the following functionality:</p>
<ol>

<li><b>All messages are produced with the line in which they occurred.  </b>

<li><b>Messages are printed with the error code, which signify the severity. Four levels are distinguished:</b><ol type="a">

<li type="a"><tt>Warnings</tt>: informational messages that do not affect the validly of the program output or any results of 
      its execution. Still the situation that deserve some attention </li>

<li><tt>Errors</tt>: (<em>correctable errors</em>) Messages that something went wrong but the results execution of the program 
      is still OK and/or output of the program 
      most probably is still valid</li>

<li><tt>Severe errors</tt> (<em>failures</em>). Program can continue but the results are most probably a garbage and should be 
      discarded. Diagnostic messages provides after this point might still have a value. </li>

<li><tt>Terminal or internal errors</tt> (<em>abends</em>). Program can't continue at this point and need to exit. In case of 
      cron jobs, for such abnormal 
      situations you can even try to email the developer. </li>
</ol>

<p>To achieve this one needs to write or borrow and adapt a special 
   messages generation subroutine for example<tt> logmes</tt>, modeled after one used in compilers. One of the parameters passes to 
this subroutines should be the one byte code of the error (or its number equivalent) along with the line in which error was 
detected.&nbsp; For example</p>
<ul>

<li><tt>W</tt> -- warning --&nbsp; the program can continue; most probably results will be correct, but in rare cases this 
   situation can lead to incorrct or incomplete results. </li>

<li><tt>E </tt>-- error&nbsp; -- continuation of the program possible and the result most probably will be correct (correctable 
   errors)</li>

<li><tt>S </tt>-- failure (<em>serious error</em>)&nbsp; -- continuation of program possible but the result most probably will be 
   useless or wrong.</li>

<li><tt>T</tt> -- terminal/fatal error (<em>abend</em>) </li>
</ul>

<p>The abbreviated string for those codes has the mnemonic string <tt>West </tt></p>
</li>  


<li>Output of those message should be regulated by option verbosity (-v). Terminal errors should be not suppressible; all other 
   can be </li>

<li>There also should two types if informational messages (which are not suppressible):
<ol>

<li>&quot;I&quot; (informational) messages produced with the error code</li>

<li>Regular output which is produced without error code, as is. </li>
</ol>
</li>

<li><b>All return codes from external programs and modules are checked</b>. For example after executing rm command. &quot;Postconditions&quot; often involve checking the return code. Generally a postcondition is a Boolean condition that holds true upon exit from the subroutine or method. For example in case of sysadmin scripts each executed 
   external command is checked for the return code (RC) and if the code is outside acceptable range appropriate error is generated.
   </li>

<li><b>There is a pre-planned debugging infrastructure within the program</b>. At least, there is a special variable (typically 
   variable DEBUG) should be introduced&nbsp; that allow to 
   switch program to debugging mode in which it produced more output and/or particular actions are blocked or converted to printing 
   statement.&nbsp; Ut us should be aviable via options (for example via option -d)</li>

<li>There should be a possibility to output of the summary of the message at the end of execution of programs</li>
</ol>
<p>For more current and more detailed ingomation see also <a href="http://softpanorama.org/Admin/Sp_admin_utils/defensive_error_diagnostic_framework.shtml">Defensive error diagnostic framework</a></p>
