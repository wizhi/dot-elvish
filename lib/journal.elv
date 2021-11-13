use re
use str

var dir = $E:HOME/journal
var editor = $E:EDITOR

fn -editor [e]{
    if (has-external $e) {
        external $e
    } elif (has-external $E:EDITOR) {
        external $E:EDITOR
    } else {
        fail 'no editor found'
    }
}

fn -today [&create=$true]{
    set path = $dir/(date '+%Y/%m/%d')

    if $create {
        mkdir --parents $path
    }

    put $path
}

fn new [title &editor=$editor]{
    set title = (str:trim-space $title)
    set editor = (-editor $editor)
    set dir = (-today)

    set file = (re:replace " +" "_" $title | str:replace "/" "-" (one) | str:to-lower (one))".md"
    set draft = (mktemp --tmpdir "journal-XXXXXXXXXX-"$file)

    printf "# %s" $title > $draft

    set before = (stat --format "%Y" $draft)

    $editor $draft

    set after = (stat --format "%Y" $draft)

    if (not-eq $before $after) {
        mkdir --parents $dir
        cp $draft $dir/$file
    }

    rm $draft
}

fn meal [summary &kcal=0 &dir=$dir]{
    set path = (-today)/meals
    set metadata = [&time=(date '+%H:%M:%S')]

    if (< 0 $kcal) {
        set metadata[kcal] = (printf "%.2f" $kcal)
    }

    printf "%s | %s\n" $summary (keys $metadata | each [name]{
        put (printf '%s: %s' $name $metadata[$name])
    } | str:join ", " [(all)]) >> $path
}
