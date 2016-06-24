" vim: sw=4
"=============================================================================
" What Is This: Add some conceal operator for your purescript files
" File:         purescript.vim (conceal enhancement)
" Last Change:  2016-06-22
" Version:      1.0.0
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
"   - 1.0: Forked from vim-haskellConcealPlus
"

" Cf - check a flag. Return true if the flag is specified.
function! Cf(flag)
    return exists('g:psconcealopts') && stridx(g:psconcealopts, a:flag) >= 0
endfunction

if exists('g:no_purescript_conceal') || !has('conceal') || &enc != 'utf-8'
    finish
endif

" vim: set fenc=utf-8:
syntax match psNiceOperator "\\\ze[[:alpha:][:space:]_([]" conceal cchar=λ

" 'q' option to disable concealing of scientific constants (e.g. π).
if !Cf('q')
    syntax match psNiceOperator "\<pi\>" conceal cchar=π
    syntax match psNiceOperator "\<tau\>" conceal cchar=τ
endif

syntax match psNiceOperator "==" conceal cchar=≡
syntax match psNiceOperator "\/=" conceal cchar=≢

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

    " Redfining to get proper '::' concealing
    syntax match ps_DeclareFunction /^[a-z_(]\S*\(\s\|\n\)*::/me=e-2 nextgroup=psNiceOperator contains=ps_FunctionName,ps_OpFunctionName

    syntax match psNiceOperator "!!" conceal cchar=‼
    syntax match psNiceOperator "++\ze[^+]" conceal cchar=⧺
    syntax match psNiceOperator "\<forall\>" conceal cchar=∀
    syntax match psNiceOperator "-<" conceal cchar=↢
    syntax match psNiceOperator ">-" conceal cchar=↣
    syntax match psNiceOperator "-<<" conceal cchar=⤛
    syntax match psNiceOperator ">>-" conceal cchar=⤜
    " the star does not seem so good...
    " syntax match psNiceOperator "*" conceal cchar=★
    syntax match psNiceOperator "`div`" conceal cchar=÷

    " Only replace the dot, avoid taking spaces around.
    syntax match psNiceOperator /\s\.\s/ms=s+1,me=e-1 conceal cchar=∘

    syntax match hsQQEnd "|\]" contained conceal cchar=〛
    " sy match hsQQEnd "|\]" contained conceal=〚

    syntax match psNiceOperator "`elem`" conceal cchar=∈
    syntax match psNiceOperator "`notElem`" conceal cchar=∉
    syntax match psNiceOperator "`isSubsetOf`" conceal cchar=⊆
    syntax match psNiceOperator "`union`" conceal cchar=∪
    syntax match psNiceOperator "`intersect`" conceal cchar=∩
    syntax match psNiceOperator "\\\\\ze[[:alpha:][:space:]_([]" conceal cchar=∖

    syntax match psNiceOperator "||\ze[[:alpha:][:space:]_([]" conceal cchar=∨
    syntax match psNiceOperator "&&\ze[[:alpha:][:space:]_([]" conceal cchar=∧

    syntax match psNiceOperator "<\*>"      conceal cchar=⊛
    syntax match psNiceOperator "`append`" conceal cchar=⊕
    syntax match psNiceOperator "<>"        conceal cchar=⊕
    syntax match psNiceOperator "\<empty\>" conceal cchar=∅
    syntax match psNiceOperator "\<mzero\>" conceal cchar=∅
    syntax match psNiceOperator "\<mempty\>" conceal cchar=∅
endif

hi link psNiceOperator Operator
hi! link Conceal Operator
setlocal conceallevel=2

" '℘' option to disable concealing of powerset function
if !Cf('℘')
    syntax match psNiceOperator "\<powerset\>" conceal cchar=℘
endif

" '𝐒' option to disable String type to 𝐒 concealing
if !Cf('𝐒')
    syntax match psNiceOperator "\<String\>"  conceal cchar=𝐒
endif

" '𝐄' option to disable Either/Right/Left to 𝐄/𝑅/𝐿 concealing
if !Cf('𝐄')
    syntax match psNiceOperator "\<Either\>"  conceal cchar=𝐄
    syntax match psNiceOperator "\<Right\>"   conceal cchar=𝑅
    syntax match psNiceOperator "\<Left\>"    conceal cchar=𝐿
endif

" '𝐌' option to disable Maybe/Just/Nothing to 𝐌/𝐽/𝑁 concealing
if !Cf('𝐌')
    syntax match psNiceOperator "\<Maybe\>"   conceal cchar=𝐌
    syntax match psNiceOperator "\<Just\>"    conceal cchar=𝐽
    syntax match psNiceOperator "\<Nothing\>" conceal cchar=𝑁
