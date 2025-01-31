#! /usr/bin/bash

install_dependencies() {
    # Install nice to haves and dotnet-sdk
    apt-get update && apt-get install -y curl git iputils-ping tmux jq xclip dotnet-sdk-8.0
    # Install neovim
    cd /
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod a+x nvim.appimage
    ./nvim.appimage --appimage-extract
    ln -s /squashfs-root/AppRun /usr/bin/nvim
    cd -
    # Install Az CLI
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash # For AZ CLI
    # Install core func tools
    wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb
    apt-get update
    apt-get install -y azure-functions-core-tools-4
}

configure_neovim() {
    # Create a directory for colors
    mkdir -p "/home/${OPTARG}/.config/nvim/colors"

    # Create a coloscheme with the dikiaap/minimalist theme
    cat <<'EOF' > "/home/${OPTARG}/.config/nvim/colors/minimalist.vim"
set background=dark
if version > 580
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
set t_Co=256
let g:colors_name = "minimalist"

"""""""""""""""""""""""
" General
"""""""""""""""""""""""
hi ColorColumn      ctermfg=NONE    ctermbg=233     cterm=NONE      guifg=NONE          guibg=#121212   gui=NONE
hi Cursor           ctermfg=234     ctermbg=255     cterm=NONE      guifg=#1C1C1C       guibg=#EEEEEE   gui=NONE
hi CursorColumn     ctermfg=NONE    ctermbg=233     cterm=NONE      guifg=NONE          guibg=#121212   gui=NONE
hi CursorLine       ctermfg=NONE    ctermbg=233     cterm=NONE      guifg=NONE          guibg=#121212   gui=NONE
hi CursorLineNr     ctermfg=59      ctermbg=233     cterm=NONE      guifg=#5F5F5F       guibg=#121212   gui=NONE
hi DiffAdd          ctermfg=255     ctermbg=64      cterm=bold      guifg=#EEEEEE       guibg=#5F8700   gui=bold
hi DiffChange       ctermfg=NONE    ctermbg=NONE    cterm=NONE      guifg=NONE          guibg=NONE      gui=NONE
hi DiffDelete       ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE
hi DiffText         ctermfg=255     ctermbg=24      cterm=bold      guifg=#EEEEEE       guibg=#005F87   gui=bold
hi Directory        ctermfg=179     ctermbg=NONE    cterm=NONE      guifg=#D7AF5F       guibg=NONE      gui=NONE
hi ErrorMsg         ctermfg=255     ctermbg=167     cterm=NONE      guifg=#EEEEEE       guibg=#D75F5F   gui=NONE
hi FoldColumn       ctermfg=117     ctermbg=239     cterm=NONE      guifg=#87D7FF       guibg=#4E4E4E   gui=NONE
hi Folded           ctermfg=242     ctermbg=234     cterm=NONE      guifg=#666666       guibg=#1C1C1C   gui=NONE
hi IncSearch        ctermfg=234     ctermbg=75      cterm=NONE      guifg=#1C1C1C       guibg=#5FAFFF   gui=NONE
hi LineNr           ctermfg=59      ctermbg=234     cterm=NONE      guifg=#5F5F5F       guibg=#1C1C1C   gui=NONE
hi MatchParen       ctermfg=NONE    ctermbg=NONE    cterm=underline guifg=NONE          guibg=NONE      gui=underline
hi MoreMsg          ctermfg=150     ctermbg=NONE    cterm=NONE      guifg=#AFD787       guibg=NONE      gui=NONE
hi NonText          ctermfg=234     ctermbg=234     cterm=NONE      guifg=#1C1C1C       guibg=#1C1C1C   gui=NONE
hi Normal           ctermfg=255     ctermbg=234     cterm=NONE      guifg=#EEEEEE       guibg=#1C1C1C   gui=NONE
hi Pmenu            ctermfg=NONE    ctermbg=NONE    cterm=NONE      guifg=NONE          guibg=NONE      gui=NONE
hi PmenuSel         ctermfg=NONE    ctermbg=59      cterm=NONE      guifg=NONE          guibg=#5F5F5F   gui=NONE
hi Question         ctermfg=150     ctermbg=NONE    cterm=NONE      guifg=#AFD787       guibg=NONE      gui=bold
hi Search           ctermfg=NONE    ctermbg=NONE    cterm=underline guifg=NONE          guibg=NONE      gui=underline
hi SignColumn       ctermfg=NONE    ctermbg=237     cterm=NONE      guifg=NONE          guibg=#3A3A3A   gui=NONE
hi StatusLine       ctermfg=255     ctermbg=239     cterm=bold      guifg=#EEEEEE       guibg=#4E4E4E   gui=bold
hi StatusLineNC     ctermfg=255     ctermbg=239     cterm=NONE      guifg=#EEEEEE       guibg=#4E4E4E   gui=NONE
hi Title            ctermfg=255     ctermbg=NONE    cterm=NONE      guifg=#EEEEEE       guibg=NONE      gui=NONE
hi Underlined       ctermfg=NONE    ctermbg=NONE    cterm=NONE      guifg=NONE          guibg=NONE      gui=NONE
hi VertSplit        ctermfg=239     ctermbg=239     cterm=NONE      guifg=#4E4E4E       guibg=#4E4E4E   gui=NONE
hi Visual           ctermfg=NONE    ctermbg=236     cterm=NONE      guifg=NONE          guibg=#303030   gui=NONE
hi WarningMsg       ctermfg=255     ctermbg=167     cterm=NONE      guifg=#EEEEEE       guibg=#D75F5F   gui=NONE
hi WildMenu         ctermfg=234     ctermbg=215     cterm=NONE      guifg=#1C1C1C       guibg=#FFAF5F   gui=NONE
hi NERDTreeUp       ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE
hi NERDTreeDir      ctermfg=251     ctermbg=NONE    cterm=bold      guifg=#C6C6C6       guibg=NONE      gui=bold
hi NERDTreeDirSlash ctermfg=251     ctermbg=NONE    cterm=NONE      guifg=#C6C6C6       guibg=NONE      gui=NONE
hi NERDTreeFile     ctermfg=241     ctermbg=NONE    cterm=NONE      guifg=#606060       guibg=NONE      gui=NONE
hi NERDTreeCWD      ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE
hi NERDTreeOpenable ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE
hi NERDTreeClosable ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE

"""""""""""""""""""""""
" Syntax Highlighting
"""""""""""""""""""""""
hi Boolean          ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi Character        ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi Comment          ctermfg=240     ctermbg=NONE    cterm=NONE      guifg=#585858       guibg=NONE      gui=NONE
hi Conditional      ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi Constant         ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi Define           ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi Error            ctermfg=255     ctermbg=167     cterm=NONE      guifg=#EEEEEE       guibg=#D75F5F   gui=NONE
hi Float            ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi Function         ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi Identifier       ctermfg=255     ctermbg=NONE    cterm=NONE      guifg=#EEEEEE       guibg=NONE      gui=italic
hi Keyword          ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi Label            ctermfg=186     ctermbg=NONE    cterm=NONE      guifg=#D7D787       guibg=NONE      gui=NONE
hi Number           ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi Operator         ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi PreCondit        ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi PreProc          ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi Repeat           ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi Special          ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi SpecialComment   ctermfg=242     ctermbg=NONE    cterm=NONE      guifg=#666666       guibg=NONE      gui=NONE
hi SpecialKey       ctermfg=59      ctermbg=237     cterm=NONE      guifg=#5F5F5F       guibg=#3A3A3A   gui=NONE
hi SpellBad         ctermfg=255     ctermbg=167     cterm=NONE      guifg=#EEEEEE       guibg=#D75F5F   gui=undercurl
hi SpellCap         ctermfg=255     ctermbg=74      cterm=NONE      guifg=#EEEEEE       guibg=#5FAFD7   gui=undercurl
hi SpellRare        ctermfg=255     ctermbg=140     cterm=NONE      guifg=#EEEEEE       guibg=#AF87D7   gui=undercurl
hi SpellLocal       ctermfg=255     ctermbg=14      cterm=NONE      guifg=#EEEEEE       guibg=#5FB3B3   gui=undercurl
hi Statement        ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE
hi StorageClass     ctermfg=215     ctermbg=NONE    cterm=NONE      guifg=#FFAF5F       guibg=NONE      gui=italic
hi String           ctermfg=150     ctermbg=NONE    cterm=NONE      guifg=#AFD787       guibg=NONE      gui=NONE
hi Structure        ctermfg=215     ctermbg=NONE    cterm=NONE      guifg=#FFAF5F       guibg=NONE      gui=NONE
hi Tag              ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi Todo             ctermfg=74      ctermbg=234     cterm=inverse   guifg=#5FAFD7       guibg=#1C1C1C   gui=inverse,bold
hi Type             ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE

"""""""""""""""""""""""
" Supports
"""""""""""""""""""""""
hi cInclude             ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE " C++
hi cOperator            ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi cppStatement         ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi cssAttr              ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE " CSS/CSS3
hi cssAttrComma         ctermfg=231     ctermbg=NONE    cterm=NONE      guifg=#EEEEEE       guibg=NONE      gui=NONE
hi cssBoxProp           ctermfg=152     ctermbg=NONE    cterm=NONE      guifg=#AFD7D7       guibg=NONE      gui=NONE
hi cssBraces            ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi cssClassName         ctermfg=215     ctermbg=NONE    cterm=NONE      guifg=#FFAF5F       guibg=NONE      gui=NONE
hi cssColor             ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi cssCommonAttr        ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi cssFontAttr          ctermfg=150     ctermbg=NONE    cterm=NONE      guifg=#AFD787       guibg=NONE      gui=NONE
hi cssFunctionName      ctermfg=75      ctermbg=NONE    cterm=NONE      guifg=#5FAFFF       guibg=NONE      gui=NONE
hi cssNoise             ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi cssProp              ctermfg=152     ctermbg=NONE    cterm=NONE      guifg=#AFD7D7       guibg=NONE      gui=NONE
hi cssPseudoClass       ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi cssPseudoClassId     ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi cssTagName           ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE
hi cssUIAttr            ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi cssUnitDecorators    ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi cssURL               ctermfg=255     ctermbg=NONE    cterm=NONE      guifg=#EEEEEE       guibg=NONE      gui=italic
hi cssValueLength       ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi cssValueNumber       ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi cssVendor            ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi htmlArg              ctermfg=215     ctermbg=NONE    cterm=NONE      guifg=#FFAF5F       guibg=NONE      gui=NONE " HTML/HTML5
hi htmlEndTag           ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi htmlScriptTag        ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi htmlSpecialChar      ctermfg=215     ctermbg=NONE    cterm=NONE      guifg=#FFAF5F       guibg=NONE      gui=NONE
hi htmlSpecialTagName   ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE
hi htmlTag              ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi htmlTagName          ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE
hi javaScriptBoolean    ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE " JavaScript
hi javaScriptBraces     ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi javaScriptConditional ctermfg=140    ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi javaScriptException  ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi javaScriptFunction   ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=italic
hi javaScriptGlobal     ctermfg=255     ctermbg=NONE    cterm=NONE      guifg=#EEEEEE       guibg=NONE      gui=NONE
hi javaScriptIdentifier ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi javaScriptLabel      ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi javaScriptMessage    ctermfg=255     ctermbg=NONE    cterm=NONE      guifg=#EEEEEE       guibg=NONE      gui=NONE
hi javaScriptNull       ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi javaScriptNumber     ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi javaScriptOperator   ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi javaScriptParens     ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi javaScriptRegexpString ctermfg=117   ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi javaScriptRepeat     ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi javaScriptSpecial    ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi javaScriptStatement  ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi markdownCode         ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE " Markdown
hi markdownCodeBlock    ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi markdownCodeDelimiter ctermfg=247    ctermbg=NONE    cterm=NONE      guifg=#9E9E9E       guibg=NONE      gui=NONE
hi markdownError        ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE
hi markdownHeadingDelimiter ctermfg=150 ctermbg=NONE    cterm=NONE      guifg=#AFD787       guibg=NONE      gui=NONE
hi markdownUrl          ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi phpBoolean           ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE " PHP
hi phpClass             ctermfg=215     ctermbg=NONE    cterm=NONE      guifg=#FFAF5F       guibg=NONE      gui=NONE
hi phpClassDelimiter    ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi phpClassExtends      ctermfg=150     ctermbg=NONE    cterm=NONE      guifg=#AFD787       guibg=NONE      gui=NONE
hi phpClassImplements   ctermfg=150     ctermbg=NONE    cterm=NONE      guifg=#AFD787       guibg=NONE      gui=NONE
hi phpCommentStar       ctermfg=240     ctermbg=NONE    cterm=NONE      guifg=#585858       guibg=NONE      gui=NONE
hi phpCommentTitle      ctermfg=240     ctermbg=NONE    cterm=NONE      guifg=#585858       guibg=NONE      gui=NONE
hi phpDocComment        ctermfg=240     ctermbg=NONE    cterm=NONE      guifg=#585858       guibg=NONE      gui=NONE
hi phpDocIdentifier     ctermfg=240     ctermbg=NONE    cterm=NONE      guifg=#585858       guibg=NONE      gui=NONE
hi phpDocParam          ctermfg=240     ctermbg=NONE    cterm=NONE      guifg=#585858       guibg=NONE      gui=NONE
hi phpDocTags           ctermfg=242     ctermbg=NONE    cterm=NONE      guifg=#666666       guibg=NONE      gui=NONE
hi phpFunction          ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi phpFunctions         ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi phpIdentifier        ctermfg=255     ctermbg=NONE    cterm=NONE      guifg=#EEEEEE       guibg=NONE      gui=NONE
hi phpInclude           ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi phpKeyword           ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi phpMethod            ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi phpNumber            ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi phpOperator          ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi phpParent            ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi phpMemberSelector    ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi phpMethodsVar        ctermfg=255     ctermbg=NONE    cterm=NONE      guifg=#EEEEEE       guibg=NONE      gui=NONE
hi phpStaticClasses     ctermfg=215     ctermbg=NONE    cterm=NONE      guifg=#FFAF5F       guibg=NONE      gui=NONE
hi phpStringDouble      ctermfg=150     ctermbg=NONE    cterm=NONE      guifg=#AFD787       guibg=NONE      gui=NONE
hi phpStringDelimiter   ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi phpStringSingle      ctermfg=150     ctermbg=NONE    cterm=NONE      guifg=#AFD787       guibg=NONE      gui=NONE
hi phpSuperglobals      ctermfg=255     ctermbg=NONE    cterm=NONE      guifg=#EEEEEE       guibg=NONE      gui=NONE
hi phpType              ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi phpUseClass          ctermfg=215     ctermbg=NONE    cterm=NONE      guifg=#FFAF5F       guibg=NONE      gui=NONE
hi phpVarSelector       ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi pythonConditional    ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE " Python
hi pythonDecorator      ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi pythonException      ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi pythonFunction       ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi pythonInclude        ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi pythonNumber         ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi pythonOperator       ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi pythonRepeat         ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi pythonStatement      ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi pythonTodo           ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi rubyBlockParameter   ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE " Ruby
hi rubyClass            ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi rubyClassVariable    ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi rubyConstant         ctermfg=215     ctermbg=NONE    cterm=NONE      guifg=#FFAF5F       guibg=NONE      gui=italic
hi rubyControl          ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi rubyException        ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi rubyFunction         ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi rubyInclude          ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi rubyInstanceVariable ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi rubyInterpolationDelimiter ctermfg=117 ctermbg=NONE  cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi rubyOperator         ctermfg=140     ctermbg=NONE    cterm=NONE      guifg=#AF87D7       guibg=NONE      gui=NONE
hi rubyPseudoVariable   ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi rubyRegexp           ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi rubyRegexpDelimiter  ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi rubyStringDelimiter  ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi rubySymbol           ctermfg=150     ctermbg=NONE    cterm=NONE      guifg=#AFD787       guibg=NONE      gui=NONE
hi sassClass            ctermfg=215     ctermbg=NONE    cterm=NONE      guifg=#FFAF5F       guibg=NONE      gui=NONE " Sass
hi sassClassChar        ctermfg=215     ctermbg=NONE    cterm=NONE      guifg=#FFAF5F       guibg=NONE      gui=NONE
hi sassFunction         ctermfg=255     ctermbg=NONE    cterm=NONE      guifg=#EEEEEE       guibg=NONE      gui=NONE
hi sassInclude          ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi sassVariable         ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi shFunction           ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE " Shell
hi shOperator           ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi shStatement          ctermfg=74      ctermbg=NONE    cterm=NONE      guifg=#5FAFD7       guibg=NONE      gui=NONE
hi shTestOpr            ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi shVariable           ctermfg=255     ctermbg=NONE    cterm=NONE      guifg=#EEEEEE       guibg=NONE      gui=NONE
hi xmlAttrib            ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE " XML
hi xmlCdataStart        ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi xmlCdataCdata        ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi xmlEndTag            ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE
hi xmlEntity            ctermfg=173     ctermbg=NONE    cterm=NONE      guifg=#D7875F       guibg=NONE      gui=NONE
hi xmlEntityPunct       ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi xmlEqual             ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi xmlProcessingDelim   ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi xmlTag               ctermfg=117     ctermbg=NONE    cterm=NONE      guifg=#87D7FF       guibg=NONE      gui=NONE
hi xmlTagName           ctermfg=167     ctermbg=NONE    cterm=NONE      guifg=#D75F5F       guibg=NONE      gui=NONE
EOF

    cat <<'EOF' > "/home/${OPTARG}/.config/nvim/init.lua"
-- allow mouse
vim.opt.mouse = "a"

-- line numbers
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.number = true -- show absolute line number on cursor line (when relative number is on)

-- tabs & indentation
vim.opt.tabstop = 4 -- Four spaces for tabs (prettier default)
vim.opt.shiftwidth = 4 -- Four spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
vim.opt.wrap = false -- disable line wrapping

-- search settings
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-insensitive

-- cursor line
vim.opt.cursorline = true -- highlight the current cursor line

-- appearance
vim.opt.termguicolors = true
vim.opt.background = "dark" -- colorschemes that can be light or datk will be made dark

-- backspace
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

vim.opt.iskeyword:append("-") -- consider string-string as whole word

-- colorscheme
vim.cmd("colorscheme minimalist")

-- Visual mode highlight color
vim.cmd [[
    highlight Visual guibg=#c0fd8d guifg=NONE
]]

-------------------- Configure tmux REPL functionality --------------------
local function capture_std_out(command)
    local handle = io.popen(command)
    local std_output = handle:read("*a") -- Read all output
    handle:close()
    return std_output
end

local function tmux_is_active()
    local tmux_status = tonumber(os.execute("tmux ls > /dev/null 2> /dev/null"))
    if tmux_status == 256 then
        return false
    end 
    return true
end

local function tmux_has_exactly_two_panes()
    local tmux_pane_numbers = tonumber(capture_std_out("tmux list-panes | wc -l"))
    if tmux_pane_numbers ~= 2 then
        return false
    end
    return true
end

local function handle_quoting_in_command(input)
    local first_quote_index = input:find("[\'\"]") -- Find first occurence of ' or "

    if not first_quote_index then
        return string.format('tmux send-keys -t 1 %q Enter', input)
    end

    local quote_character = string.sub(input, first_quote_index, first_quote_index)
    local input_handled_quote = ''
    local formatted_string = string.format('tmux send-keys -t 1 %q Enter', input)

    if quote_character == "'" then
        input_handled_quote = formatted_string:gsub('\\"', '"'):gsub("'", "'\\''"):gsub('1 "', "1 '"):gsub('" Enter', "' Enter")
    elseif quote_character == '"' then
        input_handled_quote = formatted_string:gsub('\\\\', '\\'):gsub('1 "', "1 '"):gsub('" Enter', "' Enter"):gsub('\\"', '"'):gsub("'", "'\\''"):gsub("1 '\\''", "1 '"):gsub("'\\'' Enter", "' Enter")
    end
    return input_handled_quote
end

local function execute_visual_selection()
    if not (tmux_is_active() and tmux_has_exactly_two_panes()) then
        return
    end

    -- Get the start and end positions of the visual selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    -- Extract the lines from the buffer, execute each one, then move the cursor forward by one line
    local lines = vim.fn.getline(start_pos[2], end_pos[2])

    for _, line in ipairs(lines) do
        local command = handle_quoting_in_command(line)
        os.execute(command)
    end
    vim.fn.setpos('.', { end_pos[1], end_pos[2] + 1, 0, nul })
end

-- Create a command to call the function
vim.api.nvim_create_user_command('ExecuteVisual', execute_visual_selection, {})

-- Set key mapping for Visual Mode
vim.api.nvim_set_keymap('v', '<CR>', ':<C-u>ExecuteVisual<CR>', { noremap = true, silent = true })

EOF

}

