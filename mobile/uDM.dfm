object dm: Tdm
  OnCreate = DataModuleCreate
  Height = 609
  Width = 555
  object conn: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\gui-a\Documents\Embarcadero\Studio\Projects\co' +
        'mandaMobile\mobile\DB\banco.db'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 200
    Top = 56
  end
  object qry_config: TFDQuery
    Connection = conn
    Left = 320
    Top = 56
  end
  object RESTClient: TRESTClient
    Authenticator = HTTPBasicAuthenticator1
    BaseURL = 'http://localhost:8082'
    Params = <>
    SynchronizedEvents = False
    Left = 96
    Top = 144
  end
  object RequestLogin: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'usuario'
        Value = 'Gui'
      end>
    Resource = 'ValidarLogin'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 32
    Top = 208
  end
  object RESTResponse1: TRESTResponse
    Left = 200
    Top = 144
  end
  object RequestListarComanda: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <
      item
        Name = 'usuario'
        Value = 'Gui'
      end>
    Resource = 'ListarComanda'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 368
    Top = 208
  end
  object RequestListarProduto: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <
      item
        Name = 'usuario'
        Value = 'Gui'
      end>
    Resource = 'ListarProduto'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 32
    Top = 272
  end
  object RequestListarCategoria: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <
      item
        Name = 'usuario'
        Value = 'Gui'
      end>
    Resource = 'ListarCategoria'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 32
    Top = 344
  end
  object RequestAdicionarProdutoComanda: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <
      item
        Name = 'usuario'
        Value = 'Gui'
      end>
    Resource = 'AdicionarProdutoComanda'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 32
    Top = 408
  end
  object RequestListarProdutoComanda: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <
      item
        Name = 'usuario'
        Value = 'Gui'
      end>
    Resource = 'ListarProdutoComanda'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 368
    Top = 424
  end
  object RequestExcluirProdutoComanda: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <
      item
        Name = 'usuario'
        Value = 'Gui'
      end>
    Resource = 'ExcluirProdutoComanda'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 368
    Top = 280
  end
  object RequestEncerrarComanda: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <
      item
        Name = 'usuario'
        Value = 'Gui'
      end>
    Resource = 'AdicionarProdutoComanda'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 368
    Top = 352
  end
  object RequestTransferir: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Params = <
      item
        Name = 'usuario'
        Value = 'Gui'
      end>
    Resource = 'TransferirComanda'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 368
    Top = 504
  end
  object RequestOpcional: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'usuario'
        Value = 'Gui'
      end>
    Resource = 'ListarOpcional'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 32
    Top = 488
  end
  object HTTPBasicAuthenticator1: THTTPBasicAuthenticator
    Username = 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3'
    Password = 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3'
    Left = 288
    Top = 144
  end
end
