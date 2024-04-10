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
        DataMode = dmDataware
        Name = 'ValidarLogin'
        EventName = 'ValidarLogin'
        BaseURL = '/'
        DefaultContentType = 'application/json'
        CallbackEvent = False
        OnlyPreDefinedParams = False
        OnReplyEvent = DWEventsEventsValidarLoginReplyEvent
      end>
    Left = 264
    Top = 168
  end
  object qryLogin: TFDQuery
    Connection = conn
    Left = 352
    Top = 80
  end
end
