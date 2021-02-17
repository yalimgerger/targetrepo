CREATE OR REPLACE EDITIONABLE PACKAGE "FORMSPIDER"."API_APPLICATION" IS
JAVA_RENDERER constant varchar2(200) := bdf_constant.javarenderer;
JAVASCRIPT_RENDERER constant varchar2(200) := bdf_constant.javascriptrenderer;
MOBILE_RENDERER constant varchar2(200) := bdf_constant.mobilerenderer;
type t_object is record(
  type_cd  varchar2(200),
  name_tx  varchar2(255)
);
type t_exportObject is record (
  bdf_object_id number,
  objecttype_cd varchar2(200)
);
type tt_exportObjects is table of t_exportObject index by binary_integer;
function getFontColor return varchar2;
function getFontFamily return varchar2;
function getFontSize return number;
function getFontStyle return varchar2;
function getID return number;
function getSourceCodeSchemaName return varchar2;
procedure setFontColor(in_fontcolor_cd varchar2);
procedure setFontFamily(in_fontfamily_tx varchar2);
procedure setFontSize(in_fontsize_nr number);
procedure setFontStyle(in_fontstyle_tx varchar2);
procedure setLanguage(in_language_cd varchar2,in_local_cd varchar2);
procedure close;
procedure restart;
procedure doCommit;
procedure run(in_desktopPath_tx varchar2:=null,
              in_webLink_tx varchar2:=null,
              in_browserWindowName_tx varchar2:=null,
              in_transferfocus_yn varchar2:=null,
              in_keepSession_yn varchar2:=null);
procedure showPopupMessage(in_message_tx varchar2);
procedure login(in_username_tx varchar2,in_password_tx varchar2,in_brimSession_id number:=null,in_ruleName_tx varchar2:=null);
procedure logoff;
function getRightClickPoint return api_graphics.t_point;
function getKeyEventPoint return api_graphics.t_point;
function getEvent return api_event.t_event;
function getClientEvent return api_event.t_event;
function getFocusedComponent(in_innerComponent_yn varchar2:='N') return varchar2;
function getFocusedDialog return varchar2;
procedure fileDownload(in_link_tx varchar2, in_title_tx varchar2:=null, in_fileName_tx varchar2:=null);
function getRendererType return varchar2;
function getRendererVersion return varchar2;
function getLanguageCode return varchar2;
function getLanguageLocalCode return varchar2;
function getLanguageName return varchar2;
function isDirty return varchar2;
function isDmlNecessary return varchar2;
function export(in_applicationName_tx varchar2,
                in_includeRevisionHistory_yn varchar2:='N',
                in_parent_xml xmltype:=null) return xmltype;
function export(in_exportObjects_t tt_exportObjects,
                in_includeRevisionHistory_yn varchar2:='N',
                in_parent_xml xmltype:=null) return xmltype;
procedure print(in_url_tx varchar2);
function getBrowserMessage return varchar2;
procedure setBrowserMessage(in_browsermessage_tx varchar2);
procedure createBookmark(in_bookmark_tx varchar2);
function getBookmark return varchar2;
function getMultilingualValue (in_key_cd in varchar2,in_language_cd in varchar2:=null,in_local_cd in varchar2:=null) return varchar2;
function getDatasourceSchemaName return varchar2;
function getDatasourceSchema return varchar2;
procedure setDatasourceSchema(in_datasourceSchema_tx varchar2);
function getOperatingSystem return varchar2;
function getBaseURL return varchar2;
function isMobile return varchar2;
procedure raiseApplicationError;
procedure setStateful(in_stateful_yn varchar2);
function isStateful return varchar2;
END;