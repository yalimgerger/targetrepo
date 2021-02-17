CREATE OR REPLACE EDITIONABLE PACKAGE "FORMSPIDER"."API_ALERT" IS
BUTTON1 constant number := bdf_constant.alertbutton1;
BUTTON2 constant number := bdf_constant.alertbutton2;
BUTTON3 constant number := bdf_constant.alertbutton3;
function getID(in_alertName_tx varchar2) return number;
function getLabel(in_alertName_tx varchar2) return varchar2;
function getResponse(in_alertName_tx varchar2) return number;
procedure setLabel(in_alertName_tx varchar2 , in_label_tx varchar2);
procedure show(in_alertName_tx varchar2);
procedure setTitle(in_alertName_tx varchar2, in_title_tx varchar2);
function getTitle(in_alertName_tx varchar2) return varchar2;
END;