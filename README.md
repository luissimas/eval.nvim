# Eval.nvim
A simple plugin to run your code in a repl and display it inside neovim.

## Requirements
- Neovim >= 0.5

## Installation
Install with your preferred package manager, the following example uses [packer](https://github.com/wbthomason/packer.nvim):

```lua
use {
  "luissimas/eval.nvim",
  config = function()
    require("eval").setup()
  end
  }
```

## Configuration
The plugin can be configured via the `setup` function, here is an example config with all the defaults:
```lua
require("eval").setup({
  prefix_char = "> ", -- char displayed before the output content
  -- a table with each filetype and its respective command to run code
  filetype = {
    lua = {
      cmd = "lua -e"
    },
    elixir = {
      cmd = "elixir -e"
    },
    javascript = {
      cmd = "node -e"
    }
  }
  })
```

## Usage
Eval exposes the command `Eval`, which can be called in normal or visual mode. When called in visual mode, `Eval` will evaluate the current selected text, when called in normal mode the entire buffer will be evaluated.
