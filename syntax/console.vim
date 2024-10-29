"
syn match CommandLine /^[$] .*$/
syn match ConsoleOutput "^[^$].*$"

hi def link CommandLine Statement
hi def link ConsoleOutput Comment
