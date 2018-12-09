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

-export([start_link/0, anagram/0, add_words/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("otp_types.hrl").

%%% module API

-spec start_link() -> gs_start_link_reply().
start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

anagram() ->
  Term = io:get_line("Type a word: "),

  case Term of
    "exit\n" -> exit;
    _ ->
      Anagrams = gen_server:call(?MODULE, {anagrams, Term}),
      io:format(Anagrams),
      anagram()
  end.

add_words(Words, Complete) ->
  gen_server:cast(?MODULE, {add_words, Words, Complete}).

%%% gen_server API

-spec init(gs_args()) -> gs_init_reply().
init([]) ->
  {ok, maps:new()}.


-spec handle_call(gs_request(), gs_from(), gs_reply()) -> gs_call_reply().
handle_call({anagrams, Word}, _From, State) ->
  Key = idtang_loader:make_hash(Word),
  {reply, maps:get(Key, State, []), State};

handle_call(_Any, _From, State) ->
  {noreply, State}.


-spec handle_cast(gs_request(), gs_state()) -> gs_cast_reply().
handle_cast({add_words, Words, _Complete}, State) ->
  {noreply, maps:merge(Words, State)};

handle_cast(_Any, State) ->
  {noreply, State}.


-spec handle_info(gs_request(), gs_state()) -> gs_info_reply().
handle_info(_Request, State) ->
  {noreply, State}.


-spec terminate(terminate_reason(), gs_state()) -> ok.
terminate(_Reason, _State) ->
  ok.


-spec code_change(term(), term(), term()) -> gs_code_change_reply().
code_change(_OldVersion, State, _Extra) ->
  {ok, State}.

%%% inner functions