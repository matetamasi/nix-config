{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      ignoreAllDups = true;
      ignoreSpace = false;
      save = 100000000;
      size = 1000000000;
    };
    autosuggestion.enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;

    syntaxHighlighting.enable = true;
    initExtraFirst = ''
        zstyle ':completion:*' completer _expand _complete _ignored _match
        zstyle ':completion:*' completions '_expand'
        zstyle ':completion:*' expand prefix
        zstyle ':completion:*' glob '_expand'
        zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*'
        zstyle ':completion:*' max-errors 1
        zstyle ':completion:*' menu select=2
        zstyle ':completion:*' original false
        zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s%1
        zstyle ':completion:*' group-name ""
        
        setopt ALWAYS_LAST_PROMPT
        setopt NO_BEEP
        setopt COMPLETE_IN_WORD
        setopt CHASE_LINKS
        setopt GLOB_DOTS
        # Always moves cursor to end after completion
        setopt ALWAYS_TO_END
        # Set, when the completion is ambiguous you get a list without having to type ^D
        setopt AUTO_LIST
        # If on - the string on the command line exactly matches one of the possible completions, it is accepted, even if there is another completion (i.e. that string with something else added)
        setopt NO_REC_EXACT
        # If on - one completion is always inserted completely, then when you hit TAB it changes to the next, and so on until you get back to where you started
        setopt NO_MENU_COMPLETE
        # This is modified so that nothing is listed if there is an unambiguous prefix or suffix to be inserted
        #setopt LIST_AMBIGUOUS
        # If on - only get the menu behaviour when you hit TAB again on the ambiguous completion
        setopt AUTO_MENU
        
        # Expand aliases
        setopt ALIASES
        
        zstyle ':completion:*' rehash true

        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        bindkey "''${key[Up]}" history-substring-search-up
        bindkey "''${key[Down]}" history-substring-search-down
    zle -N history-substring-search-up
    zle -N history-substring-search-down

    zmodload zsh/complist
        bindkey -M menuselect '^[[Z' reverse-menu-complete
      '';
    oh-my-zsh = {
      plugins = [
        "zsh-syntax-highlighting"
    "zsh-history-substring-search"
      ];
    };
  };
}
