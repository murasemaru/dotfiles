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

" ===== キーマッピング =====

" Leaderキーをスペースに
let mapleader = " "

" Escの代わりにjj
inoremap jj <Esc>

" 保存
nnoremap <Leader>w :w<CR>

" 終了
nnoremap <Leader>q :q<CR>

" ===== 見た目 =====

" シンタックスハイライト
syntax on

" カラースキーム
colorscheme default
