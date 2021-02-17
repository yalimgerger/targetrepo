CREATE OR REPLACE EDITIONABLE PACKAGE BODY "FORMSPIDER"."API_ACCORDIONPANEL" IS

--edit 1
--edit 2
--featureA
--edit 3
--edit 4
--edit 5
--edit 6d
--edit 7
--edit 8
--edit 9
--edit 10

--webinar edit 1

--edit 100


procedure invalidPanelType(in_accordionPanelName_tx varchar2, in_procedureName_tx varchar2) is  
  v_exceptionParameter bdf_exception.tt_exception;
begin       
  v_exceptionParameter(0).value_tx :=in_accordionPanelName_tx;
  v_exceptionParameter(1).value_tx :='accordion panel';
  bdf_exception.setlastexception(in_methodname_tx      =>'api_accordionPanel.'||in_procedureName_tx,
                                 in_exceptioncode_tx   =>'e_invalidPanelType',
                                 in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                 in_exceptionParamers_t=> v_exceptionParameter);
  bdf_support.terminateAPIunsuccessfully;
  raise api_exception.e_invalidPanelType ;
end;

procedure accordionPanelNameNotFound(in_accordionPanelName_tx varchar2,in_procedureName_tx varchar2) is
  v_exceptionParameter bdf_exception.tt_exception;
begin
  v_exceptionParameter(0).value_tx :=in_accordionPanelName_tx;
  bdf_exception.setlastexception(in_methodname_tx      =>'api_accordionPanel.'||in_procedureName_tx,
                                 in_exceptioncode_tx   =>'e_invalidAccordionPanelName',
                                 in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                 in_exceptionParamers_t=> v_exceptionParameter);
  bdf_support.terminateAPIunsuccessfully;
  raise api_exception.e_invalidAccordionPanelName ;
end;

procedure panelNameNotFound(in_panelName_tx varchar2, in_procedureName_tx varchar2) is  
  v_exceptionParameter bdf_exception.tt_exception;
begin  
  v_exceptionParameter(0).value_tx :=in_panelName_tx;
  bdf_exception.setlastexception(in_methodname_tx      =>'api_accordionPanel.'||in_procedureName_tx,
                                 in_exceptioncode_tx   =>'e_invalidPanelName',
                                 in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                 in_exceptionParamers_t=> v_exceptionParameter);
  bdf_support.terminateAPIunsuccessfully;
  raise api_exception.e_invalidPanelName ;  
end;

procedure accordionNameNotFound(in_accordionName_tx varchar2,in_procedureName_tx varchar2) is
  v_exceptionParameter bdf_exception.tt_exception;
begin
  v_exceptionParameter(0).value_tx :=in_accordionName_tx;
  bdf_exception.setlastexception(in_methodname_tx      =>'api_accordionPanel.'||in_procedureName_tx,
                                 in_exceptioncode_tx   =>'e_invalidAccordionName',
                                 in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                 in_exceptionParamers_t=> v_exceptionParameter);
  bdf_support.terminateAPIunsuccessfully;
  raise api_exception.e_invalidAccordionName ; 
end;

procedure invalidInputParameter(in_inputParameter_tx varchar2,in_parameterName_tx varchar2,in_expectedValue_tx varchar2, in_procedureName_tx varchar2) is
  v_exceptionParameter bdf_exception.tt_exception;
begin
  v_exceptionParameter(0).value_tx :=in_parameterName_tx;
  v_exceptionParameter(1).value_tx :=in_inputParameter_tx;
  v_exceptionParameter(2).value_tx :=in_expectedValue_tx;  
  bdf_exception.setlastexception(in_methodname_tx      =>'api_accordionPanel.'||in_procedureName_tx ,
                                 in_exceptioncode_tx   =>'e_invalidInputParameter',
                                 in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                 in_exceptionParamers_t=> v_exceptionParameter);
  bdf_support.terminateAPIunsuccessfully;
  raise api_exception.e_invalidInputParameter ; 
end;

procedure accordionOrderExists(in_order_nr number ,in_procedureName_tx varchar2) is
  v_exceptionParameter bdf_exception.tt_exception;
