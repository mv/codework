#!/usr/local/bin/perl -w
#
######################################################################
#
# Example of how to use the Spreadsheet::WriteExcel module to create
# an Excel binary file.
#

use strict;
use Spreadsheet::WriteExcel;

# Create a new Excel workbook called perl.xls
my $workbook = Spreadsheet::WriteExcel->new("mv_tab.xls");

# Add some worksheets
my $sheet1 = $workbook->add_worksheet("Tab1");

# Add a format
my $fmt_num =
    $workbook->add_format(
        font   => 'Courier New',
        size   => '10',
        align  => 'right',
    );

my $fmt_num_total =
    $workbook->add_format(
        font   => 'Courier New',
        size   => '10',
        align  => 'right',
        italic => 1,
        bold   => 1,
    );

my $fmt_header    =
    $workbook->add_format(
        font   => 'Courier New',
        size   => '10',
        align  => 'center',
        italic => 1,
        bold   => 1,
        color  => 'white',
        bg_color => 'blue',
    );

my $fmt_text  =
    $workbook->add_format(
        font   => 'Courier New',
        size   => '10',
        align  => 'left',
    );

# Set the width of the first column in sheet1
$sheet1->set_column(0, 0, 30);

# Set sheet1 as the active worksheet
$sheet1->activate();

# The general syntax is write($row, $col, $token, $fmt_num)

# Write some fmt_numted text
$sheet1->write(0, 0, "Hello Excel!", $fmt_num);

# Write some unfmt_numted text
$sheet1->write(2, 0, "One");
$sheet1->write(3, 0, "Two");

# Write some unfmt_numted numbers
$sheet1->write(4, 0, 3);
$sheet1->write(5, 0, 4.00001);

# Write a number fmt_numted as a date
my $date = $workbook->add_format();
$date->set_num_format('mmmm d yyyy h:mm AM/PM');
$sheet1->write(7, 0, 36050.1875, $date);

