%%%-------------------------------------------------------------------
%%% @author kostik
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Dec 2018 1:42 AM
%%%-------------------------------------------------------------------
-module(idtang_loader_worker).
-behavior(gen_server).

-export([start_link/1, do_process/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("otp_types.hrl").

%%% module API

-spec start_link(term()) -> gs_start_link_reply().
start_link(Words) ->
  gen_server:start_link(?MODULE, [Words], []).

do_process(Pid) ->
  gen_server:cast(Pid, process).


%%% gen_server API

-spec init(gs_args()) -> gs_init_reply().
init([Words]) ->
  lager:log(info, self(), "some_worker started ~p", [Words]),
  {ok, Words}.


-spec handle_call(gs_request(), gs_from(), gs_reply()) -> gs_call_reply().
handle_call({some, _Data}, _From, State) ->
  Reply = ok,
  {reply, Reply, State};

handle_call(_Any, _From, State) ->
  %lager:error("unknown call ~p in ~p ~n", [Any, ?MODULE]),
  {noreply, State}.


-spec handle_cast(gs_request(), gs_state()) -> gs_cast_reply().
handle_cast(process, State) ->

  Words = process_words(State, maps:new()),
  idtang_prompt:add_words(Words),

  {stop, normal, State};
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

process_words([], Result) ->
  Result;
process_words([Word|Words], Result) ->

  %lager:log(info, self(), is_list(Word)),

  %W1 = binary:replace(Word,[<<"\n">>,<<"\r">>],<<"">>, [global]),
  W2 = string:lowercase(Word),
  Key = make_hash(W2),
  R = maps:get(Key, Result, []),
  NewResult = maps:put(make_hash(W2), [Word|R], Result),
  process_words(Words, NewResult).

make_hash(Word) ->
  %Letters = binary_to_list(Word),
  lists:sort(Word).