begin
  v_exceptionParameter(0).value_tx :=in_order_nr;
  bdf_exception.setlastexception(in_methodname_tx      =>'api_accordionPanel.'||in_procedureName_tx,
                                 in_exceptioncode_tx   =>'e_accordionOrderExists',
                                 in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                 in_exceptionParamers_t=> v_exceptionParameter);
  bdf_support.terminateAPIunsuccessfully;
  raise api_exception.e_accordionOrderExists ;  
end;

procedure recursivePanelInclusion(in_subpanelname_tx varchar2, in_parentpanelname_tx varchar2, in_procedureName_tx varchar2) is
  v_exceptionParameter bdf_exception.tt_exception;
begin
  v_exceptionParameter(0).value_tx :=in_subpanelname_tx;
  v_exceptionParameter(1).value_tx :=in_parentpanelname_tx;
  bdf_exception.setlastexception(in_methodname_tx      =>'api_accordionPanel.'||in_procedureName_tx,
                                 in_exceptioncode_tx   =>'e_recursivePanelInclusion',
                                 in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                 in_exceptionParamers_t=>v_exceptionParameter);
  bdf_support.terminateAPIunsuccessfully;
  raise api_exception.e_recursivePanelInclusion;
end;

procedure expandAccordion(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2) is
  v_accordionPanel_r bdf_panel_v%rowtype;  
pragma autonomous_transaction; 
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then                 
      bdf_accordionpanel_mng.expand(v_accordionPanel_r,in_accordionname_tx);
    else 
      invalidPanelType(in_accordionPanelName_tx,'expandAccordion');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'expandAccordion'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception 
  when bdf_accordionpanel_mng.e_invalidaccordionName then
    accordionNameNotFound(in_accordionName_tx,'expandAccordion');
end;

procedure collapseAccordion(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2) is
  v_accordionPanel_r bdf_panel_v%rowtype;  
pragma autonomous_transaction;  
begin 
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then             

      bdf_accordionpanel_mng.collapse(v_accordionPanel_r,in_accordionname_tx);
    else 
      invalidPanelType(in_accordionPanelName_tx,'collapseAccordion');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'collapseAccordion'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when bdf_accordionpanel_mng.e_invalidaccordionName then
    accordionNameNotFound(in_accordionName_tx,'collapseAccordion');
end;

function getAccordionState(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2) return varchar2 is
  v_accordionPanel_r    bdf_panel_v%rowtype;
  v_state_yn             varchar2(1);      
  v_paneldtlins_r       t_bdf_paneldtlins%rowtype;
  v_state_cd            varchar2(200);
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then     

      v_paneldtlins_r := bdf_paneldtlins_qry.getpaneldtlins(v_accordionPanel_r.bdf_panelins_oid,in_accordionName_tx);  
      if v_paneldtlins_r.bdf_paneldtlins_oid is not null then
        v_state_yn := v_paneldtlins_r.expanded_yn;
        if v_state_yn = 'Y' then          
          v_state_cd := expanded; 
        else
          v_state_cd := collapsed; 
        end if; 
      else 
        accordionNameNotFound(in_accordionName_tx,'getAccordionState');        
      end if;         

    else 
      invalidPanelType(in_accordionPanelName_tx,'getAccordionState');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'getAccordionState'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_state_cd;
end;

function getAccordionTitle(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2) return varchar2 is
  v_accordionPanel_r bdf_panel_v%rowtype;
  v_title_tx        varchar2(255); 
  v_paneldtlins_r     t_bdf_paneldtlins%rowtype;  
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then     

      v_paneldtlins_r := bdf_paneldtlins_qry.getpaneldtlins(v_accordionPanel_r.bdf_panelins_oid,in_accordionName_tx);  
      if v_paneldtlins_r.bdf_paneldtlins_oid is not null then
        v_title_tx := v_paneldtlins_r.label_tx;
      else 
        accordionNameNotFound(in_accordionName_tx,'getAccordionTitle');
      end if;          

    else 
      invalidPanelType(in_accordionPanelName_tx,'getAccordionTitle');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'getAccordionTitle'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_title_tx;
end;

