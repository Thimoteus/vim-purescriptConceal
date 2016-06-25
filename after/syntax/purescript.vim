"=============================================================================
" What Is This: Add some conceal operator for your purescript files
" File:         purescript.vim (conceal enhancement)
" Author:       Vincent Berthoux <twinside@gmail.com> (original), Thimoteus
" <thimoteus@teknik.io>
" Last Change:  2016-02-10
" Version:      2.0.0
" Require:
"   set nocompatible
"     somewhere on your .vimrc
"
"   Vim 7.3 or Vim compiled with conceal patch.
"   Use --with-features=big or huge in order to compile it in.
"
" Usage:
"   Drop this file in your
"       ~/.vim/after/syntax folder (Linux/MacOSX/BSD...)
"       ~/vimfiles/after/syntax folder (Windows)
"
"   For this script to work, you have to set the encoding
"   to utf-8 :set enc=utf-8
"
" Additional:
"     * if you want to avoid the loading, add the following
"       line in your .vimrc :
"        let g:no_purescript_conceal = 1
"  Changelog:
"   - 1.0: Forked from Twinside/vim-haskellConceal and made basic changes.
"   - 2.0: Changes for purescript
"
if exists('g:no_purescript_conceal') || !has('conceal') || &enc != 'utf-8'
    finish
endif

function! Cf(flag)
    return exists('g:psconcealopts') && stridx(g:psconcealopts, a:flag) >= 0
endfunction

" vim: set fenc=utf-8:
syntax match psNiceOperator "\\\ze[[:alpha:][:space:]_([]" conceal cchar=λ
syntax match psNiceOperator "\<sum\>" conceal cchar=∑
syntax match psNiceOperator "\<product\>" conceal cchar=∏
syntax match psNiceOperator "\<sqrt\>" conceal cchar=√
syntax match psNiceOperator "\<pi\>" conceal cchar=π
syntax match psNiceOperator "\/=" conceal cchar=≠
syntax match psNiceOperator ">>" conceal cchar=≫
syntax match psNiceOperator "<<" conceal cchar=≪

let s:extraConceal = 1
" Some windows font don't support some of the characters,
" so if they are the main font, we don't load them :)
if has("win32")
    let s:incompleteFont = [ 'Consolas'
                        \ , 'Lucida Console'
                        \ , 'Courier New'
                        \ ]
    let s:mainfont = substitute( &guifont, '^\([^:,]\+\).*', '\1', '')
    for s:fontName in s:incompleteFont
        if s:mainfont ==? s:fontName
            let s:extraConceal = 0
            break
        endif
    endfor
endif

