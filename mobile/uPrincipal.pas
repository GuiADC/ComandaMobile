unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.TabControl,
  FMX.Edit, FMX.Layouts, FMX.ListBox, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, System.JSON;

type
  TfrmPrincipal = class(TForm)
    Rectangle1: TRectangle;
    Label1: TLabel;
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    rect_abas: TRectangle;
    Rectangle3: TRectangle;
    Label2: TLabel;
    Rectangle4: TRectangle;
    Label3: TLabel;
    Layout1: TLayout;
    Label4: TLabel;
    edtComanda: TEdit;
    rectAddItem: TRectangle;
    Label5: TLabel;
    rectDetalhes: TRectangle;
    Label6: TLabel;
    lbMapa: TListBox;
    Rectangle6: TRectangle;
    lvProduto: TListView;
    edtBuscaProduto: TEdit;
    rectBuscar: TRectangle;
    Label7: TLabel;
    imgAba1: TImage;
    imgAba2: TImage;
    imgAba3: TImage;
    procedure imgAba1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rectDetalhesClick(Sender: TObject);
    procedure rectAddItemClick(Sender: TObject);
    procedure lbMapaItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormResize(Sender: TObject);
    procedure rectBuscarClick(Sender: TObject);
    procedure lvProdutoPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    procedure mudarAba(img: TImage);
    procedure detalhesComanda(comanda: string);
    procedure addMapa(comanda: string; status: string; valorTotal: double);
    procedure addProdutoLv(idProduto: integer; descricao: string; preco: double);
    procedure listarProduto(indClear: boolean; busca: string);
    procedure CarregarComanda;
    procedure ThreadEnd(sender: TObject);
    { Private declarations }
  public
    { Public declarations }

    procedure addItem(comanda: string);
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses uAddItem, uResumo, uDM;

{$R *.fmx}

procedure TfrmPrincipal.CarregarComanda;
var
  jsonArray: TJSONArray;
  erro: string;
begin

  lbMapa.Items.clear;

  if not (dm.ListarComanda(jsonArray, erro)) then
  begin
    ShowMessage(erro);
    exit;
  end;

  for var iintIndex := 0 to jsonArray.Size -1 do
  begin
    addMapa(jsonArray.Get(iintIndex).GetValue<string>('ID_COMANDA'), jsonArray.Get(iintIndex).GetValue<string>('STATUS'), jsonArray.Get(iintIndex).GetValue<double>('VALOR_TOTAL'));
  end;

  jsonArray.DisposeOf;
end;

procedure TfrmPrincipal.detalhesComanda(comanda: string);
begin
  if NOT Assigned(frmAddItem) then
    Application.CreateForm(TfrmResumo, frmResumo);

  frmResumo.labComanda.text := comanda;
  frmResumo.Show;

end;

procedure TfrmPrincipal.addMapa(comanda: string; status: string; valorTotal: double);
var
  item: TListBoxItem;
  rect: TRectangle;
  lbl: TLabel;
begin
  item := TListBoxItem.create(lbMapa);
  item.text := '';
  item.height := 110;
  item.TagString := comanda;
  item.Selectable := false;

  rect := TRectangle.Create(item);
  rect.Parent := item;
  rect.Align := TAlignLayout.Client;
  rect.Margins.Top := 10;
  rect.Margins.Bottom := 10;
  rect.Margins.Left := 10;
  rect.Margins.Right := 10;
  rect.Fill.Kind := TBrushKind.Solid;
  rect.HitTest := false;

  if (status.ToUpper = 'F') then
    rect.Fill.Color := $FF4A70F7
  else
    rect.Fill.Color := $FFEC6E73;

  rect.XRadius := 10;
  rect.YRadius := 10;
  rect.Stroke.Kind := TBrushKind.none;

  {labStatus}
  lbl := TLabel.Create(rect);
  lbl.Parent := rect;
  lbl.Align := TAlignLayout.top;

  if status = 'F' then
    lbl.Text := 'Livre'
  else
    lbl.Text := 'Ocupada';

  lbl.Margins.left := 5;
  lbl.Margins.top := 5;
  lbl.Height := 15;
  lbl.StyledSettings := lbl.StyledSettings - [TstyledSetting.fontColor];
  lbl.FontColor := $FFFFFFFF;

  {labValor}
  lbl := TLabel.Create(rect);
  lbl.Parent := rect;
  lbl.Align := TAlignLayout.bottom;

  if (status.ToUpper = 'F') then
  lbl.Text := ''
  else
   lbl.Text := FormatFloat('#,##0.00', valorTotal);

  lbl.Margins.right := 5;
  lbl.Margins.bottom := 5;
  lbl.Height := 15;
  lbl.StyledSettings := lbl.StyledSettings - [TstyledSetting.fontColor];
  lbl.FontColor := $FFFFFFFF;
  lbl.TextAlign := TTextAlign.Trailing;

  {labComanda}
  lbl := TLabel.Create(rect);
  lbl.Parent := rect;
  lbl.Align := TAlignLayout.client;
  lbl.Text := comanda;
  lbl.StyledSettings := lbl.StyledSettings - [TstyledSetting.fontColor, TstyledSetting.Size] ;
  lbl.FontColor := $FFFFFFFF;
  lbl.font.size := 30;
  lbl.TextAlign := TTextAlign.center;
  lbl.VertTextAlign := TTextAlign.center;

  lbMapa.AddObject(item);

