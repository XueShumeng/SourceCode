-module(data_app).

-behaviour(application).

%% Application callbacks
-export([start/2,start/0,stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
    start([],[]).
start(_StartType, _StartArgs) ->
    io:format("application starting~n"),
    case data_sup:start_link() of
        {ok,Pid} ->
            {ok,Pid};
        Other    ->
            {error,Other}
    end.

stop(_State) ->
    ok.
