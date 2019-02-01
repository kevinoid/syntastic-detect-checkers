if exists('g:loaded_syntastic_detect_typescript_autoload')
    finish
endif

let g:loaded_syntastic_detect_typescript_autoload = 1

let s:save_cpoptions = &cpoptions
set cpoptions&vim

" Gets a list of names of checkers which are likely to apply to the typescript
" file in the current buffer, based on its contents and path.
function! syntastic#detect#typescript#detectAll() abort " {{{
    let typescript_checkers = []

    let save_suffixesadd = &suffixesadd
    let &suffixesadd = ''

    " Load nearest package.json, which is relevant to several checkers
    let package_json = findfile('package.json', '.;')

    if package_json isnot# ''
        let package_json = join(readfile(package_json))
    endif

    if stridx(package_json, '"typescript-eslint-parser":') != -1
        \ || stridx(package_json, '"@typescript-eslint/parser":') != -1
        \ || search('\m/[*/]\s*eslint-', 'cnw')
        call add(typescript_checkers, 'eslint')
    else
        let &suffixesadd = '.js,.yaml,.yml,.json'
        let eslintrc = findfile('.eslintrc', '.;')

        if eslintrc isnot# ''
            for line in readfile(eslintrc)
                if stridx(line, '"typescript"') != -1
                    call add(typescript_checkers, 'eslint')
                    break
                endif
            endfor
        endif

        let &suffixesadd = ''
    endif

    if stridx(package_json, '"lynt":') != -1
        \ || findfile('.lyntrc', '.;') isnot# ''
        call add(typescript_checkers, 'lynt')
    endif

    if stridx(package_json, '"tslintConfig":') != -1
        \ || stridx(package_json, '"tslint":') != -1
        \ || findfile('tslint.json', '.;') isnot# ''
        \ || findfile('tslint.yaml', '.;') isnot# ''
        call add(typescript_checkers, 'tslint')
    endif

    " tsuquyomi is always applicable when present
    call add(typescript_checkers, 'tsuquyomi')

    let &suffixesadd = save_suffixesadd

    call syntastic#log#debug(
        \ g:_SYNTASTIC_DEBUG_CHECKERS,
        \ 'syntastic#detect#typescript#detectAll: Detected checkers: '
        \ . join(typescript_checkers))

    return typescript_checkers
endfunction " }}}

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
