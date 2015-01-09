#!/bin/sh
# script originally from http://www.cliki.net/rlwrap
BREAK_CHARS="(){}[],^%$#@\"\";''|\\"
RLWRAP=
if [ $TERM == "dumb" ]; then  # slime
  RLWRAP=
else
  RLWRAP="rlwrap --remember --history-filename=$HOME/.sbcl_history --histsize=1000000 -c -b $BREAK_CHARS -f $HOME/.sbcl_completions"
fi
if [ $# -eq 0 ]; then
  exec $RLWRAP sbcl
else # permits #!/usr/bin/env sbcl , but breaks sbcl --help, etc.
  exec sbcl --script $*
fi
