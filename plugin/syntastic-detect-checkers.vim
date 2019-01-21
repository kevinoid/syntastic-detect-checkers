" Checker detection for Syntastic
" Maintainer:	Kevin Locke <kevin@kevinlocke.name>
" Repository:	https://github.com/kevinoid/syntastic-detect-checkers
" License:	Vim License  (see vim's :help license)
" Last Change:	19 January 2019

if exists('g:loaded_syntastic_detect_checkers')
    finish
endif
let g:loaded_syntastic_detect_checkers = 1

let s:save_cpoptions = &cpoptions
set cpoptions&vim

if get(g:, 'syntastic_detect_checkers', 1)
    augroup syntasticDetectCheckers
        autocmd!

        autocmd FileType javascript let b:syntastic_checkers =
            \ syntastic#detect#javascript#detectAll()
        autocmd FileType typescript let b:syntastic_checkers =
            \ syntastic#detect#typescript#detectAll()
    augroup END
endif

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
