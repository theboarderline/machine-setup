unbind-key -n C-a
set -g prefix2 F12

unbind-key -n C-r
unbind-key -n C-e
unbind -n C-r
unbind -n C-e

# unbind-key -n M-Right
# unbind-key -n M-Left

bind y set-window-option synchronize-panes

# Make splitting panes more intuitive
bind v split-window -h -c "#{pane_current_path}"
bind b split-window -v -c "#{pane_current_path}"

# These bindings allow you to stay in your keyboard's home
# row when moving between panes. Assuming, of course, that
# you've swapped your Ctrl and Caps Lock keys which you should!
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Resize panes using the home row too!
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Make copy/paste same as vim
bind Escape copy-mode
unbind p
bind p paste-buffer
bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
bind-key -T copy-mode-vi 'y' send-keys -X copy-selection-and-cancel

unbind-key -n C-s
unbind-key -n C-a
set -g prefix ^A
set -g prefix2 F12
bind a send-prefix
