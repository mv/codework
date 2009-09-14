
use Test::More tests => 1;

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

is_deeply( $list1, $list2, 'existential equivalence' );