procedure setAccordionTitle(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2,in_title_tx varchar2) is
  v_accordionPanel_r bdf_panel_v%rowtype;
pragma autonomous_transaction;   
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then

      bdf_accordionpanel_mng.setaccordiontitle(v_accordionPanel_r.bdf_panelins_oid,in_accordionname_tx,in_title_tx);
    else 
      invalidPanelType(in_accordionPanelName_tx,'setAccordionTitle');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'setAccordionTitle'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when bdf_accordionpanel_mng.e_invalidaccordionName then
    accordionNameNotFound(in_accordionName_tx,'setAccordionTitle');
end;

procedure setAccordionEnable(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2,in_enabled_yn varchar2) is
  v_accordionPanel_r bdf_panel_v%rowtype;
  e_InvalidInputParameter exception;

pragma autonomous_transaction;    
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then  
      bdf_accordionpanel_mng.setaccordionenabledyn(v_accordionPanel_r.bdf_panelins_oid,in_accordionname_tx,in_enabled_yn);
    else 
      invalidPanelType(in_accordionPanelName_tx,'setAccordionEnable');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'setAccordionEnable'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when e_InvalidInputParameter then
    invalidInputParameter(in_enabled_yn,'enabled','"Y" or "N"','setAccordionEnable'); 
  when bdf_accordionpanel_mng.e_invalidaccordionName then
    accordionNameNotFound(in_accordionName_tx,'setAccordionEnable'); 
end;

function isAccordionEnabled(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2) return varchar2 is
  v_accordionPanel_r    bdf_panel_v%rowtype;
  v_isAccordionEnabled_ynf        varchar2(8);     
  v_paneldtlins_r       t_bdf_paneldtlins%rowtype;
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then  

      v_paneldtlins_r := bdf_paneldtlins_qry.getpaneldtlins(v_accordionPanel_r.bdf_panelins_oid,in_accordionName_tx);  
      if v_paneldtlins_r.bdf_paneldtlins_oid is not null then
        v_isAccordionEnabled_ynf := v_paneldtlins_r.enabled_yn;
        if v_isAccordionEnabled_ynf = 'NF' then
          v_isAccordionEnabled_ynf := 'N';
        end if;
      else 
        accordionNameNotFound(in_accordionName_tx,'isAccordionEnabled');      
      end if;         
    else 
      invalidPanelType(in_accordionPanelName_tx,'isAccordionEnabled');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'isAccordionEnabled'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_isAccordionEnabled_ynf;
end;

procedure addAccordion(in_accordionPanelName_tx varchar2,in_order_nr number, in_accordionName_tx varchar2,
                       in_title_tx varchar2,in_panelName_tx varchar2) is

  v_accordionPanel_r bdf_panel_v%rowtype;
  v_subpanel_r bdf_panel_v%rowtype;
pragma autonomous_transaction;   
begin

  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then            


      v_subpanel_r := bdf_panel_qry.getpanel(in_panelName_tx,bdf_support.getcurrentapplication);  
      if v_subpanel_r.bdf_panel_oid is not null then

        if bdf_panelins_qry.isRecursivePanelInclusion(v_subpanel_r.bdf_panel_oid, v_accordionpanel_r.bdf_panel_oid) = 'N' then
          bdf_accordionpanel_mng.addaccordion(v_accordionpanel_r,in_accordionname_tx,in_order_nr,in_title_tx,v_subpanel_r);
        else
          recursivePanelInclusion(v_subPanel_r.name_tx, v_accordionpanel_r.name_tx, 'addAccordion');
        end if;
      else
        panelNameNotFound(in_panelName_tx,'addAccordion');
      end if;            

    else 
      invalidPanelType(in_accordionPanelName_tx,'addAccordion');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'addAccordion'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when bdf_accordionpanel_mng.e_invalidaccordionName then
    accordionNameNotFound(in_accordionName_tx,'setAccordionOrder');
  when bdf_accordionpanel_mng.e_invalidAccordionOrder then
    bdf_support.terminateAPIunsuccessfully;
    raise api_exception.e_invalidAccordionOrder; 
  when bdf_accordionpanel_mng.e_accordionOrderExists then
    accordionOrderExists(in_order_nr,'addAccordion');
  when bdf_accordionpanel_mng.e_nullAccordionOrder then
    bdf_support.terminateAPIunsuccessfully;
    raise api_exception.e_nullAccordionOrder;
  when bdf_accordionpanel_mng.e_nullAccordionName then
    bdf_support.terminateAPIunsuccessfully;
    raise api_exception.e_nullAccordionName;  
  when bdf_accordionpanel_mng.e_accordionNameExists then
    bdf_support.terminateAPIunsuccessfully;
    raise api_exception.e_accordionNameExists;
