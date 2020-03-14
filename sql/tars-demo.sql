
delete from `t_adapter_conf` where `application` = 'Demo';
delete from `t_server_conf` where `application` = 'Demo';

###cpp
replace into `t_adapter_conf` (`application`, `server_name`, `node_name`, `adapter_name`,`registry_timestamp`, `thread_num`, `endpoint`, `max_connections`, `allow_ip`, `servant`, `queuecap`, `queuetimeout`,`posttime`,`lastuser`,`protocol`, `handlegroup`) VALUES ('Demo','CppServer','localip.tars.com','Demo.CppServer.HelloObjAdapter',now(),5,'tcp -h localip.tars.com -t 60000 -p 22000',2000,'','Demo.CppServer.HelloObj',22000,60000,now(),'admin','tars','');

replace into `t_server_conf` (`application`, `server_name`, `node_group`, `node_name`, `registry_timestamp`, `base_path`, `exe_path`, `template_name`, `bak_flag`, `setting_state`, `present_state`, `process_id`, `patch_version`, `patch_time`, `patch_user`, `tars_version`, `posttime`, `lastuser`, `server_type`, `profile`) VALUES ('Demo','CppServer','','localip.tars.com',now(),'','','tars.cpp.default',0,'active','active',0,'2.1.0',now(),'','2.1.0',now(),'admin','tars_cpp','');

###java
replace into `t_adapter_conf` (`application`, `server_name`, `node_name`, `adapter_name`,`registry_timestamp`, `thread_num`, `endpoint`, `max_connections`, `allow_ip`, `servant`, `queuecap`, `queuetimeout`,`posttime`,`lastuser`,`protocol`, `handlegroup`) VALUES ('Demo','JavaServer','localip.tars.com','Demo.JavaServer.HelloObjAdapter',now(),5,'tcp -h localip.tars.com -t 60000 -p 22001',2000,'','Demo.JavaServer.HelloObj',22001,60000,now(),'admin','tars','');

replace into `t_server_conf` (`application`, `server_name`, `node_group`, `node_name`, `registry_timestamp`, `base_path`, `exe_path`, `template_name`, `bak_flag`, `setting_state`, `present_state`, `process_id`, `patch_version`, `patch_time`, `patch_user`, `tars_version`, `posttime`, `lastuser`, `server_type`, `profile`) VALUES ('Demo','JavaServer','','localip.tars.com',now(),'','','tars.tarsjava.default',0,'active','active',0,'2.1.0',now(),'','2.1.0',now(),'admin','tars_java','');


###nodejs
replace into `t_adapter_conf` (`application`, `server_name`, `node_name`, `adapter_name`,`registry_timestamp`, `thread_num`, `endpoint`, `max_connections`, `allow_ip`, `servant`, `queuecap`, `queuetimeout`,`posttime`,`lastuser`,`protocol`, `handlegroup`) VALUES ('Demo','NodejsServer','localip.tars.com','Demo.NodejsServer.HelloObjAdapter',now(),5,'tcp -h localip.tars.com -t 60000 -p 22003',2000,'','Demo.NodejsServer.HelloObj',22003,60000,now(),'admin','tars','');

replace into `t_server_conf` (`application`, `server_name`, `node_group`, `node_name`, `registry_timestamp`, `base_path`, `exe_path`, `template_name`, `bak_flag`, `setting_state`, `present_state`, `process_id`, `patch_version`, `patch_time`, `patch_user`, `tars_version`, `posttime`, `lastuser`, `server_type`, `profile`) VALUES ('Demo','NodejsServer','','localip.tars.com',now(),'','','tars.nodejs.default',0,'active','active',0,'2.1.0',now(),'','2.1.0',now(),'admin','tars_nodejs','');

###go
replace into `t_adapter_conf` (`application`, `server_name`, `node_name`, `adapter_name`,`registry_timestamp`, `thread_num`, `endpoint`, `max_connections`, `allow_ip`, `servant`, `queuecap`, `queuetimeout`,`posttime`,`lastuser`,`protocol`, `handlegroup`) VALUES ('Demo','GoServer','localip.tars.com','Demo.GoServer.HelloObjAdapter',now(),5,'tcp -h localip.tars.com -t 60000 -p 22004',2000,'','Demo.CppServer.HelloObj',22004,60000,now(),'admin','tars','');

replace into `t_server_conf` (`application`, `server_name`, `node_group`, `node_name`, `registry_timestamp`, `base_path`, `exe_path`, `template_name`, `bak_flag`, `setting_state`, `present_state`, `process_id`, `patch_version`, `patch_time`, `patch_user`, `tars_version`, `posttime`, `lastuser`, `server_type`, `profile`) VALUES ('Demo','GoServer','','localip.tars.com',now(),'','','tars.tarsgo.default',0,'active','active',0,'2.1.0',now(),'','2.1.0',now(),'admin','tars_go','');

###php
replace into `t_adapter_conf` (`application`, `server_name`, `node_name`, `adapter_name`,`registry_timestamp`, `thread_num`, `endpoint`, `max_connections`, `allow_ip`, `servant`, `queuecap`, `queuetimeout`,`posttime`,`lastuser`,`protocol`, `handlegroup`) VALUES ('Demo','PhpServer','localip.tars.com','Demo.PhpServer.HelloObjAdapter',now(),5,'tcp -h localip.tars.com -t 60000 -p 22005',2000,'','Demo.PhpServer.HelloObj',22005,60000,now(),'admin','tars','');

replace into `t_server_conf` (`application`, `server_name`, `node_group`, `node_name`, `registry_timestamp`, `base_path`, `exe_path`, `template_name`, `bak_flag`, `setting_state`, `present_state`, `process_id`, `patch_version`, `patch_time`, `patch_user`, `tars_version`, `posttime`, `lastuser`, `server_type`, `profile`) VALUES ('Demo','PhpServer','','localip.tars.com',now(),'','','tars.tarsphp.default',0,'active','active',0,'2.1.0',now(),'','2.1.0',now(),'admin','tars_php','');

