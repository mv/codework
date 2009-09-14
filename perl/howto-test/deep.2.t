
use Test::More tests => 1;
use Test::Differences;

my $list1 = [
  [
      [ 48, 12 ],
      [ 32, 10 ],
  ],
  [
      [ 03, 28 ],
  ],
];

my $list2 = [
  [
      [ 48, 12 ],
      [ 32, 11 ],
  ],
  [
      [ 03, 28 ],
  ],
];

eq_or_diff( $list1, $list2, 'a tale of two references' );
