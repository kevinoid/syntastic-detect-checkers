if exists('g:loaded_syntastic_detect_javascript_autoload')
    finish
endif
let g:loaded_syntastic_detect_javascript_autoload = 1

let s:save_cpoptions = &cpoptions
set cpoptions&vim

" Gets a list of names of checkers which are likely to apply to the javascript
" file in the current buffer, based on its contents and path.
function! syntastic#detect#javascript#detectAll() abort " {{{
    let javascript_checkers = []

    let save_suffixesadd = &suffixesadd
    let &suffixesadd = ''

    " Load nearest package.json, which is relevant to several checkers
    let package_json = findfile('package.json', '.;')
    if package_json !=# ''
        let package_json = join(readfile(package_json))
    endif

    if stridx(package_json, '"google-closure-compiler":') != -1
        call add(javascript_checkers, 'closurecompiler')
    endif

    if stridx(package_json, '"eslint":') != -1
        \ || stridx(package_json, '"eslintConfig":') != -1
        \ || search('\m/[*/]\s*eslint-', 'cnw')
        call add(javascript_checkers, 'eslint')
    else
        let &suffixesadd = '.js,.yaml,.yml,.json'
        if findfile('.eslintrc', '.;') !=# ''
            call add(javascript_checkers, 'eslint')
        endif
        let &suffixesadd = ''
    endif

    if stridx(package_json, '"flow-bin":') != -1
        \ || stridx(package_json, '"babel-preset-flow":') != -1
        call add(javascript_checkers, 'flow')
    endif

    if package_json =~# '\<gjslint\>'
        call add(javascript_checkers, 'gjslint')
    endif

    if stridx(package_json, '"jscsConfig":') != -1
        \ || findfile('.jscsrc', '.;') !=# ''
        \ || findfile('.jscs.json', '.;') !=# ''
        \ || findfile('.jscs.yaml', '.;') !=# ''
        let b:syntastic_checkers = ['jscs']
    endif

    if stridx(package_json, '"jshintConfig":') != -1
        \ || search('\m/\*\s*jshint\>', 'cnw')
        \ || findfile('.jshintrc', '.;') !=# ''
        if @% =~# '\m\.jsx$'
            call add(javascript_checkers, 'jsxhint')
        else
            call add(javascript_checkers, 'jshint')
        endif
    endif

    if search('\m/\*\s*jslint\>', 'cnw')
        \ || findfile('.jslintrc', '.;') !=# ''
        \ || findfile('.jslint.conf', '.;') !=# ''
        \ || findfile('jslintrc', '.;') !=# ''
        \ || findfile('jslint.conf', '.;') !=# ''
        call add(javascript_checkers, 'jslint')
    endif

    if search('\m/\*jsl:', 'cnw')
        call add(javascript_checkers, 'jsl')
    endif

    if stridx(package_json, '"lynt":') != -1
        \ || findfile('.lyntrc', '.;') !=# ''
        call add(javascript_checkers, 'lynt')
    endif

    if stridx(package_json, '"mixedindentlint":') != -1
        call add(javascript_checkers, 'mixedindentlint')
    endif

    if stridx(package_json, '"standard":') != -1
        call add(javascript_checkers, 'standard')
    endif

    if stridx(package_json, '"term-lint":') != -1
        \ || findfile('.tern-project', '.;') !=# ''
        call add(javascript_checkers, 'tern_lint')
    endif

    let &suffixesadd = save_suffixesadd

    call syntastic#log#debug(
        \ g:_SYNTASTIC_DEBUG_CHECKERS,
        \ 'syntastic#detect#javascript#detectAll: Detected checkers: '
        \ . join(javascript_checkers))

    return javascript_checkers
endfunction " }}}

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
