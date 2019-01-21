Detect Syntastic Checkers
=========================

A [Vim](https://www.vim.org/) plugin which extends
[Syntastic](https://github.com/vim-syntastic/syntastic) to use checkers
which apply to the file being edited based on the presence of project settings
and inline options.


## Installation

After installing Syntastic, this plugin can be installed in the usual ways:

### Using [Vim Packages](https://vimhelp.org/repeat.txt.html#packages)

```sh
git checkout https://github.com/kevinoid/syntastic-detect-checkers.git ~/.vim/pack/whatever/start/syntastic-detect-checkers
```

### Using [Pathogen](https://github.com/tpope/vim-pathogen)

```sh
git checkout https://github.com/kevinoid/syntastic-detect-checkers.git ~/.vim/bundles/syntastic-detect-checkers
```

### Using [Vundle](https://github.com/VundleVim/Vundle.vim)

Add the following to `.vimrc`:
```vim
Plugin 'kevinoid/syntastic-detect-checkers'
```
Then run `:PluginInstall`.

### Using [vim-plug](https://github.com/junegunn/vim-plug)

Add the following to `.vimrc` between `plug#begin()` and `plug#end()`:
```vim
Plug 'kevinoid/syntastic-detect-checkers'
```


## Implementation

This plugin is currently implemented by checking for the presence of checker
configuration, both by the presence of configuration files (e.g. `.eslintrc`)
and inline directives in the file being edited (e.g. `/* eslint-disable */`).
The rules are hard coded in per-language
[autoload-functions](https://vimhelp.org/eval.txt.html#autoload-functions).

To debug the plugin, set
[`g:syntastic_debug`](https://github.com/vim-syntastic/syntastic/blob/0d25f4fb/doc/syntastic.txt)
= 33 in `.vimrc` and look for lines starting with `syntastic#detect#` in
[`:messages`](https://vimhelp.org/message.txt.html#%3Amessages).

To customize the behavior of this plugin, users can `set
g:syntastic_detect_checkers = 0` to disable `autocmd` registration, then `let
b:syntastic_checkers = syntastic#detect#<language>#detectAll()` with any
desired modifications.


## Collaboration

I would appreciate constructive feedback and suggestions.  I am also willing to
collaborate with any Syntastic developers who might be interested in
incorporating this functionality into Syntastic so that it doesn't require a
separate plugin.


## See Also

If you have read this far, you may also be interested in these other plugins:

- [syntastic-use-node-bin](https://github.com/kevinoid/syntastic-use-node-bin)
  \- Use checker executables installed in per-project `node_modules/.bin`
  directories.