endif

" 'A' option to not try to preserve indentation.
if Cf('A')
    syntax match psNiceOperator "<-" conceal cchar=←
    syntax match psNiceOperator "->" conceal cchar=→
    syntax match psNiceOperator "=>" conceal cchar=⇒
    syntax match psNiceOperator "\:\:" conceal cchar=∷
else
    syntax match hsLRArrowTail contained "-" conceal cchar= 
    syntax match hsLRArrowHead contained ">" conceal cchar=→
    syntax match hsLRArrowFull "->" contains=hsLRArrowHead,hsLRArrowTail

    syntax match hsRLArrowHead contained "<" conceal cchar= 
    syntax match hsRLArrowTail contained "-" conceal cchar=←
    syntax match hsRLArrowFull "<-" contains=hsRLArrowHead,hsRLArrowTail

    syntax match hsLRDArrowHead contained ">" conceal cchar=⇒
    syntax match hsLRDArrowTail contained "=" conceal cchar= 
    syntax match hsLRDArrowFull "=>" contains=hsLRDArrowHead,hsLRDArrowTail
endif

" 's' option to disable space consumption after ∑,∏,√ and ¬ functions.
if Cf('s')
    syntax match psNiceOperator "\<sum\>"                        conceal cchar=∑
    syntax match psNiceOperator "\<product\>"                    conceal cchar=∏
    syntax match psNiceOperator "\<sqrt\>"                       conceal cchar=√
    syntax match psNiceOperator "\<not\>"                        conceal cchar=¬
else
    syntax match psNiceOperator "\<sum\>\(\ze\s*[.$]\|\s*\)"     conceal cchar=∑
    syntax match psNiceOperator "\<product\>\(\ze\s*[.$]\|\s*\)" conceal cchar=∏
    syntax match psNiceOperator "\<sqrt\>\(\ze\s*[.$]\|\s*\)"    conceal cchar=√
    syntax match psNiceOperator "\<not\>\(\ze\s*[.$]\|\s*\)"     conceal cchar=¬
endif

" '*' option to enable concealing of asterisk with '⋅' sign.
if Cf('*')
    syntax match psNiceOperator "*" conceal cchar=⋅
" 'x' option to disable default concealing of asterisk with '×' sign.
elseif !Cf('x')
    syntax match psNiceOperator "*" conceal cchar=×
endif

" 'E' option to enable ellipsis concealing with ‥  (two dot leader).
if Cf('E')
    " The two dot leader is not guaranteed to be at the bottom. So, it
    " will break on some fonts.
    syntax match psNiceOperator "\.\." conceal cchar=‥
" 'e' option to disable ellipsis concealing with … (ellipsis sign).
elseif !Cf('e')
    syntax match psNiceOperator "\.\." conceal cchar=…
end

" '⇒' option to disable `implies` concealing with ⇒
if !Cf('⇒')
    " Easily distinguishable from => keyword since the keyword can only be
    " used in type signatures.
    syntax match psNiceOperator "`implies`"  conceal cchar=⇒
endif

" '⇔' option to disable `iff` concealing with ⇔
if !Cf('⇔')
    syntax match psNiceOperator "`iff`" conceal cchar=⇔
endif

" 'r' option to disable return (η) and join (µ) concealing.
if !Cf('r')
    syntax match psNiceOperator "\<pure\>" conceal cchar=η
    syntax match psNiceOperator "\<join\>"   conceal cchar=µ
endif

" 'b' option to disable bind (left and right) concealing
if Cf('b')
    " Vim has some issues concealing with composite symbols like '«̳', and
    " unfortunately there is no other common short notation for both
    " binds. So 'b' option to disable bind concealing altogether.
" 'f' option to enable formal (★) right bind concealing
elseif Cf('f')
    syntax match psLRBind1 contained ">" conceal cchar= 
    syntax match psLRBind2 contained ">" conceal cchar=
    syntax match psLRBind3 contained "=" conceal cchar= 
    syntax match psRLBindFull ">>=" contains=psLRBind1,psLRBind2,psLRBind3

    syntax match psRLBind1 contained "=" conceal cchar= 
    syntax match psRLBind2 contained "<" conceal cchar=
    syntax match psRLBind3 contained "<" conceal cchar= 
    syntax match psLRBindFull "=<<" contains=psLRBind1,psLRBind2,psLRBind3
