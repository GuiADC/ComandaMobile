unit uDM;

interface

uses
  System.SysUtils, System.Classes, urestDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, uRESTDWComponentBase, uRESTDWServerEvents, uRESTDWParams,
  uRESTDWAboutForm, uRESTDWJSONObject, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, system.JSON, uRESTDWConsts,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope;

type
  Tdm = class(TServerMethodDataModule)
    conn: TFDConnection;
    DWEvents: TRESTDWServerEvents;
    qryLogin: TFDQuery;
    procedure DWEventsEventsValidarLoginReplyEvent(var Params: TRESTDWParams;
      var Result: string);
    procedure DWEventsEventsListarComandaReplyEvent(var Params: TRESTDWParams;
      var Result: string);
    procedure DWEventsEventsListarCategoriaReplyEvent(var Params: TRESTDWParams;
      var Result: string);
    procedure DWEventsEventsListarProdutoReplyEvent(var Params: TRESTDWParams;
      var Result: string);
    procedure DWEventsEventsAdicionarProdutoComandaReplyEvent(
      var Params: TRESTDWParams; var Result: string);
    procedure DWEventsEventsListarProdutoComandaReplyEvent(
      var Params: TRESTDWParams; var Result: string);
    procedure DWEventsEventsExcluirProdutoComandaReplyEvent(
      var Params: TRESTDWParams; var Result: string);
    procedure DWEventsEventsEncerrarComandaReplyEvent(var Params: TRESTDWParams;
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

procedure Tdm.DWEventsEventsAdicionarProdutoComandaReplyEvent(
  var Params: TRESTDWParams; var Result: string);
var
  json: TJSONObject;
  qry: TFDQuery;
begin
  try
    json := TJSONObject.create;
    qry :=  TFDQuery.create(nil);
    qry.Connection := dm.conn;

    if (Params.itemsString['id_comanda'].AsString = '') or
       (Params.itemsString['id_produto'].AsString = '') or
       (Params.itemsString['qtd'].AsString = '') or
       (Params.itemsString['vl_total'].AsString = '') then
    begin
      json.AddPair('retorno', 'Parametros não informados');
      result := json.ToString;
    end;

    try
      qry.Active := false;
      qry.SQL.clear;
      qry.SQL.add('update');
      qry.SQL.add('    tab_comanda set STATUS = ''A'',');
      qry.SQL.add('    DT_ABERTURA = COALESCE(DT_ABERTURA, current_timestamp)');
      qry.SQL.add('WHERE');
      qry.SQL.add('ID_COMANDA = :ID_COMANDA');
      qry.ParamByName('ID_COMANDA').value := Params.ItemsString['id_comanda'].AsString;
      qry.ExecSQL;

      qry.Active := false;
      qry.SQL.clear;
      qry.SQL.add('INSERT INTO TAB_COMANDA_CONSUMO(ID_COMANDA, ID_PRODUTO, QTD, VALOR_TOTAL)');
      qry.SQL.add('VALUES (:ID_COMANDA, :ID_PRODUTO, :QTD, :VALOR_TOTAL)');
      qry.ParamByName('ID_COMANDA').value := Params.ItemsString['id_comanda'].AsString;
      qry.ParamByName('ID_PRODUTO').value := Params.ItemsString['id_produto'].AsInteger;
      qry.ParamByName('QTD').value := Params.ItemsString['qtd'].AsInteger;
      qry.ParamByName('VALOR_TOTAL').value := Params.ItemsString['vl_total'].Asfloat;
      qry.ExecSQL;

      json.AddPair('retorno', 'ok');

    except on
      Ex: Exception do
      json.AddPair('retorno', ex.Message);

    end;

    Result := json.tostring;

  finally
    json.DisposeOf;
    qry.DisposeOf;
  end;
end;

procedure Tdm.DWEventsEventsEncerrarComandaReplyEvent(var Params: TRESTDWParams;
  var Result: string);
var
  qry: TFDQuery;
  json: TJSONObject;
begin
  try
    json := TJSONObject.Create;
    qry := TFDQuery.create(nil);
    qry.Connection := dm.conn;

    if (params.itemsString['id_comanda'].asString = '') then
    begin
      json.addPair('retorno', 'Parametro id_comanda não informado');
      result := json.tostring;
      exit;
    end;

    try
    // colocar os dados da comanda na tebela de vendas do ERP do restaurante aqui

      qry.Active := false;
      qry.SQL.clear;
      qry.SQL.add('UPDATE TAB_COMANDA SET STATUS = ''F'', DT_ABERTURA = NULL');
      qry.SQL.add('WHERE ID_COMANDA = :ID_COMANDA');
      qry.ParamByName('ID_COMANDA').value := Params.ItemsString['id_comanda'].AsString;
      qry.ExecSQL;

      json.addPair('retorno', 'OK');
    except on
      ex: exception do
      json.AddPair('retorno', ex.message);
    end;

    result := json.tostring;

  finally
    json.DisposeOf;
    qry.DisposeOf;
  end;
end;

procedure Tdm.DWEventsEventsExcluirProdutoComandaReplyEvent(
  var Params: TRESTDWParams; var Result: string);
var
  qry: TFDQuery;
  json: TJSONObject;
begin
  try
    json := TJSONObject.Create;
    qry := TFDQuery.create(nil);
    qry.Connection := dm.conn;

    if (params.itemsString['id_comanda'].asString = '') or
       (params.itemsString['id_consumo'].asString = '') then
    begin
      json.addPair('retorno', 'Parametros não informados');
      result := json.tostring;
      exit;
    end;

    try
      qry.Active := false;
      qry.SQL.clear;
      qry.SQL.add('DELETE FROM TAB_COMANDA_CONSUMO');
      qry.SQL.add('WHERE ID_CONSUMO = :ID_CONSUMO AND ID_COMANDA = :ID_COMANDA');

      qry.ParamByName('ID_COMANDA').value := Params.ItemsString['id_comanda'].AsString;
      qry.ParamByName('ID_CONSUMO').value := Params.ItemsString['id_consumo'].AsInteger;
      qry.ExecSQL;

      json.AddPair('retorno','ok');
    except on
      Ex: Exception do
      json.AddPair('retorno', ex.Message);
    end;
    result := json.ToJSON;
  finally
    json.DisposeOf;
    qry.DisposeOf;
  end;
end;

procedure Tdm.DWEventsEventsListarCategoriaReplyEvent(var Params: TRESTDWParams;
  var Result: string);
var
  qry: TFDQuery;
  json: uRESTDWJSONObject.TJSONValue;
begin
  try
    qry := TFDQuery.create(nil);
    qry.Connection := dm.conn;

    json := uRESTDWJSONObject.TJSONValue.Create;

    qry.Active := false;
    qry.SQL.clear;
    qry.SQL.add('select');
    qry.SQL.add('    C.*');
    qry.SQL.add('from');
    qry.SQL.add('    tab_produto_categoria C');
    qry.SQL.add('order BY C.descricao');
    qry.active := true;

    json.LoadFromDataset('', qry, false, dmRAW);

    result := json.ToJSON;
  finally
    json.DisposeOf;
    qry.DisposeOf;
  end;
end;

procedure Tdm.DWEventsEventsListarComandaReplyEvent(var Params: TRESTDWParams;
  var Result: string);
var
  qry: TFDQuery;
  json: uRESTDWJSONObject.TJSONValue;
begin
  try
    qry := TFDQuery.create(nil);
    qry.Connection := dm.conn;

    json := uRESTDWJSONObject.TJSONValue.Create;

    qry.Active := false;
    qry.SQL.clear;
    qry.SQL.add('select');
    qry.SQL.add('    C.ID_COMANDA,');
    qry.SQL.add('    C.STATUS,');
    qry.SQL.add('    coalesce(SUM(O.VALOR_TOTAL * O.QTD), 0) as VALOR_TOTAL');
    qry.SQL.add('from');
    qry.SQL.add('    tab_comanda C');
    qry.SQL.add('    left join tab_comanda_consumo O ON (C.id_comanda = O.id_comanda)');
    qry.SQL.add('GROUP BY');
    qry.SQL.add('    C.id_comanda, c.status');
    qry.SQL.add('    order BY C.id_comanda');
    qry.active := true;

    json.LoadFromDataset('', qry, false, dmRAW);

    result := json.ToJSON;
  finally
    json.DisposeOf;
    qry.DisposeOf;
  end;

end;

procedure Tdm.DWEventsEventsListarProdutoComandaReplyEvent(
  var Params: TRESTDWParams; var Result: string);
var
  qry: TFDQuery;
  json: uRESTDWJSONObject.TJSONValue;
begin
  try
    qry := TFDQuery.create(nil);
    qry.Connection := dm.conn;

    json := uRESTDWJSONObject.TJSONValue.Create;

    qry.Active := false;
    qry.SQL.clear;
    qry.SQL.add('select');
    qry.SQL.add('   C.ID_CONSUMO,');
    qry.SQL.add('   P.ID_PRODUTO,');
    qry.SQL.add('   P.DESCRICAO,');
    qry.SQL.add('   C.QTD,');
    qry.SQL.add('   C.VALOR_TOTAL');
    qry.SQL.add('from');
    qry.SQL.add('    TAB_COMANDA_CONSUMO C');
    qry.SQL.add('     JOIN TAB_PRODUTO P ON (P.ID_PRODUTO = C.ID_PRODUTO)');
    qry.SQL.add('where');
    qry.SQL.add('    C.ID_COMANDA = :ID_COMANDA');
    qry.SQL.add('    ORDER BY P.DESCRICAO');
    qry.ParamByName('ID_COMANDA').value := Params.ItemsString['id_comanda'].AsString;

    qry.active := true;

    json.LoadFromDataset('', qry, false, dmRAW);

    result := json.ToJSON;

  finally
    json.DisposeOf;
    qry.DisposeOf;
  end;

end;

procedure Tdm.DWEventsEventsListarProdutoReplyEvent(var Params: TRESTDWParams;
  var Result: string);
var
  qry: TFDQuery;
  json: uRESTDWJSONObject.TJSONValue;
begin
  try
    qry := TFDQuery.create(nil);
    qry.Connection := dm.conn;

    json := uRESTDWJSONObject.TJSONValue.Create;

    qry.Active := false;
    qry.SQL.clear;
    qry.SQL.add('select');
    qry.SQL.add('    *');
    qry.SQL.add('from');
    qry.SQL.add('    TAB_PRODUTO P');
    qry.SQL.add('where');
    qry.SQL.add('    P.ID_PRODUTO > 0');

    if Params.ItemsString['id_categoria'].AsString <> '' then
    begin
      qry.SQL.add('AND P.ID_CATEGORIA = :ID_CATEGORIA');
      qry.ParamByName('ID_CATEGORIA').value := Params.ItemsString['id_categoria'].asInteger;
    end;

    if Params.ItemsString['termo_busca'].AsString <> '' then
    begin
      qry.SQL.add('AND P.ID_DESCRICAO LIKE  :TERMO_BUSCA');
      qry.ParamByName('ID_CATEGORIA').value := Params.ItemsString['id_categoria'].asInteger;
      qry.ParamByName('TERMO_BUSCA').value := '%' + Params.ItemsString['id_categoria'].asString + '%';
    end;

    qry.SQL.add(' ORDER BY P.DESCRICAO');

    qry.active := true;

    json.LoadFromDataset('', qry, false, dmRAW);

    result := json.ToJSON;

  finally
    json.DisposeOf;
    qry.DisposeOf;
  end;

end;

procedure Tdm.DWEventsEventsValidarLoginReplyEvent(var Params: TRESTDWParams;
  var Result: string);
var
  json: TJsonObject;
begin
  try
    json := TJSONObject.create;

    if Params.ItemsString['usuario'].AsString = '' then
    begin
      json.AddPair('retorno', 'Usuário nao informado');
      Result := json.ToString;
      exit;
    end;

    with dm do
    begin
      qryLogin.Active := false;
      qryLogin.SQL.Clear;
      qryLogin.SQL.Add('SELECT * from TAB_USUARIO WHERE COD_USUARIO=:USUARIO');
      qryLogin.ParamByName('USUARIO').Value := Params.ItemsString['usuario'].AsString;
      qryLogin.Active := true;

      if qryLogin.RecordCount > 0 then
        json.AddPair('retorno', 'OK')
      else
        json.AddPair('retorno', 'Usuário invalido');

      Result := json.tostring;
    end;
  finally
    json.DisposeOf;
  end;
end;

end.
