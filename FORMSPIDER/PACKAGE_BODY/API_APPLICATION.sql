CREATE OR REPLACE EDITIONABLE PACKAGE BODY "FORMSPIDER"."API_APPLICATION" IS

--edit 1

-- dev 1 change 1
-- yalim 1 change 1
procedure doCommit is
  v_exceptionParameter bdf_exception.tt_exception;
  v_dbobjectAccess_oid number;


begin

  bdf_dbobjectaccess_mng.doCommit;

  bdf_support.terminateAPIsuccessfully;
  bdf_datasource_mng.commitcontext;

  commit;
exception
  when bdf_datasource_mng.e_concurrencyViolation then
    v_dbobjectaccess_oid := bdf_dbobjectaccess_mng.getLastCommittedDBOA;
    v_exceptionParameter(0).value_tx := bdf_dbobjectAccess_qry.getname(v_dbobjectaccess_oid);
    v_exceptionParameter(1).value_tx := bdf_datasourceDef_qry.getBaseObject(bdf_dbobjectAccess_qry.getdatasourcedefid(v_dbobjectaccess_oid));
    bdf_exception.setlastexception(in_methodname_tx      =>'api_application.doCommit',
                                   in_exceptioncode_tx   =>'e_concurrencyViolation',
                                   in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                   in_exceptionParamers_t=> v_exceptionParameter);
    bdf_support.terminateapiunsuccessfully;
    rollback;
    raise api_exception.e_concurrencyViolation;

  when others then
    bdf_support.terminateapiunsuccessfully;
    bdf_datasource_mng.rollbackcontext;
    rollback;
    raise;
end doCommit;

procedure showPopupMessage(in_message_tx varchar2) is
pragma autonomous_transaction;
begin

  bdf_response_mng.responseInsert(
            in_actiontype_cd => bdf_constant_action.ShowPopUpMessage,
            in_objecttype_cd => bdf_constant.typeapplication,
            in_value_tx => in_message_tx);

commit; 
end showPopupMessage;

procedure run(in_desktopPath_tx varchar2:=null,
              in_webLink_tx varchar2:=null,
              in_browserWindowName_tx varchar2:=null,
              in_transferfocus_yn varchar2:=null,
              in_keepSession_yn varchar2:=null) is

  v_values bdf_response_def.tt_values;
  v_index_nr number := 0;
pragma autonomous_transaction;
begin
  if in_desktopPath_tx is not null then
    v_values(v_index_nr).paramName_tx := bdf_constant.attrValue;
    v_values(v_index_nr).value_tx := in_desktopPath_tx;
    v_index_nr := v_index_nr + 1;

  elsif in_webLink_tx is not null then
    v_values(v_index_nr).paramName_tx := bdf_constant.attrValue;
    v_values(v_index_nr).value_tx := in_webLink_tx;
    v_index_nr := v_index_nr + 1;
  end if;

  if in_browserWindowName_tx is not null then
    v_values(v_index_nr).paramName_tx := bdf_constant.attrBrowserWindowName;
    v_values(v_index_nr).value_tx := in_browserWindowName_tx;
    v_index_nr := v_index_nr + 1;
  end if;

  if in_transferfocus_yn is not null then
    v_values(v_index_nr).paramName_tx := bdf_constant.attrTransferFocus;
    v_values(v_index_nr).value_tx := 'Y';
    v_index_nr := v_index_nr + 1;
  end if;

  if in_keepSession_yn is not null then
    v_values(v_index_nr).paramName_tx := bdf_constant.attrKeepSession;
    v_values(v_index_nr).value_tx := in_keepSession_yn;
    v_index_nr := v_index_nr + 1;
  end if;

  bdf_response_mng.responseInsert(
            in_actiontype_cd => bdf_constant_action.Run,
            in_objecttype_cd => bdf_constant.typeapplication,
            in_value_t       => v_values);

  bdf_support.terminateAPIsuccessfully;
commit; 
end;

procedure close is
pragma autonomous_transaction;
begin
  bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.close,
                                  in_objecttype_cd=>bdf_constant.typeapplication);

  bdf_application_mng.close;

  bdf_support.terminateAPIsuccessfully;
commit; 
end;

procedure restart is
  pragma autonomous_transaction;
begin
  bdf_application_mng.restart;
  bdf_support.terminateAPIsuccessfully;
  commit; 
