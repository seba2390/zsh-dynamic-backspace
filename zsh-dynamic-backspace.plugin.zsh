# ============================================
# Dynamic Backspace Widget (3-Stage)
# 1st press: Deletes 1 char (Normal backspace)
# 2nd press: Deletes 1 char AND highlights remaining word
# 3rd press: Deletes the highlighted region
# ============================================

# State variable to track which stage we're in (REGION_ACTIVE resets between invocations)
typeset -g _dynamic_backspace_stage=0

# Region highlight color (the selection color when text is highlighted)
# Format: "region:STYLE" where STYLE can be:
#   bg=COLOR         - background color (red, green, yellow, blue, magenta, cyan, white, black)
#   fg=COLOR         - foreground/text color
#   bold, underline  - text styles
#   standout         - reverse video (swaps fg/bg)
# You can combine styles with commas, e.g.: "region:bg=red,fg=white,bold"
# Use 256-color codes with bg=#NNN or fg=#NNN (e.g., bg=#196 for bright red)
zle_highlight=(region:bg=red,fg=white)

function dynamic-backspace() {
    # Reset stage if last widget wasn't this one (user did something else)
    if [[ $LASTWIDGET != "dynamic-backspace" ]]; then
        _dynamic_backspace_stage=0
    fi

    case $_dynamic_backspace_stage in
        2)
            # --- STAGE 3: EXECUTION ---
            # Kill the highlighted region
            zle kill-region
            _dynamic_backspace_stage=0
            ;;
        1)
            # --- STAGE 2: DELETE + HIGHLIGHT ---
            # 1. Perform the normal second deletion
            zle backward-delete-char

            # 2. Check context after deletion
            # If we are now looking at whitespace or empty line, reset and stop
            local prev_char="${LBUFFER: -1}"
            if [[ -z "$prev_char" || "$prev_char" =~ [[:space:]] ]]; then
                _dynamic_backspace_stage=0
                return
            fi

            # 3. Highlight Logic
            # Exclude / and . and - from being considered part of a word (Paths/IPs)
            local WORDCHARS=${WORDCHARS//[\/\.\-]}

            zle set-mark-command
            zle backward-word

            # Safety: If cursor didn't move, abort highlight and reset
            if [[ $CURSOR -eq $MARK ]]; then
                _dynamic_backspace_stage=0
                return
            fi

            zle exchange-point-and-mark
            REGION_ACTIVE=1
            _dynamic_backspace_stage=2
            ;;
        *)
            # --- STAGE 1: NORMAL BACKSPACE ---
            # First press: just delete one char
            zle backward-delete-char
            _dynamic_backspace_stage=1
            ;;
    esac
}

# Register the widget
zle -N dynamic-backspace

# Bind to Backspace keys
bindkey '^?' dynamic-backspace
bindkey '^H' dynamic-backspace

# Ensure compatibility with plugins (force binding in main/viins maps)
bindkey -M viins '^?' dynamic-backspace
bindkey -M viins '^H' dynamic-backspace