end;

procedure removeAccordion(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2) is
  v_accordionPanel_r bdf_panel_v%rowtype;
pragma autonomous_transaction;   
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then      
      bdf_accordionpanel_mng.removeaccordion(v_accordionpanel_r,in_accordionname_tx); 
    else 
      invalidPanelType(in_accordionPanelName_tx,'removeAccordion');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'removeAccordion'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when bdf_accordionpanel_mng.e_invalidaccordionName then
    accordionNameNotFound(in_accordionName_tx,'removeAccordion');
end;

procedure removeAllAccordions(in_accordionPanelName_tx varchar2) is
  v_accordionPanel_r bdf_panel_v%rowtype;
pragma autonomous_transaction;   
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then      
      bdf_accordionpanel_mng.removeallaccordion(v_accordionPanel_r.bdf_panelins_oid); 
    else 
      invalidPanelType(in_accordionPanelName_tx,'removeAllAccordions');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'removeAllAccordions'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
end;

procedure setAccordionPanel(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2, in_panelName_tx varchar2) is
  v_accordionPanel_r bdf_panel_v%rowtype;
  v_panel_r bdf_panel_v%rowtype;
pragma autonomous_transaction;   
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then

      v_panel_r := bdf_panel_qry.getpanel(in_panelname_tx,bdf_support.getcurrentapplication);
      if v_panel_r.bdf_panel_oid is not null then

        if bdf_panelins_qry.isRecursivePanelInclusion(v_panel_r.bdf_panel_oid, v_accordionpanel_r.bdf_panel_oid) = 'N' then
          bdf_accordionpanel_mng.setaccordionpanel(v_accordionpanel_r,in_accordionname_tx,v_panel_r);
        else
          recursivePanelInclusion(v_panel_r.name_tx, v_accordionpanel_r.name_tx, 'setAccordionPanel');
        end if;
      else
        panelNameNotFound(in_panelName_tx,'setAccordionPanel');
      end if;       
    else 
      invalidPanelType(in_accordionPanelName_tx,'setAccordionPanel');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'setAccordionPanel'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when bdf_accordionpanel_mng.e_invalidaccordionName then
    accordionNameNotFound(in_accordionName_tx,'setAccordionPanel');
end;

procedure setAccordionHeaderBGColor(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2, in_backgroundcolor_cd varchar2) is
  v_accordionPanel_r bdf_panel_v%rowtype;
  v_exceptionParameter  bdf_exception.tt_exception;
pragma autonomous_transaction;   
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then

      bdf_support.validatecolor(in_backgroundcolor_cd);
      bdf_accordionpanel_mng.setaccordionheaderbgcolor(v_accordionpanel_r.bdf_panelins_oid,in_accordionname_tx,in_backgroundcolor_cd);

    else 
      invalidPanelType(in_accordionPanelName_tx,'setAccordionHeaderBGColor');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'setAccordionHeaderBGColor'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when bdf_accordionpanel_mng.e_invalidaccordionName then
    accordionNameNotFound(in_accordionName_tx,'setAccordionHeaderBGColor');
  when bdf_support.e_invalidColorName then
    v_exceptionParameter(0).value_tx := 'name';
    v_exceptionParameter(1).value_tx := in_backgroundcolor_cd;
    bdf_exception.setlastexception(in_methodname_tx      =>'api_accordionpanel.setAccordionHeaderBGColor',
                                   in_exceptioncode_tx   =>'e_invalidColor',
                                   in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                   in_exceptionParamers_t=> v_exceptionParameter);
    bdf_support.terminateAPIunsuccessfully;
    raise api_exception.e_invalidColor;
  when bdf_support.e_invalidColorHEXValue then
    v_exceptionParameter(0).value_tx := 'hexadecimal code';
    v_exceptionParameter(1).value_tx := in_backgroundcolor_cd;
    bdf_exception.setlastexception(in_methodname_tx      =>'api_accordionpanel.setAccordionHeaderBGColor',
                                   in_exceptioncode_tx   =>'e_invalidColor',
                                   in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                   in_exceptionParamers_t=> v_exceptionParameter);
    bdf_support.terminateAPIunsuccessfully;
    raise api_exception.e_invalidColor;