end;

procedure setFontColor(in_fontcolor_cd varchar2)is
  v_application_r bdf_application_v%rowtype;
  v_exceptionParameter  bdf_exception.tt_exception;
pragma autonomous_transaction;
begin

  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);
  bdf_support.validatecolor(in_fontcolor_cd);
  bdf_applicationsession_api.setfontcolor(v_application_r.bdf_applicationsession_oid,in_fontcolor_cd);
  bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.setfontcolor,
                                  in_objecttype_cd=>bdf_constant.typeapplication,
                                  in_value_tx     =>in_fontcolor_cd,
                                  in_applicationsession_oid=>v_application_r.bdf_applicationsession_oid,
                                  in_useCdata_yn =>'N');

  bdf_support.terminateAPIsuccessfully;
commit; 
exception
  when bdf_support.e_invalidColorName then
    v_exceptionParameter(0).value_tx := 'name';
    v_exceptionParameter(1).value_tx := in_fontcolor_cd;
    bdf_exception.setlastexception(in_methodname_tx      =>'api_application.setFontColor',
                                   in_exceptioncode_tx   =>'e_invalidColor',
                                   in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                   in_exceptionParamers_t=> v_exceptionParameter);
    bdf_support.terminateAPIunsuccessfully;
    raise api_exception.e_invalidColor;
  when bdf_support.e_invalidColorHEXValue then
    v_exceptionParameter(0).value_tx := 'hexadecimal code';
    v_exceptionParameter(1).value_tx := in_fontcolor_cd;
    bdf_exception.setlastexception(in_methodname_tx      =>'api_application.setFontColor',
                                   in_exceptioncode_tx   =>'e_invalidColor',
                                   in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                   in_exceptionParamers_t=> v_exceptionParameter);
    bdf_support.terminateAPIunsuccessfully;
    raise api_exception.e_invalidColor;
end;

procedure setFontFamily(in_fontfamily_tx varchar2)is
  v_application_r bdf_application_v%rowtype;
pragma autonomous_transaction;
begin

  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);
  bdf_applicationsession_api.setFontFamily(v_application_r.bdf_applicationsession_oid ,in_fontfamily_tx);
  bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.setFontfamily,
                                  in_objecttype_cd=>bdf_constant.typeapplication,
                                  in_value_tx     =>in_fontfamily_tx,
                                  in_applicationsession_oid=>v_application_r.bdf_applicationsession_oid,
                                  in_useCdata_yn =>'N');

  bdf_support.terminateAPIsuccessfully;
commit; 
end;

procedure setFontSize(in_fontsize_nr number)is
  v_application_r bdf_application_v%rowtype;
pragma autonomous_transaction;
begin

  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);
  bdf_applicationsession_api.setFontSize(v_application_r.bdf_applicationsession_oid ,in_fontsize_nr);
  bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.SetFontSize,
                                  in_objecttype_cd=>bdf_constant.typeapplication,
                                  in_value_tx     =>in_fontsize_nr,
                                  in_applicationsession_oid=>v_application_r.bdf_applicationsession_oid,
                                  in_useCdata_yn =>'N');


  bdf_support.terminateAPIsuccessfully;
commit; 
end;

procedure setFontStyle(in_fontstyle_tx varchar2)is
  v_application_r bdf_application_v%rowtype;
pragma autonomous_transaction;
begin

  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);
  bdf_applicationsession_api.setFontStyle(v_application_r.bdf_applicationsession_oid ,in_fontstyle_tx);
  bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.setfontStyle,
                                  in_objecttype_cd=>bdf_constant.typeapplication,
                                  in_value_tx     =>in_fontstyle_tx,
                                  in_applicationsession_oid=>v_application_r.bdf_applicationsession_oid,
                                  in_useCdata_yn =>'N');

  bdf_support.terminateAPIsuccessfully;
commit; 
end;

function getFontColor return varchar2 is
  v_application_r bdf_application_v%rowtype;

begin
  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);

  return  v_application_r.fontColorins_cd;
end;

function getFontFamily return varchar2 is
  v_application_r bdf_application_v%rowtype;

begin
  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);

  return  v_application_r.fontFamilyins_tx;
end;

function getFontSize return number is
  v_application_r bdf_application_v%rowtype;

begin
  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);

  return  v_application_r.fontSizeins_nr;
