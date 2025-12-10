" ===== プラグイン =====
call plug#begin('~/.local/share/nvim/plugged')

" ファイルマネージャー
Plug 'stevearc/oil.nvim'

" Markdown編集
Plug 'preservim/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

call plug#end()

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

" gg/Gを先頭/末尾に移動
nnoremap gg gg0
nnoremap G G$

" ===== oil.nvim 設定 =====
" プラグインが読み込まれた後に設定
augroup OilSetup
  autocmd!
  autocmd VimEnter * ++nested call s:setup_oil()
augroup END

function! s:setup_oil()
  if !exists('*oil#setup')
    lua << EOF
    local ok, oil = pcall(require, "oil")
    if ok then
      oil.setup({
        default_file_explorer = true,
        columns = {
          "icon",
          "permissions",
          "size",
          "mtime",
        },
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-x>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-r>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
        },
      })
    end
EOF
  endif
endfunction

" oil.nvimを開く（- キー）
nnoremap - :Oil<CR>

" カレントディレクトリでoilを開く
nnoremap <Leader>- :Oil .<CR>

" ===== Markdown & Mermaid 設定 =====

" vim-markdown 設定
let g:vim_markdown_folding_disabled = 1       " 折りたたみを無効化
let g:vim_markdown_conceal = 0                " 記号を隠さない
let g:vim_markdown_frontmatter = 1            " YAMLフロントマターをハイライト
let g:vim_markdown_math = 1                   " 数式サポート
let g:vim_markdown_fenced_languages = ['javascript=js', 'python=py', 'bash=sh', 'mermaid']

" markdown-preview 設定
let g:mkdp_auto_close = 0                     " プレビューを自動で閉じない
let g:mkdp_refresh_slow = 0                   " リアルタイム更新
let g:mkdp_browser = ''                       " デフォルトブラウザを使用
let g:mkdp_markdown_css = expand('~/.config/nvim/markdown-css/custom.css')  " カスタムCSS

" Markdown プレビュー起動 (Space + p)
nnoremap <Leader>p :MarkdownPreview<CR>
" プレビュー停止 (Space + P)
nnoremap <Leader>P :MarkdownPreviewStop<CR>

" ===== 見た目 =====

" シンタックスハイライト
syntax on

" True Color サポート
set termguicolors

" カラースキーム
colorscheme default

" 背景を完全に透過
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight SignColumn guibg=NONE ctermbg=NONE