if s:extraConceal
    syntax match psNiceOperator "\<undefined\>" conceal cchar=⊥

    " Match greater than and lower than w/o messing with Kleisli composition
    syntax match psNiceOperator "<=\ze[^<]" conceal cchar=≤
    syntax match psNiceOperator ">=\ze[^>]" conceal cchar=≥

    syntax match psNiceOperator ">>>" conceal cchar=⋙

    " Redefining to get proper '::' concealing
    syntax match ps_DeclareFunction /^[a-z_(]\S*\(\s\|\n\)*::/me=e-2 nextgroup=psNiceOperator contains=ps_FunctionName,ps_OpFunctionName
    syntax match psNiceOperator "\:\:" conceal cchar=∷

    syntax match psNiceOperator "forall" conceal cchar=∀
    " the star does not seem so good...
    " syntax match hsNiceOperator "*" conceal cchar=★
    syntax match psNiceOperator "`div`" conceal cchar=÷

    syntax match psNiceOperator "<<<" conceal cchar=·
    " Only replace the dot, avoid taking spaces around.
    "syntax match psNiceOperator /\s\.\s/ms=s+1,me=e-1 conceal cchar=∘
    syntax match psNiceOperator "\.\." conceal cchar=‥

    syntax match psQQEnd "|\]" contained conceal cchar=〛
    " sy match hsQQEnd "|\]" contained conceal=〚

    syntax match psNiceOperator "`elem`" conceal cchar=∈
    syntax match psNiceOperator "`notElem`" conceal cchar=∉
    syntax match psNiceOperator "`union`" conceal cchar=∪
    syntax match psNiceOperator "`intersect`" conceal cchar=∩
    syntax match psNiceOperator "\\\\\ze[[:alpha:][:space:]_([]" conceal cchar=∖

    syntax match psNiceOperator "||\ze[[:alpha:][:space:]_([]" conceal cchar=∨
    syntax match psNiceOperator "&&\ze[[:alpha:][:space:]_([]" conceal cchar=∧
    syntax match psNiceOperator "\<not\>" conceal cchar=¬

    syntax match psNiceOperator "!!" conceal cchar=‼

    " <$>
    syn match FMap "<$>" contains=FMap1,FMap2,FMap3
    syn match FMap1 contained "<" conceal cchar=-
    syn match FMap2 contained /\$/ conceal cchar=-
    syn match FMap3 contained ">" conceal cchar=↦

    " <|
    syntax match psNiceOperator "<|" conceal cchar=⊲

    " |>
    syntax match psNiceOperator "|>" conceal cchar=⊳

    " |=
    syn match Models  /|=/        contains=ModelsL,ModelsR
    syn match ModelsL   /|/       contained containedin=Models conceal cchar=⊧
    syn match ModelsR   /=/       contained containedin=Models conceal cchar==

    " ->
    syn match MHArrow   /->/       contains=MHArrowM,MHArrowH
    syn match MHArrowM  /-/        contained containedin=MHArrow conceal cchar=-
    syn match MHArrowH  /-\@<=>/   contained containedin=MHArrow conceal cchar=→

    " <-
    syntax match HMArrow   /<\ze-/    contains=HMArrowM,HMArrowH
    syntax match HMArrowH  /</        contained containedin=HMArrow conceal cchar=←

    if Cf('c')
    " =>
      syntax match DMHArrow   /=>/       contains=DMHArrowM,DMHArrowH
      syntax match DMHArrowM  /=/        contained containedin=DMHArrow conceal cchar=
      syntax match DMHArrowH  /=\@<=>/   contained containedin=DMHArrow conceal cchar=⇒
    else
      syntax match DMHArrow   /=>/       contains=DMHArrowM,DMHArrowH
      syntax match DMHArrowM  /=/        contained containedin=DMHArrow conceal cchar==
      syntax match DMHArrowH  /=\@<=>/   contained containedin=DMHArrow conceal cchar=⇒
    endif

    " >>=
    syntax match DTTMArrow   />>\ze=/   contains=DTTMArrowT,DTTMArrowTT
    syntax match DTTMArrowTT />/        contained containedin=DTTMArrow conceal cchar=
    syntax match DTTMArrowT  />\@<=>/   contained containedin=DTTMArrow conceal cchar=

    if Cf('c')
    " >=>
      syntax match DTMHArrow   />=>/      contains=DTMHArrowT,DTMHArrowM,DTMHArrowH
      syntax match DTMHArrowT  />/        contained containedin=DTMHArrow conceal cchar=
      syntax match DTMHArrowM  /=/        contained containedin=DTMHArrow conceal cchar=
      syntax match DTMHArrowH  /=\@<=>/   contained containedin=DTMHArrow conceal cchar=⇒
    else
      syntax match DTMHArrow   />=>/      contains=DTMHArrowT,DTMHArrowM,DTMHArrowH
      syntax match DTMHArrowT  />/        contained containedin=DTMHArrow conceal cchar=
      syntax match DTMHArrowM  /=/        contained containedin=DTMHArrow conceal cchar==
      syntax match DTMHArrowH  /=\@<=>/   contained containedin=DTMHArrow conceal cchar=⇒
    endif

    if Cf('c')
    " <=<
      syntax match DHMTArrow   "<=<"      contains=DHMTArrowM,DHMTArrowH,DHMTArrowT
      syntax match DHMTArrowH  "<"        contained containedin=DHMTArrow conceal cchar=⇐
      syntax match DHMTArrowM  "="        contained containedin=DHMTArrow conceal cchar=
      syntax match DHMTArrowT  "=\@<=<"   contained containedin=DHMTArrow conceal cchar=
    else 
      syntax match DHMTArrow   "<=<"      contains=DHMTArrowM,DHMTArrowH,DHMTArrowT
      syntax match DHMTArrowH  "<"        contained containedin=DHMTArrow conceal cchar=⇐
      syntax match DHMTArrowM  "="        contained containedin=DHMTArrow conceal cchar==
      syntax match DHMTArrowT  "=\@<=<"   contained containedin=DHMTArrow conceal cchar=
    endif

    if Cf('c')
    " =<<
      syn match DMTTArrow    /=<</      contains=DMTTArrowT,DMTTArrowTT,DMTTArrowM
      syn match DMTTArrowM   /=/        contained containedin=DMTTArrow conceal cchar=
      syn match DMTTArrowT   /</        contained containedin=DMTTArrow conceal cchar=
      syn match DMTTArrowTT  /<\@<=</   contained containedin=DMTTArrow conceal cchar=
    else
      syn match DMTTArrow    /=<</      contains=DMTTArrowT,DMTTArrowTT,DMTTArrowM
      syn match DMTTArrowM   /=/        contained containedin=DMTTArrow conceal cchar==
      syn match DMTTArrowT   /</        contained containedin=DMTTArrow conceal cchar=
      syn match DMTTArrowTT  /<\@<=</   contained containedin=DMTTArrow conceal cchar=
    endif

    " -<
    syn match MTArrow   /-</       contains=MTArrowT,MTArrowM
    syn match MTArrowT  /-/        contained containedin=MTArrow conceal cchar=-
    syn match MTArrowM  /-\@<=</   contained containedin=MTArrow conceal cchar=⤙

    " -<<
    syn match MTTArrow   /-<</          contains=MTTArrowT,MTTArrowM,HTTArrowTT
    syn match MTTArrowM  /-<</me=s+1    contained containedin=MTTArrow conceal cchar=-
    syn match MTTArrowT  /-\@<=</       contained containedin=MTTArrow conceal cchar=⤛
    syn match MTTArrowTT /\(-<\)\@<=</  contained containedin=MTTArrow conceal cchar=<

    " >-
    syn match TMArrow   />\ze-/    contains=TMArrowT,TMArrowM
    syn match TMArrowT  />/        contained containedin=TMArrow conceal cchar=⤚

    ">>-
    syn match TTMArrow    />>\ze-/  contains=TTMArrowT,TTMArrowTT
    syn match TTMArrowTT  />/       contained containedin=TTMArrow conceal cchar=
    syn match TTMArrowT   />\@<=>/  contained containedin=TTMArrow conceal cchar=⤜
endif

hi link psNiceOperator Operator
hi! link Conceal Operator
setlocal conceallevel=2

