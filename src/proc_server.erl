-module(proc_server).
-export([start_link/0, stop/0]).
-export([init/1, terminate/2, handle_call/3, handle_cast/2]).
-export([register_name/2, re_register_name/2, unregister_name/2, whereis_name/2, apply_fun/4]).

-behavior(gen_server).

%% Exported Client Functions
%% Operation & Maintenance API

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
  gen_server:cast(?MODULE, stop).

%% Customer Services API

register_name(Node, Name) ->
  gen_server:call({?MODULE, Node}, {register_name, Name}).

re_register_name(Node, Name) ->
  gen_server:call({?MODULE, Node}, {re_register_name, Name}).

unregister_name(Node, Name) ->
  gen_server:call({?MODULE, Node}, {unregister_name, Name}).

whereis_name(Node, Name) ->
  gen_server:call({?MODULE, Node}, {whereis_name, Name}).

apply_fun(Node, Module, Fun, Args) ->
  gen_server:call({?MODULE, Node}, {apply_fun, Module, Fun, Args}).

%% Callback Functions

init(_) ->
  {ok, null}.

terminate(_Reason, _LoopData) ->
  ok.

handle_cast(stop, LoopData) ->
  {stop, normal, LoopData}.

handle_call({register_name, Name}, _From, LoopData) ->
  Reply = global:register_name(Name, spawn(fun() -> receive _ -> ok end end)),
  {reply, Reply, LoopData};

handle_call({re_register_name, Name}, _From, LoopData) ->
  Reply = global:re_register_name(Name, spawn(fun() -> receive _ -> ok end end)),
  {reply, Reply, LoopData};

handle_call({unregister_name, Name}, _From, LoopData) ->
  Reply = global:unregister_name(Name),
  {reply, Reply, LoopData};

handle_call({whereis_name, Name}, _From, LoopData) ->
  Reply = global:whereis_name(Name),
  {reply, Reply, LoopData};

handle_call({apply_fun, Module, Fun, Args}, _From, LoopData) ->
  Reply = erlang:apply(Module, Fun, Args),
  {reply, Reply, LoopData}.