configure_tmux() {

    git clone https://github.com/tmux-plugins/tpm "/home/${OPTARG}/.tmux/plugins/tpm"

    cat <<'EOF' > "/home/${OPTARG}/.tmux.conf"
# Get rid of tmux nvim lag from escaping
set -sg escape-time 0

# Change the prefix
set -g prefix C-a
unbind C-b
bind-key C-a send-prefix

# Use <C-a>n to split terminal vertically
unbind %
bind n split-window -h

# Use <C-a>N to split the terminal horizontally
unbind '"'
bind N split-window -v

EOF

    echo "unbind r" >> "/home/${OPTARG}/.tmux.conf"
    echo "bind r source-file /home/${OPTARG}/.tmux.conf" >> "/home/${OPTARG}/.tmux.conf"
    echo "" >> "/home/${OPTARG}/.tmux.conf"

    cat <<'EOF' >> "/home/${OPTARG}/.tmux.conf"
# Use <C-a>[h|j|k|l] to resize the pane by 5 units
# Use <C-a>m to maximise the tmux pane
# Enable the mouse to be able to maximise
bind -r j resize-pane -D 5
bind -r k resize-pane -U 5
bind -r l resize-pane -R 5
bind -r h resize-pane -L 5
bind -r m resize-pane -Z
set -g mouse on

# Use <C-a>t to create a new window
unbind t
bind t new-window

# Use <C-h> and <C-l> to go to the next and previous window
unbind C-h
unbind C-l
bind-key -n C-h previous-window
bind-key -n C-l next-window

# Use <Alt-h>, <Alt-j>, <Alt-k> and <Alt-l> to move left, down, up and right respectively
bind-key -n M-h select-pane -L
bind-key -n M-j select-pane -D
bind-key -n M-k select-pane -U
bind-key -n M-l select-pane -R

# Use <C-a>q to kill the pane
unbind q
bind q kill-pane

# Enable vi mode in tmux and use <C-a>v to enter it
unbind v
bind v copy-mode
set-window-option -g mode-keys vi
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe 'xclip -in -selection clipboard'
unbind -T copy-mode-vi MouseDragEnd1Pane

# After executing git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Tmux plugin manager
set -g @plugin 'tmux-plugins/tpm'

# Themes for tmux
set -g @plugin 'jimeh/tmux-themepack'
set -g @themepack 'powerline/default/cyan'

EOF


    echo "# Initalize TMUX plugin manager (keep this line at the very bootom of the tmux.conf file)" >> "/home/${OPTARG}/.tmux.conf"
    echo "# To reload: <C-a>r" >> "/home/${OPTARG}/.tmux.conf"
    echo "# To install plugins: <C-a>I" >> "/home/${OPTARG}/.tmux.conf"
    echo "run /home/${OPTARG}/.tmux/plugins/tpm/tpm" >> "/home/${OPTARG}/.tmux.conf"
}

#################### BEGIN SCRIPT ####################
getopts ':r:' option # This sets the variable OPTARG
install_dependencies
configure_neovim
configure_tmux
chown -R "${OPTARG}:${OPTARG}" "/home/${OPTARG}"
sudo sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
