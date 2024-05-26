object dm: Tdm
  Encoding = esUtf8
  QueuedRequest = False
  Height = 539
  Width = 610
  object conn: TFDConnection
    Params.Strings = (
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
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'id_comanda'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'id_produto'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'qtd'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'vl_total'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'obs_opcional'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'vl_opcional'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'obs'
            Encoded = False
          end>
        DataMode = dmRAW
        Name = 'AdicionarProdutoComanda'
        EventName = 'AdicionarProdutoComanda'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsAdicionarProdutoComandaReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'id_comanda'
            Encoded = True
          end>
        DataMode = dmRAW
        Name = 'ListarProdutoComanda'
        EventName = 'ListarProdutoComanda'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsListarProdutoComandaReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'id_comanda'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'id_consumo'
            Encoded = False
          end>
        DataMode = dmRAW
        Name = 'ExcluirProdutoComanda'
        EventName = 'ExcluirProdutoComanda'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsExcluirProdutoComandaReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'id_comanda'
            Encoded = True
          end>
        DataMode = dmRAW
        Name = 'EncerrarComanda'
        EventName = 'EncerrarComanda'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsEncerrarComandaReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'id_comanda_de'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'id_comanda_para'
            Encoded = False
          end>
        DataMode = dmRAW
        Name = 'TransferirComanda'
        EventName = 'TransferirComanda'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsTransferirComandaReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        Params = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'id_Produto'
            Encoded = False
          end>
        DataMode = dmRAW
        Name = 'ListarOpcional'
        EventName = 'ListarOpcional'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsListarOpcionalReplyEvent
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
