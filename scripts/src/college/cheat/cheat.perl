#!/usr/local/bin/perl -w
#
# Author:	Ethan Miller (elm@ethanmiller.com)
#		University of California, Santa Cruz
#		Copyright (c) 2000.
#
# This program reads files (specified on the command line),
# converts them into tokens, and runs similarity computations on them.
# The results are printed on the standard output.  It can also take
# "predigested" files that have already been tokenized; this saves
# running time and cuts down on memory usage.
#
# IMPORTANT: there's no set guide for how similar files must be to be
# copied from one another.  It'll vary by program type.  However, it'll
# almost always be true that the programs with the highest similarity
# (closest to +1.000) are most likely to be derived from one another.
# In all cases, possible cases of cheating should be inspected by
# the instructor *before* any accusations are made.
#
# $Id: cheatcheck,v 1.9 2000/10/17 18:24:13 elm Exp elm $
#

# Ngram length.  Higher values run slower and are more sensitive to small
# differences.  Values of 3-6 are probably best.
my $ngramlen = 5;

# Language.  Default is C/C++
my $language = "c";

# Top # of pairs
my $topnum = 30;

#======================================================================
#
# No user serviceable parts below this line....
#
#======================================================================
use strict qw(vars subs);
use Getopt::Long;

sub setlanguage ($)
{
    $language = $_[0];
}

sub printHelpAndExit ($) {
    print << "EOM";
Usage: $0 [options] <file1> <file2> [file3 ...]
Valid options are:
  -language <language>  Available languages are C, Java, Pascal, Esim,
text, html
  -ngramlen <length>    Use ngrams of this length (default=$ngramlen)
  -top <num>            Print only the top <num> similarity pairs
(default=$topnum)
  -c                    Use the C/C++ language (default)
  -esim                 Use the Esim language
  -java                 Use the Java language
  -pascal               Use the Pascal language
  -english, -text       Use plain text
  -html			Use plain text, but remove HTML from tagged documents
  -debug                Print debugging statements
  -skipps               Skip PostScript documents
  -help                 Print this message
EOM
    exit ();
}

my $debug = 0;
my $skipPS = 0;
my %options = (
	       "language=s"	=> \$language,
	       "ngramlength=i"	=> \$ngramlen,
	       "top=i"		=> \$topnum,
	       "c"		=> \&setlanguage,
	       "esim"		=> \&setlanguage,
	       "java"		=> \&setlanguage,
	       "english"	=> \&setlanguage,
	       "text"		=> \&setlanguage,
	       "html"		=> \&setlanguage,
	       "pascal"		=> \&setlanguage,
	       "debug" 		=> \$debug,
	       "skipps" 	=> \$skipPS,
	       "help"		=> \&printHelpAndExit,
	       );

my %keywords;
my %tokens = (
	      "c"      => ["if", "else", "for", "while", "do", "continue",
			   "break", "return", "switch", "case" ,"default",
			   "struct", "class", "new", "delete", "this",
			   "void", "int", "long", "unsigned", "char",
			   "double", "const", "static", "extern",
			   "float", "short", "enum", "union",
			   "typedef", "sizeof", "union", "public",
			   "private", "virtual", "template", "inline"],
	      "java"   => ["abstract", "boolean", "break", "byte",
			   "byvalue", "case", "cast", "default", "do",
			   "double", "else", "extends", "false", "final",
			   "goto", "if", "implements", "import", "inner",
			   "instanceof", "int", "operator", "outer",
			   "package", "private", "protected", "public",
			   "rest", "synchronized", "this", "throw",
			   "throws", "transient", "true", "try",
			   "catch", "char", "class", "const", "continue",
			   "finally", "float", "for", "interface", "long",
			   "native", "new", "null", "return", "short",
			   "static", "super", "switch", "var", "void",
			   "volatile", "while"],
	      "esim"   => ["and", "or", "xor", "not", "is", "on",
			   "rising", "falling", "from", "to", "width",
			   "read", "write", "select", "with", "otherwise",
			   "define", "end", "signal", "memory", "circuits",
			   "after", "use", "when", "else", "ns", "us", "ms"],
	      "pascal" => ["program", "begin", "end", "write", "writeln",
			   "read", "readln", "nil",
			   "unit", "interface", "implementation",
			   "integer", "byte", "real", "boolean", "char",
			   "shortint", "word", "longint", "string", "var",
			   "set", "record", "in", "and", "or", "xor", "not",
			   "for", "to", "downto", "do", "repeat", "until",
			   "while", "if", "then", "else", "case", "of",
			   "procedure", "function", "forward",
			   "array", "type", "const", "goto",
			   "object", "private", "virtual"]
	      );

