" Author: Benjamin Bannier <bbannier@gmail.com>
" Description: Support for checking Zeek files.
"
call ale#Set('zeek_zeek_executable', 'zeek')

function! ale_linters#zeek#zeek#HandleErrors(buffer, lines) abort
    let l:pattern = '\(error\|warning\) in \v.*, line (\d+): (.*)$'

    return map(ale#util#GetMatches(a:lines, l:pattern), "{
    \   'lnum': str2nr(v:val[2]),
    \   'text': v:val[3],
    \   'type': (v:val[1] is# 'error') ? 'E': 'W',
    \}")
endfunction

call ale#linter#Define('zeek', {
\   'name': 'zeek',
\   'executable': {b -> ale#Var(b, 'zeek_zeek_executable')},
\   'output_stream': 'stderr',
\   'command': {-> '%e --parse-only %s'},
\   'callback': 'ale_linters#zeek#zeek#HandleErrors',
\   'lint_file': 1,
\})
