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
my $workbook = Spreadsheet::WriteExcel->new("perl.xls");

# Add some worksheets
my $sheet1 = $workbook->add_worksheet();
my $sheet2 = $workbook->add_worksheet();
my $sheet3 = $workbook->add_worksheet("Example");

# Add a Format
my $format = $workbook->add_format();
$format->set_bold();
$format->set_size(15);
$format->set_color('blue');
$format->set_align('center');

# Set the width of the first column in Sheet3
$sheet3->set_column(0, 0, 30);

# Set Sheet3 as the active worksheet
$sheet3->activate();

# The general syntax is write($row, $col, $token, $format)

# Write some formatted text
$sheet3->write(0, 0, "Hello Excel!", $format);

# Write some unformatted text
$sheet3->write(2, 0, "One");
$sheet3->write(3, 0, "Two");

# Write some unformatted numbers
$sheet3->write(4, 0, 3);
$sheet3->write(5, 0, 4.00001);

# Write a number formatted as a date
my $date = $workbook->add_format();
$date->set_num_format('mmmm d yyyy h:mm AM/PM');
$sheet3->write(7, 0, 36050.1875, $date);