printHelpAndExit("help") unless (GetOptions (%options));


for (my ($cur,$i) = ("b", 0); $i < @{$tokens{$language}}; $cur++, $i++)
{
    $cur = "A" if ($cur eq "z");
    $keywords{$tokens{$language}->[$i]} = $cur;
}

die "Ngram length ($ngramlen) out of range.\n"
    unless (($ngramlen >= 2) and ($ngramlen <= 10));
$language = "text" if ($language =~ /english/i);
die "Unrecognized language ($language).\n"
    unless ($language =~ /^(C|Esim|Java|Pascal|text|html)$/i);

print STDERR "\nProcessing $language files with ngram length
$ngramlen.\n\n";

my ($tokenified, %fileTable, $value, $cursub, %centroid);
my ($f, $avg, $v1, $file1, $j, $file2, $sim);
my ($f1, $f2, $tmp, %results, $k, $v, $centroidsq);
my (@files, @donefiles);

foreach $f (@ARGV)
{
    push @files, $f if (-T $f);
}
@ARGV = @files;

undef $/;

# Snarf in the files, one by one
while (<>) {
    my $curfn = $ARGV;
    if (($skipPS and /PS-Adobe/i) or (-s $curfn > 200000))
    {
	print STDERR "Skipping $curfn (PostScript).\n";
	next;
    }
    push @donefiles, $curfn;
    print STDERR "Scanning in $curfn...";
    # If there's a space, tokenify it.  Otherwise, it has already been
    # turned into tokens.  Pre-tokenifying will save time and (more
    # helpful) space in this program
    if ($language =~ /html/i and /\<HTML\>/i)
    {
	s/\<[^>]+\>/ /g;
	s/\&[a-zA-Z0-9]+\;/ /g;
    }
    if ($language =~ /text|html/i)
    {
	s/\W+/_/gm;
	s/\_+/_/gm;
	$tokenified = lc ($_);
    }
    elsif (/\s/) {
	$tokenified = tokenify ($_);
    } else {
	$tokenified = $_;
    }
    $fileTable{$curfn}{nNgrams} = length ($tokenified) + 1 - $ngramlen;
    $f1 = \%{$fileTable{$curfn}};
    $value = 1 / $f1->{nNgrams};
    for (my $i = 0; $i < $f1->{nNgrams}; $i++) {
	$cursub = substr ($tokenified, $i, $ngramlen);
	$f1->{ngtbl}{$cursub} += $value;
	$centroid{$cursub} += $value;
    }
    print STDERR "done.\n";
}

#
# Normalize the centroid.
#
my $totalNgrams = scalar keys %centroid;
print STDERR "Normalizing centroid of length $totalNgrams...";
while (($k, $v) = each %centroid) {
    $v = ($centroid{$k} /= @donefiles);
    $centroidsq += $v * $v;
}
print STDERR "done.\n";

#
# Calculate the document vector lengths.
#
print STDERR "Calculating vector lengths";
foreach $f (@donefiles) {
    print STDERR ".";
    $f1 = \%{$fileTable{$f}};
    $f1->{prod} = 0.0;
    $f1->{veclen} = 0.0;
    while (($k, $avg) = each %centroid) {
	if (exists $f1->{ngtbl}{$k}) {
	    $v1 = $f1->{ngtbl}{$k};
	} else {
	    $v1 = 0;
	}
	$f1->{prod} += $v1 * $avg;
	$v1 -= $avg;
	$f1->{veclen} += $v1 * $v1;
    }
    $f1->{veclen} = sqrt ($f1->{veclen});
}
print STDERR "done.\n";

#
# Calculate similarity for each pair of documents
#
for (my $i = 0; $i < @donefiles; $i++) {
    $file1 = $donefiles[$i];
    next if ($fileTable{$file1}{nNgrams} < 1);
    print STDERR "Comparing against \"$file1\"...";
    for ($j = $i + 1; $j < @donefiles; $j++) {
	$file2 = $donefiles[$j];
	if ($fileTable{$file1}{nNgrams} <
	    $fileTable{$file2}{nNgrams}) {
	    $f1 = \%{$fileTable{$file1}};
	    $f2 = \%{$fileTable{$file2}};
	} else {
	    $f1 = \%{$fileTable{$file2}};
	    $f2 = \%{$fileTable{$file1}};
	}
	$sim = 0.0;
	while (($k, $v1) = each %{$f1->{ngtbl}}) {
	    if (exists $f2->{ngtbl}{$k}) {
		$sim += $v1 * $f2->{ngtbl}{$k};
	    }
	}
	$sim += $centroidsq - ($f1->{prod} + $f2->{prod});
	$sim /= $f1->{veclen} * $f2->{veclen};
	if ($file1 gt $file2) {
	    $tmp = $file1;
	    $file1 = $file2;
	    $file2 = $tmp;
	}
	$results{sprintf ("%-30s %-30s %7.4f", $file1, $file2, $sim)} = $sim;
    }
    print STDERR "done.\n";
}

