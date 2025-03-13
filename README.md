Asterisk AGI helper module for Lua
==================================
Copyright © 2017 Robin Leffmann <djinn [at] stolendata.net>

This module provides an easy-to-use class for interacting with the [Asterisk Gateway Interface](https://docs.asterisk.org/Configuration/Interfaces/Asterisk-Gateway-Interface-AGI/).

This is unfinished work which may also be broken in some ways as I don't know squat about writing good Lua code. Requires Lua 5.2, I think.

For syntax and scant documentation see `agi.lua`. For detailed documentation on each AGI command see [Asterisk AGI Commands](https://docs.asterisk.org/Asterisk_18_Documentation/API_Documentation/AGI_Commands/).


Usage example
-------------
```lua
#!/usr/bin/lua

agi = require 'agi'

agi.debug( 'This message appears only on the Asterisk console' )

-- do some things with the AGI environment variables

agi.verbose( 'You are running Asterisk ' .. agi.env['version'] )

for k, v in pairs( agi.env ) do
    agi.verbose( k .. ' -> ' .. v )
end
```


License
-------
Licensed under Creative Commons BY-SA 4.0 - https://creativecommons.org/licenses/by-sa/4.0/