end;

procedure TfrmPrincipal.addItem(comanda: string);
begin
  if NOT Assigned(frmAddItem) then
    Application.CreateForm(TfrmAddItem, frmAddItem);

  frmAddItem.comanda := comanda;
  frmAddItem.TabControl.ActiveTab := frmAddItem.tabCategoria;
  frmAddItem.Show;

end;

procedure TfrmPrincipal.mudarAba(img: TImage);
begin
  imgAba1.Opacity := 0.4;
  imgAba2.Opacity := 0.4;
  imgAba3.Opacity := 0.4;

  img.Opacity := 1;
  TabControl.GotoVisibleTab(img.tag, TTabTransition.Slide);

  if img.tag = 1 then
    CarregarComanda;

end;

procedure TfrmPrincipal.rectAddItemClick(Sender: TObject);
begin
  if edtComanda.text <> '' then
    addItem(edtComanda.Text);
end;

procedure TfrmPrincipal.rectBuscarClick(Sender: TObject);
begin
  listarProduto(true, edtBuscaProduto.text);
end;

procedure TfrmPrincipal.rectDetalhesClick(Sender: TObject);
begin
  if edtComanda.text <> '' then
   detalhesComanda(edtComanda.Text);
end;

procedure TfrmPrincipal.FormResize(Sender: TObject);
begin
  lbMapa.Columns := trunc(lbMapa.Width / 110);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  mudarAba(imgAba1);
end;

procedure TfrmPrincipal.imgAba1Click(Sender: TObject);
begin
  mudarAba(TImage(Sender));
end;

procedure TfrmPrincipal.lbMapaItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if NOT Assigned(frmAddItem) then
    Application.CreateForm(TfrmResumo, frmResumo);

  frmResumo.labComanda.text := item.TagString;
  frmResumo.Showmodal(procedure(modalResult: TModalResult)
  begin
    CarregarComanda;
  end);
end;

procedure TfrmPrincipal.addProdutoLv(idProduto: integer; descricao: string; preco: double);
begin
  with lvProduto.Items.add do
  begin
    Tag := idProduto;
    TListItemText(Objects.FindDrawable('txtDescricao')).text := descricao + ' - Pg: ' + lvProduto.Tag.ToString + ' / ' + index.ToString;
    TListItemText(Objects.FindDrawable('txtPreco')).text := FormatFloat('#,##0.00', preco);
  end;

end;

procedure TfrmPrincipal.ThreadEnd(sender: TObject);
begin
   lvProduto.EndUpdate;

   if Assigned(tthread(sender).FatalException) then
    ShowMessage('Erro ao carregar produtos: ' + exception(tthread(sender).FatalException).Message);
end;

procedure TfrmPrincipal.listarProduto(indClear: boolean; busca: string);
var
  myThread: TThread;
begin
  if lvProduto.TagString = 'processando' then
    exit;

  lvProduto.TagString := 'processando';

  if indClear then
  begin
    lvProduto.ScrollTo(0);
    lvProduto.Tag := 0;
    lvProduto.Items.Clear;
  end;

  lvProduto.BeginUpdate;

  myThread := TThread.CreateAnonymousThread(procedure
  var
    jsonArray: TJSONArray;
    erro: string;
    total: double;
  begin
    if lvProduto.Tag >= 0 then
      lvProduto.Tag := lvProduto.Tag + 1;

    if NOT dm.ListarProduto(0, edtBuscaProduto.text, lvProduto.tag, jsonArray, erro) then
    begin
      raise Exception.Create('Erro ao listar produto: ' + erro);
      exit;
    end;

    for var iIntIndex := 0 to jsonArray.Size - 1 do
    begin
        TThread.Synchronize(nil, procedure
        begin
          AddProdutoLv(jsonArray.Get(iIntIndex).GetValue<integer>('ID_PRODUTO'),
                       jsonArray.Get(iIntIndex).GetValue<string>('DESCRICAO'),
                       jsonArray.Get(iIntIndex).GetValue<double>('PRECO'));
        end);
    end;

    if jsonArray.size = 0 then
      lvProduto.Tag := -1;

    jsonArray.DisposeOf;

    TThread.Synchronize(nil, procedure
    begin
      lvProduto.EndUpdate;
    end);

    lvProduto.TagString := '';

  end);
  myThread.OnTerminate := ThreadEnd;
  myThread.Start;
end;

procedure TfrmPrincipal.lvProdutoPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  if (lvProduto.Items.Count >= 0) and (lvProduto.tag >= 0) then
  begin
    if (lvProduto.GetItemRect(lvProduto.Items.Count - 3).Bottom <= lvProduto.Height) then
      listarProduto(false, edtBuscaProduto.text);
  end;
end;

end.