#
# Sort and print results.
#
my @top = sort {$results{$b} <=> $results{$a}} keys %results;
$topnum = @top if ($topnum > @top);
print join ("\n", @top[0 .. $topnum-1]) . "\n";

#======================================================================
#
# tokenify -
#
# This subroutine turns a C or C++ program into a tokenized string.
# All variable references are renamed to the same thing so that renaming
# variables doesn't cause programs to be different.  Punctuation is left
# untouched, but all whitespace is removed.
#
#======================================================================
sub tokenify ($) {
    $_ = &{"prep" . $language}($_[0]);
# Convert all single letter tokens into two letter tokens.  This way, we're
# guaranteed that all single lower case letters are actually reserved words.
    s/\b\d[.0-9]*\b/00/gm;	# Numbers -> 00
    s/\b\w\b/XX/gm;		# Single letters -> two letters
    s/\b00\b/0/gm;		# 00 -> 0
    foreach $k (keys %keywords) {
	$v = $keywords{$k};
	s/(\W)$k(\W)/$1 $v $2/gm;
    }
    s/\b\w{2,}\b/a/gm;		# Collapse identifiers to a single letter
    s/\s+//gm;			# Eliminate white space
    return $_;
}

sub prepc ($)
{
    $_ = shift;
    tr/[\x1e\x1f]//d;		# Remove characters used to kill comments
    s/\\[ \t]*\n//gm;		# Merge continued lines
    s/^(\s)*\#[^\n]*$//gm;	# Get rid of all preprocessor directives
    s/\/\/[^\n]*\n//g;		# Get rid of C++ comments.
    s/\/\*/\x1e/gm;		# Mark the start of C comments
    s/\*\//\x1f/gm;		# Mark the end of C comments
    s/\x1e[^\x1f]*\x1f//gm;	# Kill all text between /* and */
    s/\\\"//g;			# Remove \" from strings
    s/\\\'//g;			# Remove \' from strings
    s/\"[^\"]*\"/\"/g;		# Collapse strings delimited by "
    s/\'[^\']*\'/\'/g;		# Collapse strings delimited by '
    return $_;
}

sub prepjava ($)
{
    $_ = shift;
    tr/[\x1e\x1f]//d;		# Remove characters used to kill comments
    s/\/\/[^\n]*\n//g;		# Get rid of C++-style comments.
    s/\/\*/\x1e/gm;		# Mark the start of C-style comments
    s/\*\//\x1f/gm;		# Mark the end of C-style comments
    s/\x1e[^\x1f]*\x1f//gm;	# Kill all text between /* and */
    s/\\\"//g;			# Remove \" from strings
    s/\\\'//g;			# Remove \' from strings
    s/\"[^\"]*\"/\"/g;		# Collapse strings delimited by "
    s/\'[^\']*\'/\'/g;		# Collapse strings delimited by '
    return $_;
}

sub prepesim ($)
{
    $_ = shift;
    s/\/\/[^\n]*\n//g;		# Get rid of comments
    s/\#h[0-9A-Fa-f]+/000/g;	# Canonicalize hex numbers
    s/\#b[01]+/000/g;		# Canonicalize binary numbers
    return $_;
}

sub preppascal ($)
{
    $_ = shift;
    tr/[\x1e\x1f]//d;		# Remove characters used to kill comments
    s/\(\*/\x1e/gm;		# Mark the start of (*
    s/\*\)/\x1f/gm;		# Mark the end of *)
    s/\x1e[^\x1f]*\x1f//gm;	# Kill all text between (* and *)
    s/\{[^\}]*\}//gm;		# Kill comments between { and }
    s/\\\"//g;			# Remove \" from strings
    s/\\\'//g;			# Remove \' from strings
    s/\"[^\"]*\"/\"/g;		# Collapse strings delimited by "
    s/\'[^\']*\'/\'/g;		# Collapse strings delimited by '
    return $_;
}

 