" " 'c' option to enable encircled b/d (ⓑ/ⓓ) for right and left binds.
" elseif Cf('c')
"     syntax match psNiceOperator ">>="    conceal cchar=ⓑ
"     syntax match psNiceOperator "=<<"    conceal cchar=ⓓ
" " 'h' option to enable partial concealing of binds (e.g. »=).
elseif Cf('h')
    syntax match psNiceOperator ">>"     conceal cchar=≫
    syntax match psNiceOperator "<<"     conceal cchar=≪
    syntax match psNiceOperator "=\zs<<" conceal cchar=≪
" Left and right arrows with hooks are the default option for binds.
else
    syntax match psNiceOperator ">>=\ze\_[[:alpha:][:space:]_()[\]]" conceal cchar=↪
    syntax match psNiceOperator "=<<\ze\_[[:alpha:][:space:]_()[\]]" conceal cchar=↩
endif

if !Cf('h')
    syntax match psNiceOperator ">>\ze\_[[:alpha:][:space:]_()[\]]" conceal cchar=»
    syntax match psNiceOperator "<<\ze\_[[:alpha:][:space:]_()[\]]" conceal cchar=«
endif

" 'C' option to enable encircled 'm' letter ⓜ concealing for map.
if Cf('F')
    syntax match psNiceOperator "<$>"    conceal cchar=ⓜ
    syntax match psNiceOperator "`map`" conceal cchar=ⓜ
" 'l' option to disable fmap/lift concealing with ↥.
elseif !Cf('l')
    syntax match psNiceOperator "`liftM`" conceal cchar=↥
    syntax match psNiceOperator "`liftA`" conceal cchar=↥
    syntax match psNiceOperator "`map`"  conceal cchar=↥
    syntax match psNiceOperator "<$>"     conceal cchar=↥

    syntax match LIFTQ  contained "`" conceal
    syntax match LIFTQl contained "l" conceal cchar=↥
    syntax match LIFTl  contained "l" conceal cchar=↥
    syntax match LIFTi  contained "i" conceal
    syntax match LIFTf  contained "f" conceal
    syntax match LIFTt  contained "t" conceal
    syntax match LIFTA  contained "A" conceal
    syntax match LIFTM  contained "M" conceal
    syntax match LIFT2  contained "2" conceal cchar=²
    syntax match LIFT3  contained "3" conceal cchar=³
    syntax match LIFT4  contained "4" conceal cchar=⁴
    syntax match LIFT5  contained "5" conceal cchar=⁵

    syntax match psNiceOperator "`liftM2`" contains=LIFTQ,LIFTQl,LIFTi,LIFTf,LIFTt,LIFTM,LIFT2
    syntax match psNiceOperator "`liftM3`" contains=LIFTQ,LIFTQl,LIFTi,LIFTf,LIFTt,LIFTM,LIFT3
    syntax match psNiceOperator "`liftM4`" contains=LIFTQ,LIFTQl,LIFTi,LIFTf,LIFTt,LIFTM,LIFT4
    syntax match psNiceOperator "`liftM5`" contains=LIFTQ,LIFTQl,LIFTi,LIFTf,LIFTt,LIFTM,LIFT5
    syntax match psNiceOperator "`liftA2`" contains=LIFTQ,LIFTQl,LIFTi,LIFTf,LIFTt,LIFTA,LIFT2
    syntax match psNiceOperator "`liftA3`" contains=LIFTQ,LIFTQl,LIFTi,LIFTf,LIFTt,LIFTA,LIFT3

    syntax match FMAPm    contained "m" conceal cchar=↥
    syntax match FMAPa    contained "a" conceal
    syntax match FMAPp    contained "p" conceal
    syntax match FMAPSPC  contained " " conceal
    syntax match psNiceOperator "\<map\>\s*" contains=FMAPm,FMAPa,FMAPp,FMAPSPC

    syntax match LIFTSPC contained " " conceal
    syntax match psNiceOperator "\<liftA\>\s*"  contains=LIFTl,LIFTi,LIFTf,LIFTt,LIFTA,LIFTSPC
    syntax match psNiceOperator "\<liftA2\>\s*" contains=LIFTl,LIFTi,LIFTf,LIFTt,LIFTA,LIFT2,LIFTSPC
    syntax match psNiceOperator "\<liftA3\>\s*" contains=LIFTl,LIFTi,LIFTf,LIFTt,LIFTA,LIFT3,LIFTSPC

    syntax match psNiceOperator "\<liftM\>\s*"  contains=LIFTl,LIFTi,LIFTf,LIFTt,LIFTM,LIFTSPC
    syntax match psNiceOperator "\<liftM2\>\s*" contains=LIFTl,LIFTi,LIFTf,LIFTt,LIFTM,LIFT2,LIFTSPC
    syntax match psNiceOperator "\<liftM3\>\s*" contains=LIFTl,LIFTi,LIFTf,LIFTt,LIFTM,LIFT3,LIFTSPC
    syntax match psNiceOperator "\<liftM4\>\s*" contains=LIFTl,LIFTi,LIFTf,LIFTt,LIFTM,LIFT4,LIFTSPC
    syntax match psNiceOperator "\<liftM5\>\s*" contains=LIFTl,LIFTi,LIFTf,LIFTt,LIFTM,LIFT5,LIFTSPC

    " TODO: Move liftIO to its own flag?
    syntax match LIFTIOL contained "l" conceal
    syntax match LIFTI   contained "I" conceal cchar=i
    syntax match LIFTO   contained "O" conceal cchar=o
    syntax match psNiceOperator "\<liftIO\>" contains=LIFTIOl,LIFTi,LIFTf,LIFTt,LIFTI,LIFTO
