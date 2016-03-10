set nocompatible

" 文件类型检测
filetype on "打开文件类型检测功能
filetype plugin on "根据文件类型加载相应的插件
filetype indent on "根据文件类型选择不同的缩进格式

" vue
au BufRead,BufNewFile *.vue set filetype=html

set vb t_vb=  " 关闭提示音

" 设置工具栏
if has("gui_running")
    set guioptions-=m "隐藏菜单栏
    set guioptions-=T "隐藏工具栏
    set guioptions-=L "隐藏左侧滚动条
    set guioptions-=r "隐藏右侧滚动条
    set showtabline=0 "隐藏Tab栏

	set lines=40 columns=150 " 窗口大小

    set transparency=3
	set guifont=Monaco:h12
endif

" 快捷键分窗口
map ws :split<cr>
map wv :vsplit<cr>
map wc :close<cr>
" 切换分割窗口
map wn <C-w>w

" 搜索设置
set incsearch
set hlsearch
set ignorecase "不分大小写

" 大小写敏感
set smartcase

" 语法高亮
syntax enable
syntax on

" 配色方案
set background=dark
colorscheme solarized

set number "显示行号
set cursorline " 高亮所在行
set ru

set wrap " 自动换行显示

set showmatch " 显示括号配对

" tab的宽度设置
set tabstop=4
set shiftwidth=4
set smarttab
set et " 编辑时替换tab为空格

" 设置编码
set encoding=utf-8
set fileencodings=utf-8

" 不产生备份文件
set nobackup
set nowritebackup

set autoread " 自动重新读入

set nofoldenable

" map <Left> <Nop>
" map <Right> <Nop>
" map <Up> <Nop>
" map <Down> <Nop>

if has("autocmd")
    filetype plugin indent on
    augroup vimrcEx
        au!
        autocmd FileType text setlocal textwidth=780
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
    augroup END

    " 自动补全符号
    function! AutoClose()
        :inoremap ( ()<ESC>i
        :inoremap " ""<ESC>i
        :inoremap ' ''<ESC>i
        :inoremap { {}<ESC>i
        :inoremap [ []<ESC>i
        :inoremap ) <c-r>=ClosePair(')')<CR>
        :inoremap } <c-r>=ClosePair('}')<CR>
        :inoremap ] <c-r>=ClosePair(']')<CR>
    endf

    function! ClosePair(char)
        if getline('.')[col('.') - 1] == a:char
            return "\<Right>"
        else
            return a:char
        endif
    endf

    "auto close for PHP and Javascript script
    au FileType php,c,python,javascript exe AutoClose()
endif

" HTML 标签补全
function! InsertHtmlTag()
let pat = '\c<\w\+\s*\(\s\+\w\+\s*=\s*[''#$;,()."a-z0-9]\+\)*\s*>'
  normal! a>
  let save_cursor = getpos('.')
  let result = matchstr(getline(save_cursor[1]), pat)
  "if (search(pat, 'b', save_cursor[1]) && searchpair('<','','>', 'bn',0,getline('.')) > 0)
  if (search(pat, 'b', save_cursor[1]))
    normal! lyiwf>
    normal! a</
    normal! p
    normal! a>
  endif
  :call cursor(save_cursor[1], save_cursor[2], save_cursor[3])
endfunction
inoremap > <ESC>:call InsertHtmlTag()<CR>a
