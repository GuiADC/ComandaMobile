object dm: Tdm
  OnCreate = DataModuleCreate
  Height = 357
  Width = 508
  object conn: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\gui-a\Documents\Embarcadero\Studio\Projects\co' +
        'mandaMobile\mobile\DB\banco.db'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 224
    Top = 72
  end
  object qry_config: TFDQuery
    Connection = conn
    Left = 320
    Top = 88
  end
  object RESTClient: TRESTClient
    BaseURL = 'http://localhost:8082'
    Params = <>
    SynchronizedEvents = False
    Left = 32
    Top = 136
  end
  object RequestLogin: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <
      item
        Name = 'usuario'
        Value = 'Gui'
      end>
    Resource = 'ValidarLogin'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 8
    Top = 208
  end
  object RESTResponse1: TRESTResponse
    Left = 104
    Top = 208
  end
end
