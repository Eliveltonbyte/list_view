object Dm: TDm
  OnCreate = DataModuleCreate
  Height = 239
  Width = 487
  object Conn: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    LoginPrompt = False
    AfterConnect = ConnAfterConnect
    BeforeConnect = ConnBeforeConnect
    Left = 152
    Top = 72
  end
  object qryPedido: TFDQuery
    Connection = Conn
    Left = 264
    Top = 120
  end
end
