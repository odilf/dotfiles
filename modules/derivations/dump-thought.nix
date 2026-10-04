{ writeShellScriptBin, python3, ... }:
writeShellScriptBin "dump" ''
  exec ${python3}/bin/python3 ${./dump-thought.py} "$@"
''