endif

" '↱' option to disable mapM/forM concealing with ↱/↰
if !Cf('↱')
    syntax match MAPMQ  contained "`" conceal
    syntax match MAPMm  contained "m" conceal cchar=↱
    syntax match MAPMmQ contained "m" conceal cchar=↰
    syntax match MAPMa  contained "a" conceal
    syntax match MAPMp  contained "p" conceal
    syntax match MAPMM  contained "M" conceal
    syntax match MAPMM  contained "M" conceal
    syntax match MAPMU  contained "_" conceal cchar=_
    syntax match SPC    contained " " conceal
    syntax match psNiceOperator "`mapM_`"      contains=MAPMQ,MAPMmQ,MAPMa,MAPMp,MAPMM,MAPMU
    syntax match psNiceOperator "`mapM`"       contains=MAPMQ,MAPMmQ,MAPMa,MAPMp,MAPMM
    syntax match psNiceOperator "\<mapM\>\s*"  contains=MAPMm,MAPMa,MAPMp,MAPMM,SPC
    syntax match psNiceOperator "\<mapM_\>\s*" contains=MAPMm,MAPMa,MAPMp,MAPMM,MAPMU,SPC

    syntax match FORMQ  contained "`" conceal
    syntax match FORMfQ contained "f" conceal cchar=↱
    syntax match FORMf  contained "f" conceal cchar=↰
    syntax match FORMo  contained "o" conceal
    syntax match FORMr  contained "r" conceal
    syntax match FORMM  contained "M" conceal
    syntax match FORMU  contained "_" conceal cchar=_

    syntax match psNiceOperator "`forM`"  contains=FORMQ,FORMfQ,FORMo,FORMr,FORMM
    syntax match psNiceOperator "`forM_`" contains=FORMQ,FORMfQ,FORMo,FORMr,FORMM,FORMU

    syntax match psNiceOperator "\<forM\>\s*"  contains=FORMf,FORMo,FORMr,FORMM,SPC
    syntax match psNiceOperator "\<forM_\>\s*" contains=FORMf,FORMo,FORMr,FORMM,FORMU,SPC
endif

" 'w' option to disable 'where' concealing with "due to"/∵ symbol.
if !Cf('w')
    " ∵ means "because/since/due to." With quite a stretch this can be
    " used for 'where'. We preserve spacing, otherwise it breaks indenting
    " in a major way.
    syntax match WS contained "w" conceal cchar=∵
    syntax match HS contained "h" conceal cchar= 
    syntax match ES contained "e" conceal cchar= 
    syntax match RS contained "r" conceal cchar= 
    syntax match psNiceOperator "\<where\>" contains=WS,HS,ES,RS,ES
endif

" '-' option to disable subtract/(-) concealing with ⊟.
if !Cf('-')
    " Minus is a special syntax construct in Haskell. We use squared minus to
    " tell the syntax from the binary function.
    syntax match psNiceOperator "(-)"        conceal cchar=⊟
    syntax match psNiceOperator "`subtract`" conceal cchar=⊟
endif

" 'I' option to enable alternative ':+' concealing with with ⨢.
if Cf('I')
    " With some fonts might look better than ⅈ.
    syntax match psNiceOperator ":+"         conceal cchar=⨢
" 'i' option to disable default concealing of ':+' with ⅈ.
elseif !Cf('i')
    syntax match COLON contained ":" conceal cchar=+
    syntax match PLUS  contained "+" conceal cchar= 
    syntax match SPACE contained " " conceal cchar=ⅈ
    syntax match psNiceOperator ":+ " contains=COLON,PLUS,SPACE
    "syntax match psNiceOperator ":+"         conceal cchar=ⅈ
endif

