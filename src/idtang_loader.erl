-module(idtang_loader).

-export([load_words/2, make_hash/1]).

load_words(FileName, BatchSize) ->
  {ok, Device} = file:open(FileName, [read]),
  try get_all_lines(Device, BatchSize, [])
    after file:close(Device)
  end.

get_all_lines(Device, BatchSize, Lines) ->
  case io:get_line(Device, "") of
    eof  ->
      {ok, Pid} = supervisor:start_child(idtang_loader_worker_sup, [Lines]),
      idtang_loader_worker:do_process(Pid, true),
      [];
    Line ->
      case erlang:length(Lines) < BatchSize of
        true -> get_all_lines(Device, BatchSize, [Line] ++ Lines);
        false ->
          {ok, Pid} = supervisor:start_child(idtang_loader_worker_sup, [Lines]),
          idtang_loader_worker:do_process(Pid, false),
          get_all_lines(Device, BatchSize, [Line])
      end

  end.

make_hash(Word) ->
  Word1 = string:lowercase(Word),
  lists:sort(Word1).