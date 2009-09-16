/*
** http://www.basicallytech.com/blog/index.php?/archives/23-command-line-calculations-using-bc.html
**
*/


# addition
echo '57+43' | bc

# subtraction
echo '57-43' | bc

# multiplication
echo '57*43' | bc

# scale
# The scale variable determines deciman PRECISION
echo 'scale=25;57/43' | bc

1.3255813953488372093023255

# square root
echo 'scale=30;sqrt(2)' | bc

# You can use shell variables with bc, which is very useful in shell scripts:
FIVE=5 ; echo "$FIVE^2" | bc
25

# parentheses
echo '6^6^6' | bc
echo '(6^6)^6' | bc

# Conversion
# obase and ibase are special variables which define output and input base.

### Here we're converting 255 from base 10 to base 16:
echo 'obase=16;255' | bc
FF

### convert from decimal to binary
### And here we're converting the number 12 from base 10 to base 2:
echo 'obase=2;12' | bc
1100

### Here we're converting the binary number 10 to a base 10 (decimal) number.
### Note that the obase is "A" and not "10".
echo 'ibase=2;obase=A;10' | bc
2

echo 'ibase=2;obase=A;10000001' | bc
129

### convert from hexadecimal to decimal
echo 'ibase=16;obase=A;FF' | bc
255

Again, note the use of "A" to denote base 10. That is because "10" in hex (base 16 - the ibase value) is 16.
a brief introduction to interactive mode

You can also run bc in interactive mode:

$ bc

