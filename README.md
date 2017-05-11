Asterisk AGI helper module for Lua
==================================
Copyright © 2017 Robin Leffmann <djinn [at] stolendata.net>

This module provides an easy-to-use class for interacting with the [Asterisk Gateway Interface](https://wiki.asterisk.org/wiki/pages/viewpage.action?pageId=32375589).

This is unfinished work which may also be broken in some ways as I don't know squat about writing good Lua code. Requires Lua 5.2, I think.

For syntax and scant documentation see `agi.lua`. For detailed documentation on each AGI command see [Asterisk AGI Commands](https://wiki.asterisk.org/wiki/display/AST/Asterisk+18+AGI+Commands).


Usage example
-------------
```lua
#!/usr/bin/lua

agi = require 'agi'

chan_vars = {}
agi.read_channel( chan_vars )

for k, v in pairs( chan_vars ) do
    agi.verbose( k .. ' -> ' .. v )
end

agi.debug( 'This message appears only on the Asterisk console' )
```


License
-------
Licensed under Creative Commons BY-SA 4.0 - https://creativecommons.org/licenses/by-sa/4.0/
