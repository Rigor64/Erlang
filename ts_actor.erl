-module(ts_actor).
-export([
	init/0
]).

% Initializzation function
init() ->
	% Enable trap_exit management
	erlang:process_flag(trap_exit, true),
	
	% Obtain reference for tables
	% Create ETS whitelist
	WhiteListRef = ets:new(whitelist, []),
	% Create ETS space
	TupleSpaceRef = ets:new(space, []),

	% Start server
	server(WhiteListRef, TupleSpaceRef, [])
.

% Real TS Server
server(WL, TS, WaitQueue) ->
	receive
		% Handle whitelist removal
		{'EXIT', Pid, Reason} -> ok, server(WL, TS, WaitQueue);

		% Handle ETS destructive read
		{in, Pid, Pattern} -> ok, server(WL, TS, WaitQueue);
		
		% Handle ETS non-destructive read
		{rd, Pid, Pattern} -> ok, server(WL, TS, WaitQueue);
		
		% Handle ETS write, WaitQueue removal
		{out, Pid, Tuple} -> ok, server(WL, TS, WaitQueue);

		% Wildcard for remove trash messages
		_ -> server(WL, TS, WaitQueue)
	end
.


in_whitelist(Pid, WL) ->
	ok
.