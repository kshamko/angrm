-module(idtang_loader_worker_sup).

-behaviour(supervisor).

-export([start_link/0, init/1]).
-include("otp_types.hrl").


-spec(start_link() -> {ok, pid()}).
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).


-spec(init(gs_args()) -> sup_init_reply()).
init(_Args) ->
  SupervisorSpecification =
    #{strategy => simple_one_for_one, % one_for_one | one_for_all | rest_for_one | simple_one_for_one
      intensity => 10, % max restarts
      period => 1000 % in period of time
    },

  ChildSpecifications =
    [
      #{id => idtang_loader_worker,
        start => {idtang_loader_worker, start_link, []},
        restart => temporary, % permanent | transient | temporary
        shutdown => 2000, % milliseconds | brutal_kill | infinity
        type => worker, % worker | supervisor
        modules => [idtang_loader_worker]
      }
    ],
  {ok, {SupervisorSpecification, ChildSpecifications}}.