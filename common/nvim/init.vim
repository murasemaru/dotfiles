" ===== 基本設定 =====

" クリップボード設定（重要！）
set clipboard=unnamedplus

" 行番号を表示
set number

" 相対行番号
set relativenumber

" タブ設定
set tabstop=2
set shiftwidth=2
set expandtab

" 検索設定
set ignorecase      " 検索時に大文字小文字を区別しない
set smartcase       " 大文字が含まれていたら区別する
set hlsearch        " 検索結果をハイライト
set incsearch       " インクリメンタルサーチ

" カーソル行をハイライト
set cursorline

" マウスを有効化
set mouse=a

" エンコーディング
set encoding=utf-8

" IME制御設定
set iminsert=0
set imsearch=-1

" macOSでIMEをオフにする関数
function! ImInActivate()
  call system('osascript -e "tell application \"System Events\" to key code 102"')
endfunction

" Insertモードを抜けた時にIMEを自動的にオフにする
augroup ImSwitcher
  autocmd!
  autocmd InsertLeave * call ImInActivate()
augroup END

" ===== キーマッピング =====

" Leaderキーをスペースに
let mapleader = " "

" Escの代わりにjj
inoremap jj <Esc>

" Ctrl+cでInsertモードを抜ける時もIMEをオフ
inoremap <C-c> <Esc>:call ImInActivate()<CR>

" インサートモードでEmacs風カーソル移動
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-a> <C-o>0
inoremap <C-e> <C-o>$
inoremap <C-d> <Del>

" 保存
nnoremap <Leader>w :w<CR>

" 終了
nnoremap <Leader>q :q<CR>

" 保存して終了
nnoremap <Leader>wq :wq<CR>

" ===== 見た目 =====

" シンタックスハイライト
syntax on

" カラースキーム
colorscheme default
