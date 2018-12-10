-module(idtang_app).
-behaviour(application).

-export([start/2, stop/1]).

-spec(start(term(), term()) -> {ok, pid()}).
start(_StartType, _StartArgs) ->
  {ok, Pid} = idtang_sup:start_link(),
  idtang_loader:load_words("./priv/words", 20),
  lager:log(info, self(), "idtang_app started"),
  {ok, Pid}.


-spec(stop(term()) -> ok).
stop(_State) ->
  ok.