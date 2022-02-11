" Various emoji displayed by GNOME Terminal on Ubuntu 21.10
" sometimes have widths that don't match what Vim thinks their width
" should be.
"
" See :h setcellwidths() for the script used to test

call setcellwidths([
      \ [0x2328, 0x2328, 2],
      \ [0x23CF, 0x23CF, 2],
      \ [0x260E, 0x260E, 2],
      \ [0x2639, 0x263A, 2],
      \ [0x26F4, 0x26F4, 2],
      \ ])
