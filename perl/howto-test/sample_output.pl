#!perl



print <<END_HERE;

1..9

ok 1

not ok 2
#     Failed test (t/sample_output.t at line 10)
#          got: '2'
#     expected: '4'

ok 3

ok 4 - this is test 4

not ok 5 - test 5 should look good too

not ok 6 # TODO fix test 6
# I haven't had time add the feature for test 6

ok 7 # skip these tests never pass in examples

ok 8 # skip these tests never pass in examples

ok 9 # skip these tests never pass in examples

END_HERE
