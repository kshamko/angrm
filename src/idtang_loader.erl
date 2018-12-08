-module(idtang_loader).

-export([load_words/2]).

load_words(FileName, BatchSize) ->
  {ok, Device} = file:open(FileName, [read]),
  try get_all_lines(Device, BatchSize, [])
    after file:close(Device)
  end.

get_all_lines(Device, BatchSize, Lines) ->
  case io:get_line(Device, "") of
    eof  -> [];
    Line ->
      lager:log(info, self(), "len ~p ~n", [length(Lines)]),
      case erlang:length(Lines) < BatchSize of
        true -> get_all_lines(Device, BatchSize, [Line] ++ Lines);
        false ->
          lager:log(info, self(), "start worker"),
          {ok, Pid} = supervisor:start_child(idtang_loader_worker_sup, [Lines]),
          idtang_loader_worker:do_process(Pid),
          %supervisor:terminate_child(idtang_loader_worker_sup, Pid),
          get_all_lines(Device, BatchSize, [Line])
      end

  end.
