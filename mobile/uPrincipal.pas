unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.TabControl,
  FMX.Edit, FMX.Layouts, FMX.ListBox, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

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
  private
    procedure mudarAba(img: TImage);
    procedure detalhesComanda(comanda: integer);
    procedure addMapa(comanda: integer; status: string; valorTotal: double);
    procedure addProdutoLv(idProduto: integer; descricao: string; preco: double);
    procedure listarProduto(indClear: boolean; busca: string);
    { Private declarations }
  public
    { Public declarations }

    procedure addItem(comanda: integer);
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses uAddItem, uResumo;

{$R *.fmx}

procedure TfrmPrincipal.detalhesComanda(comanda: integer);
begin
  if NOT Assigned(frmAddItem) then
    Application.CreateForm(TfrmResumo, frmResumo);

  frmResumo.labComanda.text := comanda.tostring;
  frmResumo.Show;

end;

procedure TfrmPrincipal.addMapa(comanda: integer; status: string; valorTotal: double);
var
  item: TListBoxItem;
  rect: TRectangle;
  lbl: TLabel;
begin
  item := TListBoxItem.create(lbMapa);
  item.text := '';
  item.height := 110;
  item.Tag := comanda;
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

  if (status.ToUpper = 'LIVRE') then
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
  lbl.Text := status;
  lbl.Margins.left := 5;
  lbl.Margins.top := 5;
  lbl.Height := 15;
  lbl.StyledSettings := lbl.StyledSettings - [TstyledSetting.fontColor];
  lbl.FontColor := $FFFFFFFF;

  {labValor}
  lbl := TLabel.Create(rect);
  lbl.Parent := rect;
  lbl.Align := TAlignLayout.bottom;

  if (status.ToUpper = 'LIVRE') then
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
  lbl.Text := comanda.tostring;
  lbl.StyledSettings := lbl.StyledSettings - [TstyledSetting.fontColor, TstyledSetting.Size] ;
  lbl.FontColor := $FFFFFFFF;
  lbl.font.size := 30;
  lbl.TextAlign := TTextAlign.center;
  lbl.VertTextAlign := TTextAlign.center;

  lbMapa.AddObject(item);

end;

procedure TfrmPrincipal.addItem(comanda: integer);
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
end;

procedure TfrmPrincipal.rectAddItemClick(Sender: TObject);
begin
  if edtComanda.text <> '' then
    addItem(edtComanda.Text.ToInteger);
end;

procedure TfrmPrincipal.rectBuscarClick(Sender: TObject);
begin
  listarProduto(true, edtBuscaProduto.text);
end;

procedure TfrmPrincipal.rectDetalhesClick(Sender: TObject);
begin
  if edtComanda.text <> '' then
   detalhesComanda(edtComanda.Text.ToInteger);
end;

procedure TfrmPrincipal.FormResize(Sender: TObject);
begin
  lbMapa.Columns := trunc(lbMapa.Width / 110);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  mudarAba(imgAba1);
  addMapa(1, 'livre', 123);
  addMapa(2, 'ocupada', 333);
  addMapa(3, 'llimpa', 432);
  addMapa(4, 'llimpa', 22);
end;

procedure TfrmPrincipal.imgAba1Click(Sender: TObject);
begin
  mudarAba(TImage(Sender));
end;

procedure TfrmPrincipal.lbMapaItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  detalhesComanda(item.Tag);
end;

procedure TfrmPrincipal.addProdutoLv(idProduto: integer; descricao: string; preco: double);
begin
  with lvProduto.Items.add do
  begin
    Tag := idProduto;
    TListItemText(Objects.FindDrawable('txtDescricao')).text := descricao;
    TListItemText(Objects.FindDrawable('txtPreco')).text := FormatFloat('#,##0.00', preco);
  end;

end;

procedure TfrmPrincipal.listarProduto(indClear: boolean; busca: string);
var
  x: integer;
begin
  if indClear then
    lvProduto.Items.clear;

  for x := 1 to 10 do
   addProdutoLv(x, 'Produto ' + x.ToString, x);

end;

end.