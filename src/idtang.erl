-module(idtang).

%% API
-export([
  start/0,
  stop/0
]).

-define(APPS, [lager, idtang]).

%% API functions

start() ->
  ok = ensure_started(?APPS).


stop() ->
  ok = stop_apps(lists:reverse(?APPS)).


%% Internal functions

ensure_started([]) ->
  ok;
ensure_started([App | Apps]) ->
  case application:ensure_all_started(App) of
    {ok, _} -> ensure_started(Apps);
    {error, {already_started, App}} -> ensure_started(Apps)
  end.

stop_apps([]) ->
  ok;
stop_apps([App | Apps]) ->
  application:stop(App),
  stop_apps(Apps).