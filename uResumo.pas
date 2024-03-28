unit uResumo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.ListView;

type
  TfrmResumo = class(TForm)
    ListView1: TListView;
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
    rectLogin: TRectangle;
    Label4: TLabel;
    procedure imgFecharClick(Sender: TObject);
    procedure imgAddItemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmResumo: TfrmResumo;

implementation

uses uPrincipal;

{$R *.fmx}

procedure TfrmResumo.imgAddItemClick(Sender: TObject);
begin
  frmPrincipal.addItem(labComanda.text.ToInteger);
end;

procedure TfrmResumo.imgFecharClick(Sender: TObject);
begin
  close;
end;

end.
