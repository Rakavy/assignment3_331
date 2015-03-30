
%% —----------------------------------------------------------------------
%%                                Facts
%% —----------------------------------------------------------------------



%% Overall Safety Critical Room States (Top Level States)

state(dormant).
state(init).
state(idle).
state(monitoring).
state(‘error_diagnosis’).
state(’safe_shutdown’).


%% States under init state

state(‘boot_hw’).
state(senchk).
state(tchk).
state(pshichk).
state(ready).


%% States under monitoring state

state(monidle).
state(‘regulate_environment’).
state(lockdown).


%% States under lockdown state

state(‘prep_vpurge’).
state(‘alt_psi’).
state(‘alt_temp’).
state(‘risk_assess’).
state(‘safe_status’).


%% States under error_diagnosis state

state(‘error_rcv’).
state(‘applicable_rescue’).
state(‘reset_module_data’).

%% Initial states

initial_state(dormant, null).
initial_state(‘boot_hw’, init).
initial_state(monidle, monitoring.
initial_state(‘prep_vpurge’, lockdown).
initial_state(‘error_rcv’, ‘error_diagnosis’).


%% Superstates

superstate(init,‘boot_hw’).
superstate(init,senchk).
superstate(init,tchk).
superstate(init,pshichk).
superstate(init,ready).

superstate(monitoring,monidle).
superstate(monitoring,‘regulate_environment’).
superstate(monitoring,lockdown).

superstate(lockdown, ‘prep_vpurge’).
superstate(lockdown,‘alt_psi’).
superstate(lockdown,‘alt_temp’).
superstate(lockdown,‘risk_assess’).
superstate(lockdown,‘safe_status’).

state(‘error_diagnosis’,‘error_rcv’).
state(‘error_diagnosis’,‘applicable_rescue’).
state(‘error_diagnosis’,‘reset_module_data’).


%% Transitions within the Top-Level state

transition(dormant, exit, kill, null, null).
transition(dormant, init, start, null, null).
transition(init, idle, ‘init_ok’, null, null).
transition(init, ‘error_diagnosis’, ‘init_crash’, null, ‘init_err_msg’).
transition(idle, monitoring, ‘begin_monitoring’, null, null).
transition(idle, ‘error_diagnosis’, ‘idle_crash’, null, ‘idle_err_msg’).
transition(monitoring, ‘error_diagnosis’, ‘monitor_crash’,’!inlockdown’, ‘moni_err_msg’).
transition(‘error_diagnosis’,init, ‘retry_init’, ‘retry < 3’, ‘retry ++’).
transition(‘error_diagnosis’,idle, ‘idle_rescue’ , null, null).
transition(‘error_diagnosis’,monitoring, ‘moni_rescue’ , null, null).
transition(‘error_diagnosis’,’safe_shutdown’, shutdown , ‘retry >= 3’, null).
transition(‘safe_shutdown’,dormant, sleep , null, null).

%% Transitions within init state

transition(‘boot_hw’, senchk, ‘hw_ok’, null, null).
transition(senchk, tchk, ‘senok’, null, null).
transition(tchk, psichk, ‘t_ok’, null, null).
transition(psichk, ready, ‘psi_ok’, null, null).

%% Transitions within monitoring state

transition(monidle, ‘regulate_environment’, ‘no_contagion’, null, null).
transition(monidle, lockdown, ‘contagion_alert’, null, ‘FACILITY_CRIT_MESG; inlockdown= true’).
transition(‘regulate_environment’, monidle,  ‘after_100ms’, null, null).
transition(lockdown, monidle, ‘purge_succ’, null, ‘inlockdown= false’).

%% Transitions within lockdown state

transition(‘prep_vpurge’, ‘alt_psi’, ‘initiate_purge’, null, ‘lock_doors’).
transition(‘prep_vpurge’, ‘alt_temp’, ‘initiate_purge’, null, ‘lock_doors’).
transition(‘alt_psi’, ‘risk_assess’, ‘psicyc_comp’, null, null).
transition(‘alt_temp’, ‘risk_assess’, ‘tcyc_comp’, null, null).
transition(‘risk_assess’, ‘safe_status’,null, ‘risk < 0.01’ , ‘unlock_doors’).
transition(‘risk_assess’, ‘prep_vpurge’,null, ‘risk >= 0.01’ , null).
transition(‘safe_status’, exit,null, null , null).

%% Transitions within error_diagnosis state

transition(‘error_rcv’,‘applicable_rescue’, null, ‘err_protocol_def’, ‘null).
transition(‘error_rcv’,‘reset_module_data’, null, ‘!err_protocol_def’, ‘null).
transition(‘applicable_rescue’,exit, ‘apply_protocol_rescue’, null, ‘null).
transition(‘reset_module_data’,exit, ‘reset_to_stable’, null, ‘null).



