proc_server
=====

A gen_server that creates and registers processes.

Build
-----

    $ rebar3 compile

Getting started
-----

Start three connected distributed Erlang nodes (`node1@127.0.0.1, node2@127.0.0.1, node3@127.0.0.1`):

    $ ./start_nodes
    
Start a hidden node (`bruce@127.0.0.1`) to run the app:

    $ erl -name bruce@127.0.0.1 -hidden -pa ./_build/default/lib/proc_server/ebin -eval "application:load(proc_server), application:start(proc_server)"
 
 ```   
Erlang/OTP 18 [erts-7.1] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Eshell V7.1  (abort with ^G)
(bruce@127.0.0.1)1> nodes().
[]
(bruce@127.0.0.1)2> proc_server:register_name('node1@127.0.0.1', some_name).
yes
(bruce@127.0.0.1)3> proc_server:whereis_name('node2@127.0.0.1', some_name).
<7313.50.0>
(bruce@127.0.0.1)4> proc_server:unregister_name('node3@127.0.0.1', some_name).
ok
(bruce@127.0.0.1)5> proc_server:re_register_name('node3@127.0.0.1', some_name).
yes
(bruce@127.0.0.1)6> proc_server:apply_fun('node1@127.0.0.1', global, registered_names, []).
[some_name]
```

Stop the nodes:

    $ ./stop_nodes
    
