# ============================================
# Dynamic Backspace Widget (Configurable Multi-Stage)
# Configurable: Set how many chars to delete before highlighting
# Stage 1-N: Deletes chars one at a time (Normal backspace)
# Stage N+1: Deletes 1 char AND highlights remaining word
# Stage N+2: Deletes the highlighted region
# ============================================

# USER CONFIGURATION: Set the number of deletions before highlighting triggers
# Change this value to control when the word highlighting activates:
#   1 = highlight after 1st deletion (original 2-stage behavior)
#   2 = highlight after 2nd deletion (original 3-stage behavior)
#   3 = highlight after 3rd deletion, etc.
typeset -g DYNAMIC_BACKSPACE_THRESHOLD=3

# State variable to track deletion count
typeset -g _dynamic_backspace_count=0

# Region highlight color (the selection color when text is highlighted)
# Format: "region:STYLE" where STYLE can be:
#   bg=COLOR         - background color (red, green, yellow, blue, magenta, cyan, white, black)
#   fg=COLOR         - foreground/text color
#   bold, underline  - text styles
#   standout         - reverse video (swaps fg/bg)
# You can combine styles with commas, e.g.: "region:bg=red,fg=white,bold"
# Use 256-color codes with bg=#NNN or fg=#NNN (e.g., bg=#196 for bright red)
zle_highlight=(region:bg=blue,fg=white)

function dynamic-backspace() {
    # Reset count if last widget wasn't ours or an autosuggest wrapper
    # (zsh-autosuggestions runs widgets like autosuggest-* after each keypress)
    if [[ $LASTWIDGET != "dynamic-backspace" && $LASTWIDGET != autosuggest-* ]]; then
        _dynamic_backspace_count=0
    fi

    # Check if we're in the "delete highlighted region" stage
    if (( _dynamic_backspace_count > DYNAMIC_BACKSPACE_THRESHOLD )); then
        # --- FINAL STAGE: DELETE HIGHLIGHTED REGION ---
        zle kill-region
        _dynamic_backspace_count=0
        return
    fi

    # Store the character before deletion for context checking
    local prev_char="${LBUFFER: -1}"

    # Perform the deletion
    zle backward-delete-char

    # Only increment count if we deleted a non-whitespace character
    if [[ -n "$prev_char" && ! "$prev_char" =~ [[:space:]] ]]; then
        (( _dynamic_backspace_count++ ))
    else
        # Reset if we hit whitespace
        _dynamic_backspace_count=0
        return
    fi

    # Check if we've reached the threshold to trigger highlighting
    if (( _dynamic_backspace_count == DYNAMIC_BACKSPACE_THRESHOLD )); then
        # --- HIGHLIGHT STAGE ---
        # Check context after deletion
        # If we are now looking at whitespace or empty line, reset and stop
        local char_after_deletion="${LBUFFER: -1}"
        if [[ -z "$char_after_deletion" || "$char_after_deletion" =~ [[:space:]] ]]; then
            _dynamic_backspace_count=0
            return
        fi

        # Highlight Logic
        # Exclude / and . and - from being considered part of a word (Paths/IPs)
        local WORDCHARS=${WORDCHARS//[\/\.\-]}

        zle set-mark-command
        zle backward-word

        # Safety: If cursor didn't move, abort highlight and reset
        if [[ $CURSOR -eq $MARK ]]; then
            _dynamic_backspace_count=0
            return
        fi

        zle exchange-point-and-mark
        REGION_ACTIVE=1
        (( _dynamic_backspace_count++ ))
    fi
}

# Register the widget
zle -N dynamic-backspace

# Bind to Backspace keys
bindkey '^?' dynamic-backspace
bindkey '^H' dynamic-backspace

# Ensure compatibility with plugins (force binding in main/viins maps)
bindkey -M viins '^?' dynamic-backspace
bindkey -M viins '^H' dynamic-backspace

bindkey -M viins '^H' dynamic-backspace