end;

function getFontStyle return varchar2 is
  v_application_r bdf_application_v%rowtype;

begin
  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);

  return  v_application_r.fontstyleins_tx;
end;

function getSourceCodeSchemaName return varchar2 is
  v_schema_tx varchar2(255) := bdf_support.getsourcecodeschemaname;
begin
  bdf_support.terminateapisuccessfully;
  return v_schema_tx;
end;

function getID return number is
  v_application_r bdf_application_v%rowtype;

begin
  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);

  return v_application_r.bdf_applicationsession_oid;
end;


function getFocusedComponent(in_innerComponent_yn varchar2:='N') return varchar2 is
  v_panelDotComponentName_tx varchar2(4000);
begin
  v_panelDotComponentName_tx := bdf_applicationsession_qry.getCurrentComponent(bdf_support.getcurrentapplicationsession, in_innerComponent_yn);
  return v_panelDotComponentName_tx;
end;

function getFocusedDialog return varchar2 is
begin

  return bdf_applicationsession_qry.getCurrentDialog(bdf_support.getcurrentapplicationsession);
end;

procedure setLanguage(in_language_cd varchar2,in_local_cd varchar2) is
  v_exceptionParameter bdf_exception.tt_exception;
  v_values bdf_response_def.tt_values;
  v_language_r t_bdf_language%rowtype;
  v_index_nr number := 0;
pragma autonomous_transaction;
begin
  v_language_r := bdf_language_qry.getLanguage(in_language_cd,in_local_cd,bdf_support.getcurrentapplication);
  if v_language_r.bdf_language_oid is not null then
    bdf_application_mng.setlanguage(v_language_r.bdf_language_oid);
    v_values(v_index_nr).paramName_tx := bdf_constant.attrlanguagecode;
    v_values(v_index_nr).value_tx := in_language_cd;
    v_index_nr := v_index_nr + 1;
    v_values(v_index_nr).paramName_tx := bdf_constant.attrlanguagelocalcode;
    v_values(v_index_nr).value_tx := in_local_cd;
    v_index_nr := v_index_nr + 1;
    if v_language_r.decimalseparator_tx is not null then
      v_values(v_index_nr).paramName_tx := bdf_constant.attrdecimalseperator;
      v_values(v_index_nr).value_tx := v_language_r.decimalseparator_tx;
      v_index_nr := v_index_nr + 1;
    end if;
    if v_language_r.thousandseparator_tx is not null then
      v_values(v_index_nr).paramName_tx := bdf_constant.attrthousandseperator;
      v_values(v_index_nr).value_tx := v_language_r.thousandseparator_tx;
      v_index_nr := v_index_nr + 1;
    end if;
    if v_language_r.cacheVersion_tx is not null then
      v_values(v_index_nr).paramName_tx := bdf_constant.attrCacheVersion;
      v_values(v_index_nr).value_tx := v_language_r.cacheVersion_tx;
      v_index_nr := v_index_nr + 1;
    end if;
    bdf_response_mng.responseinsert(in_actiontype_cd=> bdf_constant_action.setlanguage,
                                    in_objecttype_cd=> bdf_constant.typeapplication,
                                    in_value_t=> v_values);
  else
    v_exceptionParameter(0).value_tx := in_language_cd;
    v_exceptionParameter(1).value_tx := in_local_cd;
    bdf_exception.setlastexception(in_methodname_tx      =>'api_application.setLanguage',
                                   in_exceptioncode_tx   =>'e_invalidLanguageParameter',
                                   in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                   in_exceptionParamers_t=> v_exceptionParameter);
    bdf_support.terminateapiunsuccessfully;
    raise api_exception.e_invalidLanguageParameter ;
  end if;

  bdf_support.terminateAPIsuccessfully;
commit; 
end;

procedure login(in_username_tx varchar2,in_password_tx varchar2,in_brimSession_id number:=null,
                in_ruleName_tx varchar2:=null)is
  v_brimSession_id number;
  v_brimRule_id number;
