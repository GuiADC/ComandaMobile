unit uDM;

interface

uses
  System.SysUtils, System.Classes;

type
  Tdm = class(TDataModule)
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

end.
