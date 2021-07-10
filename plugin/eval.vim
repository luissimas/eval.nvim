" Only loads file on nvim-0.5
if !has('nvim-0.5')
  echom "Eval requires Neovim >= 0.5"
  finish
endif

command! -range=% Eval lua require("eval").eval(<line1>, <line2>)