pragma autonomous_transaction;
begin
  v_brimSession_id := in_brimSession_id;
  bdf_support.brimlogintodatasourceschema(io_brimrule_id=>v_brimRule_id,
                                          io_brimsession_id=>v_brimSession_id,
                                          in_brimrulename_tx=>in_ruleName_tx,
                                          in_username_tx=>in_username_tx,
                                          in_password_tx=>in_password_tx);

  bdf_applicationsession_api.setusercredential(bdf_support.getcurrentapplicationsession,in_username_tx,in_password_tx,v_brimRule_id,v_brimsession_id);

  bdf_support.terminateAPIsuccessfully;


commit; 
end;

procedure logoff is
  v_application_r bdf_application_v%rowtype;
pragma autonomous_transaction;
begin
  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);

  bdf_support.brimlogoff(v_application_r.brimRule_id);

  bdf_applicationsession_api.setusercredential(v_application_r.bdf_applicationsession_oid,null,null,null,null);

  bdf_support.terminateAPIsuccessfully;


commit; 
end;

function getRightClickPoint return api_graphics.t_point is
  v_rightClickPos api_graphics.t_point;

begin
  v_rightClickPos:= bdf_applicationsession_qry.getRightClickPoint(bdf_support.getcurrentapplicationsession);

  bdf_support.terminateAPIsuccessfully;
  return v_rightClickPos;
end;

function getKeyEventPoint return api_graphics.t_point is
  v_keyeventPos api_graphics.t_point;

begin
  v_keyeventPos:= bdf_applicationsession_qry.getKeyEventPoint(bdf_support.getcurrentapplicationsession);

  bdf_support.terminateAPIsuccessfully;
  return v_keyeventPos;
end;

function getEvent return api_event.t_event is
begin
  return bdf_support.getlasttriggeredevent;
end;

function getClientEvent return api_event.t_event is
begin
  return bdf_support.getclientevent;
end;

procedure fileDownload (in_link_tx varchar2, in_title_tx varchar2:=null,
                        in_fileName_tx varchar2:=null) is
  v_application_r bdf_application_v%rowtype;
  v_values bdf_response_def.tt_values;
pragma autonomous_transaction;
begin
  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);

  v_values(0).paramName_tx := bdf_constant.attrlink;
  v_values(0).value_tx := in_link_tx;
  if in_title_tx is not null then
    v_values(1).paramName_tx := bdf_constant.attrtitle;
    v_values(1).value_tx := in_title_tx;
  end if;
  if in_fileName_tx is not null then
    v_values(2).paramName_tx := bdf_constant.attrFileName;
    v_values(2).value_tx := in_fileName_tx;
  end if;

  bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.filedownload,
                                  in_objecttype_cd=>bdf_constant.typeapplication,
                                  in_value_t      =>v_values,
                                  in_applicationsession_oid=>v_application_r.bdf_applicationsession_oid);

  bdf_support.terminateAPIsuccessfully;
commit; 
end;

function getRendererVersion return varchar2 is
begin
  return bdf_applicationsession_qry.getrendererversion(bdf_support.getcurrentapplicationsession);
end;

function getRendererType return varchar2 is
begin
  return bdf_applicationsession_qry.getRendererType(bdf_support.getcurrentapplicationsession);
end;

function getLanguageCode return varchar2 is
  v_languageLanCode_cd varchar2(255);

begin
  v_languageLanCode_cd := bdf_applicationsession_qry.getLanguageCode(bdf_support.getcurrentapplicationsession);

  return  v_languageLanCode_cd;
end;

function getLanguageLocalCode return varchar2 is
  v_languageLocalCode_cd varchar2(255);

begin
  v_languageLocalCode_cd := bdf_applicationsession_qry.getLanguageLocalCode(bdf_support.getcurrentapplicationsession);

  return  v_languageLocalCode_cd;
end;

function getLanguageName return varchar2 is
  v_languageName_tx varchar2(255);

begin
  v_languageName_tx := bdf_applicationsession_qry.getLanguageName(bdf_support.getcurrentapplicationsession);

  return  v_languageName_tx;
end;

function isDirty return varchar2 is
  v_dirty_yn varchar2(1);
begin
  v_dirty_yn := bdf_applicationsession_qry.isDirty(bdf_support.getcurrentapplicationsession);

  return  v_dirty_yn;
end;

function isDmlNecessary return varchar2 is
  v_dirty_yn varchar2(1);

begin
  v_dirty_yn := bdf_applicationsession_qry.isDmlNecessary(bdf_support.getcurrentapplicationsession);
  bdf_support.terminateAPIsuccessfully;
  return  v_dirty_yn;
