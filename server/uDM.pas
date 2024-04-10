unit uDM;

interface

uses
  System.SysUtils, System.Classes, urestDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, uRESTDWComponentBase, uRESTDWServerEvents, uRESTDWParams,
  uRESTDWAboutForm, uRESTDWJSONObject, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  Tdm = class(TServerMethodDataModule)
    conn: TFDConnection;
    DWEvents: TRESTDWServerEvents;
    qryLogin: TFDQuery;
    procedure DWEventsEventsValidarLoginReplyEvent(var Params: TRESTDWParams;
      var Result: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DWEventsEventsValidarLoginReplyEvent(var Params: TRESTDWParams;
  var Result: string);
begin
  if Params.ItemsString['usuario'].AsString = 'Heber' then
    result :=  '{"Retorno": "OK"}'
  else
    result :=  '{"usuario": "invalido"}';
end;

end.
