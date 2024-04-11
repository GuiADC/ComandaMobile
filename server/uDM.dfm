object dm: Tdm
  Encoding = esUtf8
  QueuedRequest = False
  Height = 539
  Width = 610
  object conn: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\gui-a\Documents\Embarcadero\Studio\Projects\co' +
        'mandaMobile\server\DB\DBCOMANDA.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 160
    Top = 72
  end
  object DWEvents: TRESTDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'usuario'
            Encoded = False
          end>
        DataMode = dmRAW
        Name = 'ValidarLogin'
        EventName = 'ValidarLogin'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsValidarLoginReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <>
        DataMode = dmRAW
        Name = 'ListarComanda'
        EventName = 'ListarComanda'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsListarComandaReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'id_categoria'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'termo_busca'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'pagina'
            Encoded = False
          end>
        DataMode = dmRAW
        Name = 'ListarProduto'
        EventName = 'ListarProduto'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsListarProdutoReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <>
        DataMode = dmRAW
        Name = 'ListarCategoria'
        EventName = 'ListarCategoria'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsListarCategoriaReplyEvent
      end>
    Left = 376
    Top = 80
  end
  object qryLogin: TFDQuery
    Connection = conn
    Left = 264
    Top = 80
  end
end
