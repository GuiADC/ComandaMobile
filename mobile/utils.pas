unit utils;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts;

  function IfThenn(ACondition: Boolean; ATrue: TLayout; AFalse: TLayout): TLayout;
  procedure resetMargins(pLayout: Tlayout; pmarginsBottom: integer = 0; pmarginsTop: integer = 0; pmarginsLeft: integer = 0; pMarginsRight: integer = 0);

implementation

function IfThenn(ACondition: Boolean; ATrue: TLayout; AFalse: TLayout): TLayout;
begin
  if ACondition then
    Result := ATrue
  else
    Result := AFalse;
end;

procedure resetMargins(pLayout: Tlayout; pmarginsBottom: integer = 0; pmarginsTop: integer = 0; pmarginsLeft: integer = 0; pMarginsRight: integer = 0);
begin
  pLayout.Margins.Bottom := pmarginsBottom;
  pLayout.Margins.top := pmarginsTop;
  pLayout.Margins.left := pmarginsLeft;
  pLayout.Margins.right := pMarginsRight;
end;

end.
