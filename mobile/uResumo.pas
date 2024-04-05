unit uResumo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.ListView, fmx.DialogService;

type
  TfrmResumo = class(TForm)
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    labComanda: TLabel;
    Rectangle2: TRectangle;
    Label5: TLabel;
    Rectangle4: TRectangle;
    Label3: TLabel;
    imgFechar: TImage;
    imgAddItem: TImage;
    rectEncerrar: TRectangle;
    Label4: TLabel;
    lvProduto: TListView;
    imgDelete: TImage;
    procedure imgFecharClick(Sender: TObject);
    procedure imgAddItemClick(Sender: TObject);
    procedure rectEncerrarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure addProdutoResumo(idProduto, qtd: integer; descricao: string;
      preco: double);
    procedure listarProduto;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmResumo: TfrmResumo;

implementation

uses uPrincipal;

{$R *.fmx}

procedure TfrmResumo.addProdutoResumo(idProduto: integer; qtd: integer; descricao: string; preco: double);
begin
  with lvProduto.Items.add do
  begin
    Tag := idProduto;
    TListItemText(Objects.FindDrawable('txtDescricao')).text := FormatFloat('00', qtd) + ' x ' + descricao;
    TListItemText(Objects.FindDrawable('txtPreco')).text := FormatFloat('#,##0.00',  qtd * preco);
    TListItemImage(Objects.FindDrawable('imgDelete')).bitmap := imgDelete.bitmap;
  end;
end;

procedure TfrmResumo.listarProduto;
var
  x: integer;
begin
  lvProduto.Items.clear;

  for x := 1 to 10 do
    addProdutoResumo(x, 01,  ' Produto ' + x.ToString, x);
end;

procedure TfrmResumo.FormShow(Sender: TObject);
begin
  listarProduto;
end;

procedure TfrmResumo.imgAddItemClick(Sender: TObject);
begin
  frmPrincipal.addItem(labComanda.text.ToInteger);
end;

procedure TfrmResumo.imgFecharClick(Sender: TObject);
begin
  close;
end;

procedure TfrmResumo.rectEncerrarClick(Sender: TObject);
begin
  TDialogService.MessageDialog('Confirmar encerramento?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
  procedure(const AResult: TModalResult)
  begin
    if AResult = mrYes then
      ShowMessage('Encerramento concluido')

  end);

end;

end.