%%%-------------------------------------------------------------------
%%% @author kostik
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Dec 2018 1:42 AM
%%%-------------------------------------------------------------------
-module(idtang_prompt).
-behavior(gen_server).

-export([start_link/0, anagramm/0, add_words/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("otp_types.hrl").

%%% module API

-spec start_link() -> gs_start_link_reply().
start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

anagramm() ->
  Term = io:get_line("Type word: "),
  X = gen_server:call(?MODULE, {anagrams, Term}),
  lager:log(info, self(), X),
  anagramm().

add_words(Words) ->
  gen_server:cast(?MODULE, {add_words, Words}).

%%% gen_server API

-spec init(gs_args()) -> gs_init_reply().
init([]) ->
  %lager:info("some_worker started ~p", [self()]),
  {ok, maps:new()}.


-spec handle_call(gs_request(), gs_from(), gs_reply()) -> gs_call_reply().
handle_call({anagrams, Word}, _From, State) ->

  %W1 = binary:replace(Word,[<<"\n">>,<<"\r">>],<<"">>, [global]),
  W2 = string:lowercase(Word),
  Key = make_hash(W2),

  {reply, maps:get(Key, State, []), State};

handle_call(_Any, _From, State) ->
  %lager:error("unknown call ~p in ~p ~n", [Any, ?MODULE]),
  {noreply, State}.


-spec handle_cast(gs_request(), gs_state()) -> gs_cast_reply().
handle_cast({add_words, Words}, State) ->
  {noreply, maps:merge(Words, State)};
handle_cast(_Any, State) ->
  %lager:error("unknown cast ~p in ~p ~n", [Any, ?MODULE]),
  {noreply, State}.


-spec handle_info(gs_request(), gs_state()) -> gs_info_reply().
handle_info(_Request, State) ->
  %lager:error("unknown info ~p in ~p ~n", [Request, ?MODULE]),
  {noreply, State}.


-spec terminate(terminate_reason(), gs_state()) -> ok.
terminate(_Reason, _State) ->
  ok.


-spec code_change(term(), term(), term()) -> gs_code_change_reply().
code_change(_OldVersion, State, _Extra) ->
  {ok, State}.



%%% inner functions
make_hash(Word) ->
  % = binary_to_list(Word),
  lists:sort(Word).