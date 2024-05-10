unit uResumo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.ListView, fmx.DialogService, system.JSON, FMX.Ani, FMX.Edit;

type
  TfrmResumo = class(TForm)
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    labComanda: TLabel;
    Rectangle2: TRectangle;
    lblTotal: TLabel;
    Rectangle4: TRectangle;
    Label3: TLabel;
    imgFechar: TImage;
    imgAddItem: TImage;
    rectEncerrar: TRectangle;
    Label4: TLabel;
    lvProduto: TListView;
    imgDelete: TImage;
    imgOpcoes: TImage;
    layoutMenu: TLayout;
    rectFundoOpaco: TRectangle;
    rectMenu: TRectangle;
    lblTransferir: TLabel;
    Line1: TLine;
    labFecharMenu: TLabel;
    animationMenu: TFloatAnimation;
    layoutTransferir: TLayout;
    rectFundoOpaco_transf: TRectangle;
    rectTransfMesa: TRectangle;
    rectLogin: TRectangle;
    Label5: TLabel;
    edtComandaPara: TEdit;
    Label2: TLabel;
    imgFecharTransferencia: TImage;
    procedure imgFecharClick(Sender: TObject);
    procedure imgAddItemClick(Sender: TObject);
    procedure rectEncerrarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvProdutoItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure imgOpcoesClick(Sender: TObject);
    procedure animationMenuFinish(Sender: TObject);
    procedure labFecharMenuClick(Sender: TObject);
    procedure rectFundoOpacoClick(Sender: TObject);
    procedure lblTransferirClick(Sender: TObject);
  private
    procedure addProdutoResumo(idConsumo: integer; qtd: integer; descricao: string; preco: double);
    procedure listarProduto;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmResumo: TfrmResumo;

implementation

uses uPrincipal, uDM, uAddItem;

{$R *.fmx}

procedure TfrmResumo.addProdutoResumo(idConsumo: integer; qtd: integer; descricao: string; preco: double);
begin
  with lvProduto.Items.add do
  begin
    Tag := idConsumo;
    TListItemText(Objects.FindDrawable('txtDescricao')).text := FormatFloat('00', qtd) + ' x ' + descricao;
    TListItemText(Objects.FindDrawable('txtPreco')).text := FormatFloat('#,##0.00',  qtd * preco);
    TListItemImage(Objects.FindDrawable('imgDelete')).bitmap := imgDelete.bitmap;
  end;
end;

procedure TfrmResumo.labFecharMenuClick(Sender: TObject);
begin
  animationMenu.Start;

end;

procedure TfrmResumo.lblTransferirClick(Sender: TObject);
begin
  animationMenu.Start;
end;

procedure TfrmResumo.listarProduto;
var
  jsonArray: TJSONArray;
  erro: string;
  total: double;
begin
  total := 0;
  lvProduto.Items.clear;

  if (not dm.listarProdutoComanda(labComanda.text, jsonArray, erro)) then
  begin
    ShowMessage(erro);
    exit;
  end;

  for var iIntIndex := 0 to jsonArray.Size -1 do
  begin
    addProdutoResumo(jsonArray.Get(iIntIndex).GetValue<integer>('ID_CONSUMO'),
                     jsonArray.Get(iIntIndex).GetValue<integer>('QTD'),
                     jsonArray.Get(iIntIndex).GetValue<string>('DESCRICAO'),
                     jsonArray.Get(iIntIndex).GetValue<double>('VALOR_TOTAL'));


    total := total + (jsonArray.Get(iIntIndex).GetValue<double>('VALOR_TOTAL') * jsonArray.Get(iIntIndex).GetValue<integer>('QTD'));
  end;

  lblTotal.text := FormatFloat('#,##0.00', total);
  jsonArray.DisposeOf;
end;

procedure TfrmResumo.lvProdutoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if (tlistview(sender).Selected <> nil) and (ItemObject is TListItemImage) then
  begin
    if (TListItemImage(ItemObject).Name = 'imgDelete') then
    begin
      //copio o nome do item selecionado para exibir na mensagem
      var nomeItemSelecionado := TListItemText(TListView(Sender).Items[ItemIndex].objects.FindDrawable('txtDescricao')).text.split(['x'])[1];

      TDialogService.MessageDialog('Confirmar exclusão do item:' + nomeItemSelecionado + ' ?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
      procedure(const AResult: TModalResult)
      var
        erro: string;
      begin
        if AResult = mrYes then
        begin
          if dm.ExcluirProdutoComanda(labComanda.text, tlistview(sender).Selected.Tag, erro) then
            frmResumo.listarProduto
          else
            ShowMessage(erro);
        end;
      end);

    end;

  end;
end;

procedure TfrmResumo.animationMenuFinish(Sender: TObject);
begin
  animationMenu.Inverse := not(animationMenu.Inverse);

  layoutMenu.Visible := rectMenu.Margins.Bottom  <> -100;
end;

procedure TfrmResumo.FormShow(Sender: TObject);
begin
  layoutMenu.visible := false;
  listarProduto;
end;

procedure TfrmResumo.imgAddItemClick(Sender: TObject);
begin

  if NOT Assigned(frmAddItem) then
    Application.CreateForm(TfrmAddItem, frmAddItem);

  frmAddItem.comanda := labComanda.text;
  frmAddItem.TabControl.ActiveTab := frmAddItem.tabCategoria;
  frmAddItem.Showmodal(procedure(modalResult: TModalResult)
  begin
   if (modalResult = mrOk) then
    frmResumo.listarProduto;
  end);

end;

procedure TfrmResumo.imgFecharClick(Sender: TObject);
begin
  close;
end;

procedure TfrmResumo.imgOpcoesClick(Sender: TObject);
begin
  layoutMenu.Visible := true;
  rectMenu.Margins.Bottom := -100;

  animationMenu.start;
end;

procedure TfrmResumo.rectEncerrarClick(Sender: TObject);
begin
  TDialogService.MessageDialog('Confirmar encerramento?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
  procedure(const AResult: TModalResult)
  var
    erro: string;
  begin
    if AResult = mrYes then
    begin
      ShowMessage('Encerramento concluido');

      if dm.EncerrarComanda(labComanda.text, erro) then
        close
      else
        ShowMessage(erro);
    end;
  end);
end;

procedure TfrmResumo.rectFundoOpacoClick(Sender: TObject);
begin
  animationMenu.Start;
end;

end.
