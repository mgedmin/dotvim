" Options for editing plain-text and HTML e-books

setlocal wrap nolist lbr display=lastline tw=9999 nojoinspaces nosmartindent
setlocal et spell

map <buffer> <Up> gk
map <buffer> <Down> gj
imap <buffer> <Up> <C-O>gk
imap <buffer> <Down> <C-O>gj

" spelling errors
map <buffer> ,n ]s
map <buffer> ,p [s


" :FixStrings
"
" Replaces
"
"    "This is some direct speech", he said.
"
" with
"
"    “This is some direct speech”, he said.
"
" Starts from the current cursor position.
"
" It's likely to require manual fixups afterwards.
function! FixStrings()
  ,$s/"\(\_[^"]*\)"/“\1”/gce
endf

command! FixStrings :call FixStrings()

" :FixQuotes
"
" Normalizes all sorts of apostrophes to '’' (RIGHT SINGLE QUOTATION MARK)
"
" Use with care.
"
" Starts from the current cursor position.
function! FixQuotes()
  ,$s/[`'‘]/’/gce
endf
command! FixQuotes :call FixQuotes()

" :FindMDashes
"
" Finds the next "—" (EM DASH) character in the text
function! FindMDashes()
  normal /\%u2014<CR>
endf
command! FindMDashes :call FindMDashes()

" :FixSpans
"
" Replaces
"
"   <span class="italic">text</span>
"   <span class="bold">text</span>
"
" with
"
"   <i>text</i>
"   <b>text</b>
function! FixSpans()
  %s,<span class="italic">\([^<]*\)</span>,<i>\1</i>,gce
  %s,<span class="bold">\([^<]*\)</span>,<b>\1</b>,gce
endf
command! FixSpans :call FixSpans()

" :FixItalics
"
" replaces
"
"    text text<i>italic</i> .  More text
"
" with
"
"    text text <i>italic</i>.  More text
"
function! FixItalics()
" bug: foo."<i>Bar is not handled
" bug: foo!"<i>Bar is not handled
  %s,\w\zs\ze<i>\w, ,gce
  %s,\w</i>\zs\ze\w, ,gce
  %s,</\=i>\zs\_s\ze[.\,;!?)],,gce
  %s,\zs\_s\ze</\=i>[.\,;!?)],,gce
  %s,[.\,:;!?]\zs\ze<i>\([^"\-]\|"[^ ]\), ,gce
  %s,[.\,:;!?]"\=</i>\zs\ze\([^ "\-<&?!]\|"[^ <]\), ,gce
  %s,<i></i>\|</i><i>, ,gce
  %s,\(</i>\_s'\|'</i>\_s\)s\>,</i>'s,gce
  %s,\_s<i>'s\>,<i>'s,gce
  %s,\.\_s</i>\_s"\ze</p>,.</i>",gce
  %s,</i>\zs\_s\ze"</p>,,gce
endf
command! FixItalics :call FixItalics()

" :FixBold
"
" replaces
"
"    text text<b>bold</b> .  More text
"
" with
"
"    text text <b>bold</b>.  More text
"
function! FixBold()
  %s,\w\zs\ze<b>\w, ,gce
  %s,\w</b>\zs\ze\w, ,gce
  %s,</\=b>\zs\_s\ze[.\,;!?)],,gce
  %s,\zs\_s\ze</\=b>[.\,;!?)],,gce
  %s,[.\,:;!?]\zs\ze<b>\([^"\-]\|"[^ ]\), ,gce
  %s,[.\,:;!?]"\=</b>\zs\ze\([^ "\-<&?!]\|"[^ ]\), ,gce
  %s,<b></b>\|</b><b>, ,gce
  %s,\(</b>\_s'\|'</b>\_s\)s\>,</b>'s,gce
  %s,\_s<b>'s\>,<b>'s,gce
  %s,\.\_s</b>\_s"\ze</p>,.</b>",gce
endf
command! FixBold :call FixBold()

" :FixParagraphs
"
" replaces
"
"   <p> Foo bar baz </p>
"   <p> quux welp. </p>
"
" with
"
"   <p> Foo bar baz
"   quux welp. </p>
"
" by looking for missing punctuation in front of </p>
function! FixParagraphs()
  %s,[A-Za-z,0-9]"\= *\zs</p>\n<p> *\ze\w,\r,gce
endf
command! FixParagraphs :call FixParagraphs()

" :FixDashes
"
" replaces
"    foo--bar
" with
"    foo&mdash;bar
"
function! FixDashes()
  %s,\W\zs--*\|--*\ze[^-A-Za-z0-9],\&mdash;,gce
endf
command! FixDashes :call FixDashes()


" :FixHeadings
"
" replaces
"    <p> Chapter Twenty-One </p>
" with
"    <h3>Chapter Twenty-One</h3>
"
function! FixHeadings()
  %s,<p> *\(Chapter .*\S\|Prologue\|Epilogue\|Foreword\|Afterword\) *</p>,<h3>\1</h3>,gce
endf
command! FixHeadings :call FixHeadings()