end;

function export(in_applicationName_tx varchar2,
                in_includeRevisionHistory_yn varchar2:='N',
                in_parent_xml xmltype:=null) return xmltype is

  v_application_xml xmltype;
begin

  v_application_xml := bdf_etl.extract(in_application_oid           => bdf_application_qry.getid(in_applicationName_tx),
                                       in_includeRevisionHistory_yn => in_includeRevisionHistory_yn,
                                       in_parent_xml                => in_parent_xml);

  bdf_support.terminateAPIsuccessfully;
  return v_application_xml;
end;

function export(in_exportObjects_t tt_exportObjects,
                in_includeRevisionHistory_yn varchar2:='N',
                in_parent_xml xmltype:=null) return xmltype is

  v_application_xml xmltype;
begin
  v_application_xml := bdf_etl.extract(in_objects_tt                => in_exportObjects_t,
                                       in_includeRevisionHistory_yn => in_includeRevisionHistory_yn,
                                       in_parent_xml                => in_parent_xml);

  bdf_support.terminateAPIsuccessfully;
  return v_application_xml;
end;

procedure print(in_url_tx varchar2) is
begin
  bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.Print,
                                  in_objecttype_cd=>bdf_constant.typeapplication,
                                  in_value_tx     =>in_url_tx,
                                  in_applicationsession_oid=>bdf_support.getcurrentapplicationsession);
end;

function getBrowserMessage return varchar2 is
  v_application_r bdf_application_v%rowtype;
begin
  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);
  bdf_support.terminateAPIsuccessfully;
  return  v_application_r.browsermessageins_tx;
end;

procedure setBrowserMessage(in_browsermessage_tx varchar2)is
  v_application_r bdf_application_v%rowtype;
pragma autonomous_transaction;
begin

  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);
  bdf_applicationsession_api.setbrowsermessage(v_application_r.bdf_applicationsession_oid,in_browsermessage_tx);
  bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.SetBrowserMessage,
                                  in_objecttype_cd=>bdf_constant.typeapplication,
                                  in_value_tx     =>in_browsermessage_tx,
                                  in_applicationsession_oid=>v_application_r.bdf_applicationsession_oid);

  bdf_support.terminateAPIsuccessfully;
commit; 
end;

procedure createBookmark(in_bookmark_tx varchar2)is
  v_application_r bdf_application_v%rowtype;
pragma autonomous_transaction;
begin

  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);

  bdf_response_mng.responseInsert(in_actiontype_cd=>bdf_constant_action.CreateBookmark,
                                  in_objecttype_cd=>bdf_constant.typeapplication,
                                  in_value_tx     =>in_bookmark_tx,
                                  in_applicationsession_oid=>v_application_r.bdf_applicationsession_oid);

  bdf_support.terminateAPIsuccessfully;
commit; 
end;

function getBookmark return varchar2 is
  v_application_r bdf_application_v%rowtype;

begin
  v_application_r := bdf_application_qry.getapplication(bdf_support.getcurrentapplication);
  bdf_support.terminateAPIsuccessfully;
  return  v_application_r.bookmark_tx;
end;

function getMultilingualValue (in_key_cd in varchar2,in_language_cd in varchar2:=null,
                               in_local_cd in varchar2:=null) return varchar2 is
  v_domaindtl_oid number := null;
  v_language_oid number;
  v_exceptionParameter bdf_exception.tt_exception;
  v_value_tx varchar2(4000) := null;
