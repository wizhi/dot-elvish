use ./completions
use ./prompt

fn dotfiles [@a]{ git --git-dir=$E:HOME/.dotfiles --work-tree=$E:HOME $@a }

set edit:abbr['||'] = '| less'
