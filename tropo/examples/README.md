Build and test the example
==========================

To build the examples, your first need to build the Tropo application first.
Then, run the following command at the shell:

    % erl -pa ../ebin -make

You are now ready to test your application. Suppose the `mochiweb` library is installed
in $MOCHI_DIR, you run the application by evaluating the following commands at the
Erlang prompt:

    % erl -pa ../ebin -pa $MOCHI_DIR/ebin 
    Erlang R14B (erts-5.8.1) [source] [smp:2:2] [rq:2] [async-threads:0] [hipe] [kernel-poll:false]
    
    Eshell V5.8.1  (abort with ^G)
    1> application:start(tropo).
    ok
    2> helloworld:start_link().
    {ok, <0.42.0>}
    3>

and then in another shell, test your application using curl:

    % curl -X POST http://localhost:8000/helloworld/start.json -d '{"session":{"id":"test"}}'
    {"tropo":[{"say":{"value":"Hello, world!"}},{"on":{"event":"error","next":"hangup.json"}},{"on":{"event":"hangup","next":"hangup.json"}},{"on":{"event":"continue","next":"hangup.json"}}]}
    % curl -X POST http://localhost:8000/helloworld/hangup.json -d '{"result":{"sessionId":"test"}}'
    {"tropo":[{"hangup":null}]}

At the Erlang shell, you should see logging information like

    [INFO] [2011/06/03 11:15:05] Session created: <<"test">>
    [DEBUG] [2011/06/03 11:15:05] [test] Event: {state,<<"answered">>}
    [DEBUG] [2011/06/03 11:15:06] [test] Event: {state,<<"hangup">>}
    [INFO] [2011/06/03 11:15:06] Session deleted: <<"test">>

 
