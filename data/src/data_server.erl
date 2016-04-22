-module(data_server).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0]).
-export([config_to_beam/0]).
%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% @doc
%% 将指定目录下的config转换为.beam文件，并加载到内存
%% @end
config_to_beam() ->
    AllConfigName = get_all_config_name(),
    [begin
         config_to_beam(ConfigName)
     end || ConfigName <- AllConfigName].

%% @doc
%% 将指定目录下名为ConfigName的config文件转换为.beam文件，并加载到内存
%% @end
config_to_beam(ConfigName) ->
    case check_syntax(ConfigName) of
        {ok,TermList} ->
            term_to_beam(ConfigName -- ".config",TermList);
        Reason ->
            io:format("check config syntax error:~p~nReason:~p~n",[ConfigName,Reason]),
            {Reason,ConfigName}
    end.

%% @doc
%% @todo 存放config的目录
%% @end
get_config_dir() ->
    {ok,[Dir]} = init:get_argument(con_path),
    io:format("Dir====================~p~n",[Dir]),
%%    code:root_dir() ++ "/config",
    Dir.



%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(Args) ->
    io:format("data_server is initing~n"),
    config_to_beam(),
    {ok, Args}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

term_to_beam(ModuleName,TermList) ->
    Erl = term_to_erl(ModuleName,TermList),
    ModuleName2 = ModuleName++".erl",
    file:write_file(ModuleName2, Erl, [write, binary, {encoding, utf8}]),
    compile:file(ModuleName2),
    ModuleName3 = list_to_atom(ModuleName),
    code:purge(ModuleName3),
    code:load_file(ModuleName3),
    {ok,ModuleName3}.

term_to_erl(ModuleName,TermList) ->
    StrValue = lists:flatten(term_to_erl2(TermList,"")),
    StrList = lists:flatten(io_lib:format("     ~w\n", [TermList])),
    "
     -module(" ++ ModuleName ++ ").
      -export([all/0,get/1]).
  
      all()->"++ StrList ++".
  
      get(Key) ->
        case Key of
          " ++ StrValue ++ "
          _ -> undefined
     end.
 ".

term_to_erl2([],Sum) ->
    Sum;
term_to_erl2([{Key,Value}|Left],Acc) ->
    term_to_erl2(Left,
                 io_lib:format("     ~w -> ~w;\n",[Key,Value]) ++ Acc).

get_all_config_name() ->
    {ok,AllFileName} = file:list_dir(get_config_dir()),
    io:format("AllFileName==============~p~n",[AllFileName]),
    lists:filter(fun(FileName) ->
                         case lists:reverse(FileName) of
                             "gifnoc." ++_ ->
                                 true;
                             _ -> 
                                 false
                          end 
                             end,AllFileName).

check_syntax(ConfigName) ->
    case file:consult(joint_path(ConfigName)) of
        {ok,TermList = [_|_]} ->
            io:format("TermList================~p~n",[TermList]),
            check_format_duplicate(TermList,[]);
        Reason ->
            {error,Reason}
     end.

joint_path(ConfigName) ->
    get_config_dir() ++ "/" ++ ConfigName.

check_format_duplicate([],Acc) ->
    {ok,Acc};
check_format_duplicate([{Key,_Value} = Term|Left],Acc) ->
    case lists:keymember(Key,1,Acc) of
        true ->
            {error,key_duplicate,Key};
        false ->
            check_format_duplicate(Left,[Term|Acc])
    end;
check_format_duplicate([Term|_],_Acc) ->
    {error,format_error,Term}.


