
@alphabet = ('A' .. 'Z'); # to get all the letters of the (English) alphabet, or:
@combos = ('aa' .. 'zz'); # to get all combinations of two lowercase letters.
                          # However, be careful of something like:
@bigcombos = ('aaaaaa' .. 'zzzzzz'); # since that will require lots of memory.
                                     # More precisely, it'll need space to store 308,915,776 scalars.

# vim:ft=perl:

