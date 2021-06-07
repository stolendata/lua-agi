--[[

  Asterisk AGI helper v0.1

  by Robin Leffmann <djinn [at] stolendata.net>

  https://github.com/stolendata/lua-agi/

  licensed under Creative Commons BY-SA 4.0
  https://creativecommons.org/licenses/by-sa/4.0/

--]]

local m = {}

io.stdin:setvbuf 'line'
io.stdout:setvbuf 'line'
io.stderr:setvbuf 'line'

-- this is dirty
--
local function command( cmd, parse_mode, ... )
    local args = { ... }
    if select( '#', args ) > 0 then table.insert( args, 1, '' ) end -- urgh
    io.write( cmd, table.concat(args, ' '), "\n" )
    local resp = io.read()
    if parse_mode == nil then return
    elseif parse_mode == 1 then
        -- more urgh
        local result, val = resp:match( '^%d+ result= ?(-?%d+)(.*)$' )
        if val ~= nil then val = val:match( '^ ?[(](.*)[)] ?$' ) end
        return result, val
    elseif parse_mode == 2 then return resp end
end

-- writes message to the Asterisk console
--
function m.debug( message )
    io.stderr:write( message, "\n" )
end

-- streams audio file
--
function m.stream_file( audio_file, escape_digits, offset )
    if ( audio_file or '' ) == '' then return end
    if ( escape_digits or '' ) == '' then escape_digits = '""' end
    return command( 'STREAM FILE', 1, audio_file, escape_digits, offset )
end

-- streams audio file with optional timeout
--
function m.get_option( audio_file, escape_digits, timeout )
    if ( audio_file or '' ) == '' then return end
    if ( timeout or '' ) == '' then timeout = 0 end
    return command( 'GET OPTION', 1, audio_file, escape_digits, timeout )
end

-- sets current channel's caller ID (CNID)
--
function m.set_caller_id( number )
    if ( number or '' ) == '' then return end
    command( 'SET CALLERID', nil, number )
end

-- sets channel's destination context upon script exit
--
function m.set_context( context )
    if ( context or '' ) == '' then return end
    command( 'SET CONTEXT', nil, context )
end

-- sets channel's destination extension upon script exit
--
function m.set_extension( exten )
    if ( exten or '' ) == '' then return end
    command( 'SET EXTENSION', nil, exten )
end

-- sets channel's destination priority upon script exit
--
function m.set_priority( prio )
    if ( prio or '' ) == '' then return end
    command( 'SET PRIORITY', nil, prio )
end

-- answers current channel
--
function m.answer()
    command( 'ANSWER' )
end

-- hangs up current or specified channel
--
function m.hangup( channel )
    command( 'HANGUP', nil, channel )
end

-- functionally similar to VERBOSE with level 0
--
function m.noop( message )
    command( 'NOOP', nil, message )
end

-- returns status of current or specified channel
--
function m.channel_status( channel )
    return command( 'CHANNEL STATUS', 1, channel )
end

-- populates the referenced table with all AGI-related channel variables
--
function m.read_channel( table )
    for line in io.lines() do
        if line == '' then break end
        local k, v = line:match( '^agi_(%a+):%s(.*)' )
        if k ~= nil then table[k] = v end
    end
end

-- verbose( [<level>,] <message> )
--
function m.verbose( ... )
    local level, message = ...
    if select( '#', ... ) == 1 then message, level = level, 0 end
    if ( message or '' ) == '' then return end
    command( 'VERBOSE', nil, '"' .. message .. '"', level )
end

-- get_variable( <name> )
--
function m.get_variable( name )
    if ( name or '' ) == '' then return end
    local result, value = command( 'GET VARIABLE', 1, name )
    if result == 1 then return value end
end

-- sends text to channels supporting MESSAGE requests
--
function m.send_text( text )
    if( text or '' ) == '' then return end
    return command( 'SEND TEXT', 1, '"' .. text .. '"' )
end

-- waits for incoming MESSAGE request with timeout
--
function m.receive_text( timeout )
    local resp, text = command( 'RECEIVE TEXT', 1, timeout or 0 )
    if resp == 1 then return text end
end

-- set_variable( <name>, <value> )
--
function m.set_variable( name, value )
    if ( name or '' ) == '' then return end
    command( 'SET VARIABLE', nil, name, value or '' )
end

-- get_data( <audio filename>, <timeout>, <max digits> )
--
function m.get_data( audio_file, timeout, max_digits )
    if ( audio_file or '' ) == '' then return end
    return command( 'GET DATA', 2, audio_file, timeout, max_digits )
end

return m