end;

function getAccordionHeaderBGColor(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2) return varchar2 is
  v_accordionPanel_r bdf_panel_v%rowtype;
  v_backgrouncolour_cd   varchar2(200);    
  v_paneldtlins_r         t_bdf_paneldtlins%rowtype;
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then     


      v_paneldtlins_r := bdf_paneldtlins_qry.getpaneldtlins(v_accordionPanel_r.bdf_panelins_oid,in_accordionName_tx);  
      if v_paneldtlins_r.bdf_paneldtlins_oid is not null then
        v_backgrouncolour_cd := v_paneldtlins_r.backgroundcolour_cd;
      else 
        accordionNameNotFound(in_accordionName_tx,'getAccordionHeaderBGColor');      
      end if;  
    else 
      invalidPanelType(in_accordionPanelName_tx,'getAccordionHeaderBGColor');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'getAccordionHeaderBGColor'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_backgrouncolour_cd;
end;

procedure setAccordionHeaderHeight(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2, in_headerheight_nr number) is
  v_accordionPanel_r bdf_panel_v%rowtype;
pragma autonomous_transaction;   
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then             

      bdf_accordionpanel_mng.setaccordionheaderheight(v_accordionpanel_r.bdf_panelins_oid,in_accordionname_tx,in_headerheight_nr);

    else 
      invalidPanelType(in_accordionPanelName_tx,'setAccordionHeaderHeight');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'setAccordionHeaderHeight'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when bdf_accordionpanel_mng.e_invalidaccordionName then
    accordionNameNotFound(in_accordionName_tx,'setAccordionHeaderHeight');
end;

function getAccordionHeaderHeight(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2) return number is
  v_accordionPanel_r bdf_panel_v%rowtype;
  v_headerHeight_nr   number;     
  v_paneldtlins_r         t_bdf_paneldtlins%rowtype;
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then     

      v_paneldtlins_r := bdf_paneldtlins_qry.getpaneldtlins(v_accordionPanel_r.bdf_panelins_oid,in_accordionName_tx);  
      if v_paneldtlins_r.bdf_paneldtlins_oid is not null then
        v_headerHeight_nr := v_paneldtlins_r.headerheight_nr;
      else 
        accordionNameNotFound(in_accordionName_tx,'getAccordionHeaderHeight');       
      end if;       
    else 
      invalidPanelType(in_accordionPanelName_tx,'getAccordionHeaderHeight');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'getAccordionHeaderHeight'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_headerHeight_nr;
end;

procedure setAccordionHeaderVisible(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2, in_headervisible_yn varchar2) is
  v_accordionPanel_r bdf_panel_v%rowtype;
  e_InvalidInputParameter exception;

pragma autonomous_transaction;   
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then             
      bdf_accordionpanel_mng.setaccordionheadervisble(v_accordionpanel_r.bdf_panelins_oid,in_accordionname_tx,in_headervisible_yn);
    else 
      invalidPanelType(in_accordionPanelName_tx,'setAccordionHeaderVisble');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'setAccordionHeaderVisble'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when e_InvalidInputParameter then
    invalidInputParameter(in_headervisible_yn,'header visible','"Y" or "N"','setAccordionHeaderVisible'); 
  when bdf_accordionpanel_mng.e_invalidaccordionName then
    accordionNameNotFound(in_accordionName_tx,'setAccordionHeaderVisible');
end;

