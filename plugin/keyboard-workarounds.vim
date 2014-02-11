"
" Keyboard workarounds
"
" Sometimes vim doesn't recognize some special keys, and instead of fixing
" my $TERM or terminfo or anything I just add a mapping to Make It Work
" Right Now Dammit I Have No Time For This

" xterm keys                                                    {{{2

"   keypad                                                      {{{3
map             <Esc>[5A        <C-Up>
map             <Esc>[5B        <C-Down>
map             <Esc>[5D        <C-Left>
map             <Esc>[5C        <C-Right>
map!            <Esc>[5A        <C-Up>
map!            <Esc>[5B        <C-Down>
map!            <Esc>[5D        <C-Left>
map!            <Esc>[5C        <C-Right>

map             <Esc>[2D        <S-Left>
map             <Esc>[2C        <S-Right>
map!            <Esc>[2D        <S-Left>
map!            <Esc>[2C        <S-Right>

""map             <Esc>O6A        <C-S-Up>
""map             <Esc>O6B        <C-S-Down>
""map             <Esc>O6D        <C-S-Left>
""map             <Esc>O6C        <C-S-Right>
""map!            <Esc>O6A        <C-S-Up>
""map!            <Esc>O6B        <C-S-Down>
""map!            <Esc>O6D        <C-S-Left>
""map!            <Esc>O6C        <C-S-Right>

map             <Esc>[5H        <C-Home>
map             <Esc>[5F        <C-End>
map             <Esc>[5;5~      <C-PageUp>
map             <Esc>[6;5~      <C-PageDown>
map!            <Esc>[5H        <C-Home>
map!            <Esc>[5F        <C-End>
map!            <Esc>[5;5~      <C-PageUp>
map!            <Esc>[6;5~      <C-PageDown>

"   keypad in screen                                            {{{3
""map             <Esc>O5A        <C-Up>
""map             <Esc>O5B        <C-Down>
""map             <Esc>O5D        <C-Left>
""map             <Esc>O5C        <C-Right>
""map!            <Esc>O5A        <C-Up>
""map!            <Esc>O5B        <C-Down>
""map!            <Esc>O5D        <C-Left>
""map!            <Esc>O5C        <C-Right>
""
""map             <Esc>O2D        <S-Left>
""map             <Esc>O2C        <S-Right>
""map!            <Esc>O2D        <S-Left>
""map!            <Esc>O2C        <S-Right>
""
""map             <Esc>O5H        <C-Home>
""map             <Esc>O5F        <C-End>
""map!            <Esc>O5H        <C-Home>
""map!            <Esc>O5F        <C-End>

"   function keys                                               {{{3
""map             <Esc>O5P        <C-F1>
""map             <Esc>O5Q        <C-F2>
""map             <Esc>O5R        <C-F3>
""map             <Esc>O5S        <C-F4>
map             <Esc>[15;5~     <C-F5>
map             <Esc>[17;5~     <C-F6>
map             <Esc>[18;5~     <C-F7>
map             <Esc>[19;5~     <C-F8>
map             <Esc>[20;5~     <C-F9>
map             <Esc>[21;5~     <C-F10>
map             <Esc>[23;5~     <C-F11>
map             <Esc>[24;5~     <C-F12>
""map!            <Esc>O5P        <C-F1>
""map!            <Esc>O5Q        <C-F2>
""map!            <Esc>O5R        <C-F3>
""map!            <Esc>O5S        <C-F4>
map!            <Esc>[15;5~     <C-F5>
map!            <Esc>[17;5~     <C-F6>
map!            <Esc>[18;5~     <C-F7>
map!            <Esc>[19;5~     <C-F8>
map!            <Esc>[20;5~     <C-F9>
map!            <Esc>[21;5~     <C-F10>
map!            <Esc>[23;5~     <C-F11>
map!            <Esc>[24;5~     <C-F12>
" rxvt keys                                                     {{{2

"   keypad                                                      {{{3
map             <Esc>[a         <S-Up>
map             <Esc>[b         <S-Down>
map             <Esc>[d         <S-Left>
map             <Esc>[c         <S-Right>
map!            <Esc>[a         <S-Up>
map!            <Esc>[b         <S-Down>
map!            <Esc>[d         <S-Left>
map!            <Esc>[c         <S-Right>

map             <Esc>[2$        <S-Insert>
map             <Esc>[3$        <S-Del>
map!            <Esc>[2$        <S-Insert>
map!            <Esc>[3$        <S-Del>
" Other shifted keypad keys are used for scrollback and pasting

""map             <Esc>Oa         <C-Up>
""map             <Esc>Ob         <C-Down>
""map             <Esc>Od         <C-Left>
""map             <Esc>Oc         <C-Right>
""map!            <Esc>Oa         <C-Up>
""map!            <Esc>Ob         <C-Down>
""map!            <Esc>Od         <C-Left>
""map!            <Esc>Oc         <C-Right>

map             <Esc>[2^        <C-Insert>
map             <Esc>[3^        <C-Del>
map!            <Esc>[2^        <C-Insert>
map!            <Esc>[3^        <C-Del>
map             <Esc>[3;5~      <C-Del>
map!            <Esc>[3;5~      <C-Del>

map             <Esc>[5^        <C-PageUp>
map             <Esc>[6^        <C-Pagedown>
map             <Esc>[7^        <C-Home>
map             <Esc>[8^        <C-End>
map!            <Esc>[5^        <C-PageUp>
map!            <Esc>[6^        <C-Pagedown>
map!            <Esc>[7^        <C-Home>
map!            <Esc>[8^        <C-End>

"   numeric keypad                                              {{{3
""map             <Esc>Ox         <S-Up>
""map             <Esc>Or         <S-Down>
""map             <Esc>Ot         <S-Left>
""map             <Esc>Ov         <S-Right>
""map!            <Esc>Ox         <S-Up>
""map!            <Esc>Or         <S-Down>
""map!            <Esc>Ot         <S-Left>
""map!            <Esc>Ov         <S-Right>

""map             <Esc>Op         <S-Insert>
""map             <Esc>On         <S-Del>
""map!            <Esc>Op         <S-Insert>
""map!            <Esc>On         <S-Del>

""map             <Esc>Ow         <S-kHome>
""map             <Esc>Oq         <S-kEnd>
""map             <Esc>Oy         <S-kPageUp>
""map             <Esc>Os         <S-kPageDown>
""map!            <Esc>Ow         <S-kHome>
""map!            <Esc>Oq         <S-kEnd>
""map!            <Esc>Oy         <S-kPageUp>
""map!            <Esc>Os         <S-kPageDown>

" Ignore KP_CENTER
""map             <Esc>Ou         <Nop>
""map!            <Esc>Ou         <Nop>

"   function keys                                               {{{3
map             <Esc>[25~       <S-F3>
map             <Esc>[26~       <S-F4>
map             <Esc>[28~       <S-F5>
map             <Esc>[29~       <S-F6>
map             <Esc>[31~       <S-F7>
map             <Esc>[32~       <S-F8>
map             <Esc>[33~       <S-F9>
map             <Esc>[34~       <S-F10>
map             <Esc>[23$       <S-F11>
map             <Esc>[24$       <S-F12>
map!            <Esc>[25~       <S-F3>
map!            <Esc>[26~       <S-F4>
map!            <Esc>[28~       <S-F5>
map!            <Esc>[29~       <S-F6>
map!            <Esc>[31~       <S-F7>
map!            <Esc>[32~       <S-F8>
map!            <Esc>[33~       <S-F9>
map!            <Esc>[34~       <S-F10>
map!            <Esc>[23$       <S-F11>
map!            <Esc>[24$       <S-F12>

map             <Esc>[11^       <C-F1>
map             <Esc>[12^       <C-F2>
map             <Esc>[13^       <C-F3>
map             <Esc>[14^       <C-F4>
map             <Esc>[15^       <C-F5>
map             <Esc>[17^       <C-F6>
map             <Esc>[18^       <C-F7>
map             <Esc>[19^       <C-F8>
map             <Esc>[20^       <C-F9>
map             <Esc>[21^       <C-F10>
map             <Esc>[23^       <C-F11>
map             <Esc>[24^       <C-F12>
map!            <Esc>[11^       <C-F1>
map!            <Esc>[12^       <C-F2>
map!            <Esc>[13^       <C-F3>
map!            <Esc>[14^       <C-F4>
map!            <Esc>[15^       <C-F5>
map!            <Esc>[17^       <C-F6>
map!            <Esc>[18^       <C-F7>
map!            <Esc>[19^       <C-F8>
map!            <Esc>[20^       <C-F9>
map!            <Esc>[21^       <C-F10>
map!            <Esc>[23^       <C-F11>
map!            <Esc>[24^       <C-F12>

" gnome-terminal keys in Feisty                                 {{{2
""map             <Esc>O1;5A      <C-Up>
""map             <Esc>O1;5B      <C-Down>
""map             <Esc>O1;5D      <C-Left>
""map             <Esc>O1;5C      <C-Right>
""map!            <Esc>O1;5A      <C-Up>
""map!            <Esc>O1;5B      <C-Down>
""map!            <Esc>O1;5D      <C-Left>
""map!            <Esc>O1;5C      <C-Right>
""map             <Esc>O1;6A      <C-S-Up>
""map             <Esc>O1;6B      <C-S-Down>
""map             <Esc>O1;6D      <C-S-Left>
""map             <Esc>O1;6C      <C-S-Right>
""map!            <Esc>O1;6A      <C-S-Up>
""map!            <Esc>O1;6B      <C-S-Down>
""map!            <Esc>O1;6D      <C-S-Left>
""map!            <Esc>O1;6C      <C-S-Right>

" gnome-terminal keys in Gutsy through Quantal                  {{{2
map             <Esc>O1;2P      <S-F1>
map             <Esc>O1;2Q      <S-F2>
map             <Esc>O1;2R      <S-F3>
map             <Esc>O1;2S      <S-F4>
map             <Esc>[15;2~     <S-F5>
map             <Esc>[17;2~     <S-F6>
map             <Esc>[18;2~     <S-F7>
map             <Esc>[19;2~     <S-F8>
map             <Esc>[20;2~     <S-F9>
" <S-F10> is not available
map             <Esc>[23;2~     <S-F11>
map             <Esc>[24;2~     <S-F12>
map!            <Esc>O1;2P      <S-F1>
map!            <Esc>O1;2Q      <S-F2>
map!            <Esc>O1;2R      <S-F3>
map!            <Esc>O1;2S      <S-F4>
map!            <Esc>[15;2~     <S-F5>
map!            <Esc>[17;2~     <S-F6>
map!            <Esc>[18;2~     <S-F7>
map!            <Esc>[19;2~     <S-F8>
map!            <Esc>[20;2~     <S-F9>
" <S-F10> is not available
map!            <Esc>[23;2~     <S-F11>
map!            <Esc>[24;2~     <S-F12>

" <C-F1> is not available
""map             <Esc>O1;5Q      <C-F2>
""map             <Esc>O1;5R      <C-F3>
""map             <Esc>O1;5S      <C-F4>
map             <Esc>[15;5~     <C-F5>
map             <Esc>[17;5~     <C-F6>
map             <Esc>[18;5~     <C-F7>
map             <Esc>[19;5~     <C-F8>
map             <Esc>[20;5~     <C-F9>
map             <Esc>[21;5~     <C-F10>
map             <Esc>[23;5~     <C-F11>
map             <Esc>[24;5~     <C-F12>
" <C-F1> is not available
""map!            <Esc>O1;5Q      <C-F2>
""map!            <Esc>O1;5R      <C-F3>
""map!            <Esc>O1;5S      <C-F4>
map!            <Esc>[15;5~     <C-F5>
map!            <Esc>[17;5~     <C-F6>
map!            <Esc>[18;5~     <C-F7>
map!            <Esc>[19;5~     <C-F8>
map!            <Esc>[20;5~     <C-F9>
map!            <Esc>[21;5~     <C-F10>
map!            <Esc>[23;5~     <C-F11>
map!            <Esc>[24;5~     <C-F12>

" gnome-terminal keys in Hardy when ssh'ed into Dapper          {{{2
" also, gnome-terminal keys in Intrepid                         {{{2
map             <Esc>[1;5A      <C-Up>
map             <Esc>[1;5B      <C-Down>
map             <Esc>[1;5D      <C-Left>
map             <Esc>[1;5C      <C-Right>
map!            <Esc>[1;5A      <C-Up>
map!            <Esc>[1;5B      <C-Down>
map!            <Esc>[1;5D      <C-Left>
map!            <Esc>[1;5C      <C-Right>
map             <Esc>[1;6A      <C-S-Up>
map             <Esc>[1;6B      <C-S-Down>
map             <Esc>[1;6D      <C-S-Left>
map             <Esc>[1;6C      <C-S-Right>
map!            <Esc>[1;6A      <C-S-Up>
map!            <Esc>[1;6B      <C-S-Down>
map!            <Esc>[1;6D      <C-S-Left>
map!            <Esc>[1;6C      <C-S-Right>


