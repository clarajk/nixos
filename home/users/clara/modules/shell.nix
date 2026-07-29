{
  config,
  lib,
  ...
}: {
  programs = {
    zsh = {
      enable = true;

      enableCompletion = true;

      autosuggestion = {
        enable = true;

        strategy = [
          "history"
          "completion"
        ];
      };

      syntaxHighlighting = {
        enable = true;
      };

      history = {
        path = "${config.xdg.dataHome}/zsh/history";

        size = 100000;
        save = 100000;

        append = true;
        share = true;
        extended = true;

        ignoreDups = true;
        ignoreAllDups = true;
        saveNoDups = true;
        findNoDups = true;
        ignoreSpace = true;
        expireDuplicatesFirst = true;
      };

      historySubstringSearch = {
        enable = true;

        searchUpKey = [
          "^[[A" # Up arrow
          "^P" # Ctrl-P
        ];

        searchDownKey = [
          "^[[B" # Down arrow
          "^N" # Ctrl-N
        ];
      };

      initContent = lib.mkAfter ''
        # Emacs-style line editing.
        bindkey -e

        # Ctrl-Left / Ctrl-Right: move by word.
        bindkey "^[[1;5D" backward-word
        bindkey "^[[1;5C" forward-word

        # Home / End.
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
        bindkey "^[[1~" beginning-of-line
        bindkey "^[[4~" end-of-line
        bindkey "^[[7~" beginning-of-line
        bindkey "^[[8~" end-of-line

        # Delete key.
        bindkey "^[[3~" delete-char

        # Ctrl-Backspace / Ctrl-Delete.
        bindkey "^H" backward-kill-word
        bindkey "^[[3;5~" kill-word

        # Alt-Up / Alt-Down: search history by current text.
        bindkey "^[[1;3A" history-substring-search-up
        bindkey "^[[1;3B" history-substring-search-down
      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd cd"];
    };
  };
}