" 'R' option to disable realPart/imagPart concealing with ℜ/ℑ.
if !Cf('R')
    syntax match psNiceOperator "\<realPart\>" conceal cchar=ℜ
    syntax match psNiceOperator "\<imagPart\>" conceal cchar=ℑ
endif

" 'T' option to enable True/False constants concealing with bold 𝐓/𝐅.
if Cf('T')
    syntax match hsNiceSpecial "\<true\>"  conceal cchar=𝐓
    syntax match hsNiceSpecial "\<false\>" conceal cchar=𝐅
" 't' option to disable True/False constants concealing with italic 𝑇/𝐹.
elseif !Cf('t')
    syntax match hsNiceSpecial "\<true\>"  conceal cchar=𝑇
    syntax match hsNiceSpecial "\<false\>" conceal cchar=𝐹
endif

" 'B' option to disable Bool type to 𝔹 concealing
if !Cf('B')
    " Not an official notation ttbomk. But at least
    " http://www.haskell.org/haskellwiki/Unicode-symbols mentions it.
    syntax match psNiceOperator "\<Boolean\>" conceal cchar=𝔹
endif

" 'Q' option to disable Rational type to ℚ concealing.
if !Cf('Q')
    syntax match psNiceOperator "\<Rational\>" conceal cchar=ℚ
endif

" 'Z' option to disable Integer type to ℤ concealing.
if !Cf('Z')
    syntax match psNiceOperator "\<Int\>"  conceal cchar=ℤ
endif

" 'C' option to disable Complex type to ℂ concealing
if !Cf('C')
    syntax match hasNiceOperator "\<Complex\>" conceal cchar=ℂ
endif

" '1' option to disable numeric superscripts concealing, e.g. x².
if !Cf('1')
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)0\ze\_W" conceal cchar=⁰
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)1\ze\_W" conceal cchar=¹
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)2\ze\_W" conceal cchar=²
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)3\ze\_W" conceal cchar=³
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)4\ze\_W" conceal cchar=⁴
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)5\ze\_W" conceal cchar=⁵
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)6\ze\_W" conceal cchar=⁶
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)7\ze\_W" conceal cchar=⁷
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)8\ze\_W" conceal cchar=⁸
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)9\ze\_W" conceal cchar=⁹
endif

" 'a' option to disable alphabet superscripts concealing, e.g. xⁿ.
if !Cf('a')
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)a\ze\_W" conceal cchar=ᵃ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)b\ze\_W" conceal cchar=ᵇ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)c\ze\_W" conceal cchar=ᶜ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)d\ze\_W" conceal cchar=ᵈ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)e\ze\_W" conceal cchar=ᵉ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)f\ze\_W" conceal cchar=ᶠ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)g\ze\_W" conceal cchar=ᵍ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)h\ze\_W" conceal cchar=ʰ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)i\ze\_W" conceal cchar=ⁱ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)j\ze\_W" conceal cchar=ʲ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)k\ze\_W" conceal cchar=ᵏ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)l\ze\_W" conceal cchar=ˡ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)m\ze\_W" conceal cchar=ᵐ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)n\ze\_W" conceal cchar=ⁿ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)o\ze\_W" conceal cchar=ᵒ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)p\ze\_W" conceal cchar=ᵖ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)r\ze\_W" conceal cchar=ʳ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)s\ze\_W" conceal cchar=ˢ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)t\ze\_W" conceal cchar=ᵗ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)u\ze\_W" conceal cchar=ᵘ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)v\ze\_W" conceal cchar=ᵛ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)w\ze\_W" conceal cchar=ʷ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)x\ze\_W" conceal cchar=ˣ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)y\ze\_W" conceal cchar=ʸ
    syntax match psNiceOperator "\(\*\*\|\^\|\^\^\)z\ze\_W" conceal cchar=ᶻ
endif

" Not really Haskell, but quite handy for writing proofs in pseudo-code.
if Cf('∴')
    syntax match psNiceOperator "\<therefore\>" conceal cchar=∴
    syntax match psNiceOperator "\<exists\>" conceal cchar=∃
    syntax match psNiceOperator "\<notExist\>" conceal cchar=∄
    syntax match psNiceOperator ":=" conceal cchar=≝
endif

" TODO:
" See Basic Syntax Extensions - School of Haskell | FP Complete
" intersection = (∩)
"
" From the Data.IntMap.Strict.Unicode
" notMember = (∉) = flip (∌)
" member = (∈) = flip (∋)
" isProperSubsetOf = (⊂) = flip (⊃)
"
" From Data.Sequence.Unicode
" (<|) = (⊲ )
" (|>) = (⊳ )
" (><) = (⋈ )
