
INSERT INTO [FieldActivity_ProtocoleType]
(FK_fieldActivity,FK_ProtocoleType)
SELECT 
      f.ID,typ.ID
  FROM [fieldActivity] f 
  join [ECWP-eReleveData_old].[dbo].[TThemeEtude] th on f.Name like th.Caption
  join [ECWP-eReleveData_old].[dbo].[TProt_TTheEt] t_p on t_p.TProt_PK_ID = th.TProt_PK_ID
  JOIN [ECWP-eReleveData_old].[dbo].[TProtocole] p on t_p.TTheEt_PK_ID = p.TTheEt_PK_ID
  JOIN ProtocoleType typ on  replace(p.Relation,'_',' ') like LOWER(typ.Name)

