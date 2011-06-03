%%% File    : helloworld.erl
%%% Author  : Dominique Boucher <>
%%% Description : Tropo webapi example
%%% Created : 23 May 2011 by Dominique Boucher <>

-module(helloworld).


-behaviour(gen_tropo).
-include("tropo.hrl").

-export([start_link/0, init/1, handle_result/3, terminate/1]).


%% Starts the tropo application server.
%% The Tropo application must be configured to request voice documents
%% from this URL:
%%   http://yourhostname:8000/helloworld/start.json
start_link() ->
    gen_tropo:start_link("127.0.0.1", 8000).


%% Initializes a tropo session with the session data.
%% The session state is 'none' as we don't need any state.
init(_TropoSession) ->
    {ok, init}.

%% Handles the initial request from Tropo.
handle_result(Tropo, ["start.json"], _State) ->
    %% Create the Tropo actions.
    Actions = [tropo:say(<<"Hello, world!">>, []),
               tropo:on(error, "hangup.json"),
               tropo:on(hangup, "hangup.json"),
               tropo:on(continue,"hangup.json")],

    %% Obtain the tropo_session record for the current session. 
    %% See tropo/include/tropo.hrl for a list of all fields
    %% Call Tropo:get(result) to obtain the current result (as 
    %% sent by Tropo). Value is 'initial' on first request
    %% (i.e. when Tropo posts the first request to the application).
    Session = Tropo:get(session),

    %% Generate an event. First arg should be the session id, while the second is
    %% any Erlang term.
    tropo_event:event(Session#tropo_session.session_id, {state, <<"answered">>}),
    
    %% Do the actions, then wait for a maximum of 15 seconds before 
    %% automatically terminating the session.
    {actions, Actions, answered, 15 * 1000};

%% Handles the hangup request.
handle_result(Tropo, ["hangup.json"], _State) ->
    Session = Tropo:get(session),
    tropo_event:event(Session#tropo_session.session_id, {state, <<"hangup">>}),

    %% Stop the session after playing the prompt. This will automatically
    %% call 'hangup' on the Tropo side.
    {stop, []}.
    
    
terminate(_State) ->
    ok.