function isAccordionHeaderVisible(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2) return varchar2 is
  v_accordionPanel_r bdf_panel_v%rowtype;
  v_headerVisible_yn  varchar2(1);      
  v_paneldtlins_r         t_bdf_paneldtlins%rowtype;
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then     

      v_paneldtlins_r := bdf_paneldtlins_qry.getpaneldtlins(v_accordionPanel_r.bdf_panelins_oid,in_accordionName_tx);  
      if v_paneldtlins_r.bdf_paneldtlins_oid is not null then
        v_headerVisible_yn := v_paneldtlins_r.headervisible_yn;
      else 
        accordionNameNotFound(in_accordionName_tx,'isAccordionHeaderVisible');      
      end if;     
    else 
      invalidPanelType(in_accordionPanelName_tx,'isAccordionHeaderVisible');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'isAccordionHeaderVisible'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_headerVisible_yn;
end;

procedure setAccordionHeight(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2, in_height_nr number) is
  v_accordionPanel_r bdf_panel_v%rowtype;
pragma autonomous_transaction;   
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then             

      bdf_accordionpanel_mng.setaccordionheight(v_accordionpanel_r.bdf_panelins_oid,in_accordionname_tx,in_height_nr);
    else 
      invalidPanelType(in_accordionPanelName_tx,'setAccordionHeight');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'setAccordionHeight'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when bdf_accordionpanel_mng.e_invalidaccordionName then
    accordionNameNotFound(in_accordionName_tx,'setAccordionHeight');
end;

function getAccordionHeight(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2) return number is
  v_accordionPanel_r    bdf_panel_v%rowtype;
  v_height_nr           number;      
  v_paneldtlins_r       t_bdf_paneldtlins%rowtype;
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then     


      v_paneldtlins_r := bdf_paneldtlins_qry.getpaneldtlins(v_accordionPanel_r.bdf_panelins_oid,in_accordionName_tx);  
      if v_paneldtlins_r.bdf_paneldtlins_oid is not null then
        v_height_nr := v_paneldtlins_r.height_nr;
      else 
        accordionNameNotFound(in_accordionName_tx,'getAccordionHeight');
      end if;  
    else 
      invalidPanelType(in_accordionPanelName_tx,'getAccordionHeight');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'getAccordionHeight'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_height_nr;
end;

procedure setAccordionOrder(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2, in_order_nr number) is
  v_accordionPanel_r bdf_panel_v%rowtype;
pragma autonomous_transaction;   
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then             

      bdf_accordionpanel_mng.setaccordionorder(v_accordionpanel_r.bdf_panelins_oid,in_accordionname_tx,in_order_nr);

    else 
      invalidPanelType(in_accordionPanelName_tx,'setAccordionOrder');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'setAccordionOrder'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when bdf_accordionpanel_mng.e_invalidaccordionName then
    accordionNameNotFound(in_accordionName_tx,'setAccordionOrder');
  when bdf_accordionpanel_mng.e_accordionOrderExists then
    accordionOrderExists(in_order_nr,'setAccordionOrder');
  when bdf_accordionpanel_mng.e_invalidAccordionOrder then
    bdf_support.terminateAPIunsuccessfully;
    raise api_exception.e_invalidAccordionOrder;   
end;

function getAccordionOrder(in_accordionPanelName_tx varchar2, in_accordionName_tx varchar2) return number is
  v_accordionPanel_r    bdf_panel_v%rowtype;
  v_order_nr            number;      
  v_paneldtlins_r       t_bdf_paneldtlins%rowtype;
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then     


      v_paneldtlins_r := bdf_paneldtlins_qry.getpaneldtlins(v_accordionPanel_r.bdf_panelins_oid,in_accordionName_tx);  
      if v_paneldtlins_r.bdf_paneldtlins_oid is not null then
        v_order_nr := v_paneldtlins_r.order_nr;
      else 
        accordionNameNotFound(in_accordionName_tx,'getAccordionOrder');    
      end if;  
    else 
      invalidPanelType(in_accordionPanelName_tx,'getAccordionOrder');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'getAccordionOrder'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_order_nr;
end;

function isResizable(in_accordionPanelName_tx varchar2) return varchar2 is
  v_accordionPanel_r    bdf_panel_v%rowtype;
  v_resizable_yn        varchar2(1); 

pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then  

      v_resizable_yn:=v_accordionPanel_r.resizableins_yn;

    else 
      invalidPanelType(in_accordionPanelName_tx,'isResizable');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'isResizable');     
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_resizable_yn;
end;

procedure setResizable(in_accordionPanelName_tx varchar2, in_resizable_yn varchar2) is

  v_accordionPanel_r    bdf_panel_v%rowtype;
  e_InvalidInputParameter exception;

pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then  

      bdf_panelins_api.setresizable(v_accordionPanel_r.bdf_panelins_oid,in_resizable_yn);

      bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.SetResizable,
                                      in_objecttype_cd=>bdf_constant.typePanel,
                                      in_panelType_cd =>bdf_constant.typeAccordionPanel,
                                      in_value_tx     =>in_resizable_yn,
                                      in_panelins_oid =>v_accordionPanel_r.bdf_panelins_oid,
                                      in_useCdata_yn =>'N');       
    else 
      invalidPanelType(in_accordionPanelName_tx,'setResizable');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'setResizable'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when e_InvalidInputParameter then
    invalidInputParameter(in_resizable_yn,'resizable','"Y" or "N"','setResizable'); 
end;

function getExpandedAccordion(in_accordionPanelName_tx varchar2) return number is
  v_accordionPanel_r           bdf_panel_v%rowtype;
  v_expandedAccordion_nr       number;
  v_expandedAccordion_oid       number;
  v_paneldtlins_r t_bdf_paneldtlins%rowtype;
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then  

      v_expandedAccordion_oid := v_accordionPanel_r.expandedaccordion_nr;
      v_paneldtlins_r := bdf_paneldtlins_qry.getpaneldtlins(v_expandedAccordion_oid);

      v_expandedAccordion_nr := v_paneldtlins_r.order_nr;
    else 
      invalidPanelType(in_accordionPanelName_tx,'getExpandedAccordion');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'getExpandedAccordion'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_expandedAccordion_nr;
end;

function getCollapsedAccordion(in_accordionPanelName_tx varchar2) return number is
  v_accordionPanel_r    bdf_panel_v%rowtype;
  v_collapsedAccordion_nr      number;
  v_collapsedAccordion_oid      number;
  v_paneldtlins_r t_bdf_paneldtlins%rowtype;
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then               
      v_collapsedAccordion_oid := v_accordionPanel_r.collapsedaccordion_nr;
      v_paneldtlins_r := bdf_paneldtlins_qry.getpaneldtlins(v_collapsedAccordion_oid);

      v_collapsedAccordion_nr := v_paneldtlins_r.order_nr;
    else 
      invalidPanelType(in_accordionPanelName_tx,'getCollapsedAccordion');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'getCollapsedAccordion'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_collapsedAccordion_nr;
end;



function getExpandIconPosition(in_accordionPanelName_tx varchar2) return varchar2 is
  v_accordionPanel_r    bdf_panel_v%rowtype;
  v_expandIconPosition_cd       varchar2(200); 

pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then  

      v_expandIconPosition_cd:=v_accordionPanel_r.expandIconPositionins_cd;

    else 
      invalidPanelType(in_accordionPanelName_tx,'getExpandIconPosition');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'getExpandIconPosition');     
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_expandIconPosition_cd;
end;

procedure setExpandIconPosition(in_accordionPanelName_tx varchar2, in_expandIconPosition_cd varchar2) is  
  v_accordionPanel_r    bdf_panel_v%rowtype;
  e_InvalidInputParameter exception;
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then  
      if  in_expandIconPosition_cd in (bdf_constant.expandIconPositionLeft,bdf_constant.expandIconPositionRight) then          
        bdf_panelins_api.setexpandiconposition(v_accordionPanel_r.bdf_panelins_oid,in_expandiconposition_cd);

        bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.SetExpandIconPosition,
                                        in_objecttype_cd=>bdf_constant.typePanel,
                                        in_panelType_cd =>bdf_constant.typeAccordionPanel,
                                        in_value_tx     =>in_expandIconPosition_cd,
                                        in_panelins_oid =>v_accordionPanel_r.bdf_panelins_oid,
                                        in_useCdata_yn =>'N');       
      else
        raise e_invalidInputParameter;
      end if;
    else 
      invalidPanelType(in_accordionPanelName_tx,'setExpandIconPosition');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'setExpandIconPosition'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when e_InvalidInputParameter then
    invalidInputParameter(in_expandIconPosition_cd,'expande icon position',
                          '"'||bdf_constant.expandIconPositionLeft||'" or "'||bdf_constant.expandIconPositionRight||'"','setExpandIconPosition');
