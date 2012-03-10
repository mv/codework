#!/usr/local/bin/perl -w
#
######################################################################
#
# Example of how to use the Spreadsheet::WriteExcel module to create
# an Excel binary file.
#

use strict;
use Spreadsheet::WriteExcel;
use XML;

# Create a new Excel workbook called perl.xls
my $workbook = Spreadsheet::WriteExcel->new("mv_tab_scott.xls");

# Add some worksheets
my $sheet1 = $workbook->add_worksheet("Dept");
my $blue   = $workbook->set_custom_color(12, 0, 0, 128);

# Add a format
my %font = (
        font       => 'Courier New',
        size       => '10',
    );

my %cell_num = (
        %font,
        align      => 'right',
        num_format => '#,##0.00',
    );

my $fmt_num =
    $workbook->add_format(
        %cell_num,
    );

my $fmt_num_total =
    $workbook->add_format(
        %cell_num,
        italic     => 1,
        bold       => 1,
    );

my $fmt_header    =
    $workbook->add_format(
        %font,
        align  => 'center',
        italic => 1,
        bold   => 1,
        color  => 'white',
        bg_color => $blue,
    );

my $fmt_text  =
    $workbook->add_format(
        %font,
        align  => 'left',
    );

# Set the width of the first column in sheet1
# $sheet1->set_column(0, 0, 30);

# Set sheet1 as the active worksheet
$sheet1->activate();

# Data
my @header = qw(Number DepartmentName Location Salary);
my $aref = [
        ['10','ACCOUNTING  ','NEW YORK',  8750],
        ['20','RESEARCH    ','DALLAS  ', 10875],
        ['30','SALES       ','CHICAGO ',  9400],
        ['40','OPERATIONS  ','BOSTON  ',     0],
    ];


# The general syntax is write($row, $col, $token, $fmt_num)

# Write some formatted text
$sheet1->write(0, 0, "Scott.dept", $fmt_text);

# header
wline( 3, 1, \@header, $fmt_header );

# lines
my $row=1;
for my $lineref ( @{$aref} ) {
    wline( 3+$row, 1, $lineref, $fmt_text );
    $row++;
};

# formatting SAL
for my $row( 4..7 ) {
    $sheet1->write( $row, 4, undef, $fmt_num );
};

exit 0;

sub wline {
    my $lin  = shift;
    my $col  = shift;
    my $ref  = shift;
    my $fmt  = shift;
    my $pos = 0;

    for my $value ( @{$ref} ) {
        $sheet1->write( $lin, $col+$pos, $value, $fmt );
        $pos++;
    }
};