begin

  if in_language_cd is null and in_local_cd is null then
    v_language_oid := bdf_support.getcurrentlanguageid;
  else
    v_language_oid := bdf_language_qry.getid(in_language_cd=>in_language_cd,
                                             in_local_cd=>in_local_cd,
                                             in_application_oid=>bdf_support.getcurrentapplication);
  end if;

  if v_language_oid is null then
    v_exceptionParameter(0).value_tx := in_language_cd;
    v_exceptionParameter(1).value_tx := in_local_cd;
    bdf_exception.setlastexception(in_methodname_tx      =>'api_application.getMultilingualValue',
                                   in_exceptioncode_tx   =>'e_invalidLanguageParameter',
                                   in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                   in_exceptionParamers_t=> v_exceptionParameter);
    bdf_support.terminateapiunsuccessfully;
    raise api_exception.e_invalidLanguageParameter;
  end if;


  begin
    select dtl.bdf_domaindtl_oid,dsp.value_tx into v_domaindtl_oid,v_value_tx
    from t_bdf_domain d , t_bdf_domaindtl dtl, t_bdf_domaindtldsp dsp
    where d.bdf_domain_oid = dtl.bdf_domain_oid
    and dtl.bdf_domaindtl_oid= dsp.bdf_domaindtl_oid(+)
    and d.domaintype_cd = bdf_constant.domaintypemultilingual
    and d.name_tx = bdf_constant.domainlang
    and d.bdf_application_oid = bdf_support.getcurrentapplication
    and dtl.key_cd = in_key_cd
    and dsp.bdf_language_oid(+) = v_language_oid;
  exception
    when no_data_found then
      null;
  end;

  if v_domaindtl_oid is null then
    v_exceptionParameter(0).value_tx := in_key_cd;
    bdf_exception.setlastexception(in_methodname_tx      =>'api_application.getMultilingualValue',
                                   in_exceptioncode_tx   =>'e_invalidKey',
                                   in_errorBackTrace_tx  =>dbms_utility.format_error_backtrace,
                                   in_exceptionParamers_t=> v_exceptionParameter);
    bdf_support.terminateapiunsuccessfully;
    raise api_exception.e_invalidKey;
  end if;
  bdf_support.terminateAPIsuccessfully;
  return v_value_tx;
end;

function getDatasourceSchemaName return varchar2 is
  v_schema_tx varchar2(255) := bdf_support.getdatasourceschemaname;
begin
  bdf_support.terminateAPIsuccessfully;
  return v_schema_tx;
end;

function getDatasourceSchema return varchar2 is
  v_schema_tx varchar2(255) := bdf_support.getdatasourceschemaname;
begin
  bdf_support.terminateAPIsuccessfully;
  return v_schema_tx;
end;

procedure setDatasourceSchema(in_datasourceSchema_tx varchar2) is
  v_exceptionParameter bdf_exception.tt_exception;
  pragma autonomous_transaction;
begin
  if bdf_application_qry.getapplication(bdf_support.getcurrentapplication).bdf_owner_oid is not null then
    v_exceptionParameter(0).value_tx := 'Can not set Datasource Schema of Application which is belong to a guest user.';
    bdf_exception.setlastexception(in_methodname_tx      =>'api_application.setDatasourceSchema',
                                   in_exceptioncode_tx   =>'e_insufficientPrivilege',

                                   in_exceptionParamers_t=> v_exceptionParameter);
    bdf_support.terminateapiunsuccessfully;
    raise api_exception.e_insufficientPrivilege;
  end if;
  bdf_applicationSession_api.setdatasourceschema(bdf_support.getcurrentapplicationsession,in_datasourceSchema_tx);
  bdf_support.setdatasourceschemaname(in_datasourceSchema_tx);
  commit; 
  bdf_support.terminateAPIsuccessfully;
end;

procedure setSourceCodeSchema(in_sourceCodeSchema_tx varchar2) is
  pragma autonomous_transaction;
begin
  bdf_applicationSession_api.setsourcecodeschemaname(bdf_support.getcurrentapplicationsession,in_sourceCodeSchema_tx);
  commit; 
  bdf_support.terminateAPIsuccessfully;
end;

function getOperatingSystem return varchar2 is
begin
  return bdf_applicationsession_qry.getoperatingsystem(bdf_support.getcurrentapplicationsession);
end;

function getBaseURL return varchar2 is
begin
  return bdf_applicationsession_qry.geturl(bdf_support.getcurrentapplicationsession);
end;

function isMobile return varchar2 is
  v_ismobile_yn varchar2(1);
begin
  v_ismobile_yn := bdf_applicationsession_qry.ismobile(bdf_support.getcurrentapplicationsession);
  bdf_support.terminateAPIsuccessfully;
  return  v_ismobile_yn;
end;

procedure raiseApplicationError is
begin
  raise bdf_support.e_raiseApplicationError;
end;

procedure setStateful(in_stateful_yn varchar2) is
begin
  api_session.add(bdf_constant.statefulsessionkey, in_stateful_yn);
end;

function isStateful return varchar2 is
begin
  return nvl(api_session.getvaluetx(bdf_constant.statefulsessionkey), 'N');
end;

END;