end;

function getHeightAllocationPolicy(in_accordionPanelName_tx varchar2) return varchar2 is
  v_accordionPanel_r    bdf_panel_v%rowtype;
  v_heightAllocationPolicy_tx       varchar2(255); 

pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then  

      v_heightAllocationPolicy_tx:=v_accordionPanel_r.heightAllocationPolicyins_tx;

    else 
      invalidPanelType(in_accordionPanelName_tx,'getHeightAllocationPolicy');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'getHeightAllocationPolicy');     
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_heightAllocationPolicy_tx;
end;

procedure setHeightAllocationPolicy(in_accordionPanelName_tx varchar2, in_heightAllocationPolicy_tx varchar2) is  
  v_accordionPanel_r    bdf_panel_v%rowtype;
  e_InvalidInputParameter exception;
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then    

      bdf_panelins_api.setheightallocationpolicy(v_accordionPanel_r.bdf_panelins_oid,in_heightAllocationPolicy_tx);

      bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.SetHeightAllocPolicy,
                                      in_objecttype_cd=>bdf_constant.typePanel,
                                      in_panelType_cd =>bdf_constant.typeAccordionPanel,
                                      in_value_tx     =>in_heightAllocationPolicy_tx,
                                      in_panelins_oid =>v_accordionPanel_r.bdf_panelins_oid,
                                      in_useCdata_yn =>'N');       

    else 
      invalidPanelType(in_accordionPanelName_tx,'setHeightAllocationPolicy');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'setHeightAllocationPolicy'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
end;




function isMultiExpand(in_accordionPanelName_tx varchar2) return varchar2 is
  v_accordionPanel_r    bdf_panel_v%rowtype;
  v_multiExpand_yn       varchar2(1); 

pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then  

      v_multiExpand_yn:=v_accordionPanel_r.multiExpandins_yn;

    else 
      invalidPanelType(in_accordionPanelName_tx,'isMultiExpand');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'isMultiExpand');     
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
  return v_multiExpand_yn;
end;

procedure setMultiExpand(in_accordionPanelName_tx varchar2, in_multiExpand_yn varchar2) is  
  v_accordionPanel_r    bdf_panel_v%rowtype;
  e_InvalidInputParameter exception;
pragma autonomous_transaction;  
begin
  v_accordionPanel_r := bdf_panel_qry.getpanel(in_accordionPanelName_tx,bdf_support.getcurrentapplication);
  if v_accordionPanel_r.bdf_panel_oid is not null then
    v_accordionPanel_r:= bdf_panel_mng.getinstance(v_accordionPanel_r);
    if v_accordionPanel_r.type_cd = bdf_constant.typeAccordionPanel then  
      if  in_multiExpand_yn in ('Y','N') then          

        bdf_panelins_api.setmultiexpand(v_accordionPanel_r.bdf_panelins_oid,in_multiexpand_yn);

        bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.SetMultiExpand,
                                        in_objecttype_cd=>bdf_constant.typePanel,
                                        in_panelType_cd =>bdf_constant.typeAccordionPanel,
                                        in_value_tx     =>in_multiExpand_yn,
                                        in_panelins_oid =>v_accordionPanel_r.bdf_panelins_oid,
                                        in_useCdata_yn =>'N');       
      else
        raise e_invalidInputParameter;
      end if;
    else 
      invalidPanelType(in_accordionPanelName_tx,'setMultiExpand');        
    end if;
  else
    accordionPanelNameNotFound(in_accordionPanelName_tx,'setMultiExpand'); 
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when e_InvalidInputParameter then
    invalidInputParameter(in_multiExpand_yn,'multi expand','"Y" or "N"','setMultiExpand');
end;

END;