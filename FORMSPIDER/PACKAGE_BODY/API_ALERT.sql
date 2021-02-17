CREATE OR REPLACE EDITIONABLE PACKAGE BODY "FORMSPIDER"."API_ALERT" IS

--edit by admin 1
--edit 2

--webinar edit 1

--edit 100

procedure alertNameNotFound(in_alertName_tx varchar2,in_procedureName_tx varchar2) is
  v_exceptionParameter bdf_exception.tt_exception;
begin  
  v_exceptionParameter(0).value_tx :=in_alertName_tx;
  bdf_exception.setlastexception(in_methodname_tx      =>'api_alert.'||in_procedureName_tx,
                                 in_exceptioncode_tx   =>'e_invalidAlertName',
                                 in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                 in_exceptionParamers_t=> v_exceptionParameter);
  bdf_support.terminateAPIunsuccessfully;
  raise api_exception.e_invalidAlertName ;
end;

procedure show(in_alertName_tx varchar2)is
  v_alert_r bdf_alert_v%rowtype;
pragma autonomous_transaction;
begin
  v_alert_r := bdf_alert_qry.getalert(in_alertName_tx, bdf_support.getCurrentApplication);
  if v_alert_r.bdf_alert_oid is not null then
    v_alert_r := bdf_alert_mng.getinstance(v_alert_r);
    bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.show,
                                    in_objecttype_cd=>bdf_constant.typeAlert,
                                    in_alertins_oid =>v_alert_r.bdf_alertins_oid);
    bdf_windoworder_api.setvisible(v_alert_r.bdf_alertins_oid,'Y','Y');
  else
    alertNameNotFound(in_alertName_tx,'show');
  end if;

  bdf_support.terminateAPIsuccessfully;
  commit; 
end;

function getResponse(in_alertName_tx varchar2) return number is
  v_alert_r bdf_alert_v%rowtype;
  v_response_nr number;
pragma autonomous_transaction;
begin
  v_alert_r := bdf_alert_qry.getalert(in_alertName_tx,bdf_support.getCurrentApplication);
  if v_alert_r.bdf_alert_oid is not null then
    v_alert_r := bdf_alert_mng.getinstance(v_alert_r);
    v_response_nr:= v_alert_r.response_nr;
  else
    alertNameNotFound(in_alertName_tx,'getResponse');   
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_response_nr;
end;

function getLabel(in_alertName_tx varchar2) return varchar2 is
  v_alert_r bdf_alert_v%rowtype;
  v_label_tx varchar2(255);
pragma autonomous_transaction;
begin
  v_alert_r := bdf_alert_qry.getalert(in_alertName_tx,bdf_support.getcurrentapplication);
  if v_alert_r.bdf_alert_oid is not null then 
    v_alert_r := bdf_alert_mng.getinstance(v_alert_r);
    v_label_tx:= v_alert_r.labelins_tx;
  else
    alertNameNotFound(in_alertName_tx,'getLabel');    
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_label_tx;
end;

function getID(in_alertName_tx varchar2) return number is
  v_alert_r bdf_alert_v%rowtype;
  v_alert_oid number;
pragma autonomous_transaction;
begin
  v_alert_r := bdf_alert_qry.getalert(in_alertName_tx,bdf_support.getCurrentApplication);
  if v_alert_r.bdf_alert_oid is not null then
    v_alert_r := bdf_alert_mng.getInstance(v_alert_r);
    v_alert_oid := v_alert_r.bdf_alertins_oid;
  else
    alertNameNotFound(in_alertName_tx,'getID');   
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
   return v_alert_oid;
end;

procedure setLabel(in_alertName_tx varchar2 , in_label_tx varchar2) is
  v_alert_r bdf_alert_v%rowtype;
pragma autonomous_transaction;
begin 
  v_alert_r := bdf_alert_qry.getalert(in_alertName_tx,bdf_support.getcurrentapplication);
  if v_alert_r.bdf_alert_oid is not null then
    v_alert_r := bdf_alert_mng.getinstance(v_alert_r);
    bdf_alertins_api.setlabel(v_alert_r.bdf_alertins_oid,in_label_tx);

    bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.SetLabel,
                                    in_objecttype_cd=>bdf_constant.typeAlert,
                                    in_value_tx     =>in_label_tx,
                                    in_alertins_oid =>v_alert_r.bdf_alertins_oid);  
  else
    alertNameNotFound(in_alertName_tx,'setLabel'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
end;

procedure setTitle(in_alertName_tx varchar2, in_title_tx varchar2) is
  v_alert_r bdf_alert_v%rowtype;
pragma autonomous_transaction;
begin 
  v_alert_r := bdf_alert_qry.getalert(in_alertName_tx,bdf_support.getcurrentapplication);
  if v_alert_r.bdf_alert_oid is not null then
    v_alert_r := bdf_alert_mng.getinstance(v_alert_r);
    bdf_alertins_api.settitle(v_alert_r.bdf_alertins_oid, in_title_tx);

    bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.SetTitle,
                                    in_objecttype_cd=>bdf_constant.typeAlert,
                                    in_value_tx     =>in_title_tx,
                                    in_alertins_oid =>v_alert_r.bdf_alertins_oid);  
  else
    alertNameNotFound(in_alertName_tx,'setTitle'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
end;

function getTitle(in_alertName_tx varchar2) return varchar2 is
  v_alert_r bdf_alert_v%rowtype;
  v_title_tx varchar2(255);
pragma autonomous_transaction;
begin
  v_alert_r := bdf_alert_qry.getalert(in_alertName_tx,bdf_support.getcurrentapplication);
  if v_alert_r.bdf_alert_oid is not null then 
    v_alert_r := bdf_alert_mng.getinstance(v_alert_r);
    v_title_tx:= v_alert_r.titleins_tx;
  else
    alertNameNotFound(in_alertName_tx,'getTitle');    
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_title_tx;
end;

END;