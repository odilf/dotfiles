{ ... }: {
  home-manager.sharedModules = [
    {
      programs.delta.options = {
        # ANSI colors follow the terminal palette, light and dark
        syntax-theme = "base16";
        features = "line-numbers navigate hyperlinks";
        # underline file/hunk headers instead of the default box
        file-style = "bold blue";
        file-decoration-style = "blue ul";
        hunk-header-decoration-style = "blue ul";
        # bright-white-on-tint: a syntax-colored word on the green/red tint is unreadable
        plus-emph-style = "bold brightwhite #006020";
        minus-emph-style = "bold brightwhite #901011";
        line-numbers-left-style = "brightblack";
        line-numbers-right-style = "brightblack";
        line-numbers-zero-style = "brightblack";
        line-numbers-minus-style = "red";
        line-numbers-plus-style = "green";
      };
    }
  ];
}
