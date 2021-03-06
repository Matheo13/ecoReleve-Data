/****** Script de la commande SelectTopNRows à partir de SSMS  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---- migration des données argos/GPS/GSM --------------------------------------------------------------------------------------------
INSERT INTO [Individual_Location]
           ([LAT]
           ,[LON]
           ,[Date]
           ,[Precision]
		   ,[ELE]
		   ,creator
		   ,CreationDate
           ,[FK_Sensor]
           ,[FK_Individual]
		   ,type_
		   ,OriginalData_ID
		   ,fk_region)
SELECT [LAT]
      ,[LON]
	  ,[DATE]
      ,[Precision]
      ,[ELE]
      ,[Creator]
      ,[Creation_date]
	  ,s.ID as fk_sensor
	  ,CASE WHEN i.ID IS NOT NULL THEN i.ID ELSE i2.ID END as fk_ind
	  ,CASE WHEN i.ID IS NOT NULL THEN 'argos' ELSE 'gps' END as type_
	  ,CASE WHEN i.ID IS NOT NULL THEN 'eReleve_TProtocolDataArgos_'+CONVERT(VARCHAR,a.PK) ELSE 'eReleve_TProtocolDataGPS_'+CONVERT(VARCHAR,g.PK) END
	  ,R.ID
  FROM [ECWP-eReleveData].[dbo].[TStations] sta
  LEFT JOIN [ECWP-eReleveData].[dbo].TProtocol_ArgosDataArgos a ON sta.TSta_PK_ID = a.FK_TSta_ID
  LEFT JOIN [ECWP-eReleveData].[dbo].TProtocol_ArgosDataGPS g ON sta.TSta_PK_ID = g.FK_TSta_ID
  LEFT JOIN Individual i ON 'eReleve_'+CONVERT(Varchar,a.FK_TInd_ID) = i.Original_ID
  LEFT JOIN Individual i2 ON 'eReleve_'+CONVERT(Varchar,g.FK_TInd_ID) = i2.Original_ID
  LEFT JOIN Region R ON sta.Region = r.Region
  JOIN Sensor s ON dbo.split(sta.Name,'_',2) = s.UnicIdentifier
  where [FieldActivity_ID] = 27



  ------------------------ migration des données RFID --------------------------------------------------------------------------------------------
  
  /*INSERT INTO [Individual_Location]
           ([LAT]
           ,[LON]
           ,[Date]
		   ,creator
		   ,CreationDate
           ,[FK_Sensor]
           ,[FK_Individual]
		   ,type_
		   ,OriginalData_ID)
  SELECT [lat]
      ,[lon]
	  ,[date_]
	  ,[FK_creator]
      ,[creation_date]
	  ,s.ID
      ,i.ID
	  ,'rfid'
	  ,'eReleve_TAnimalLocation_'+CONVERT(VARCHAR,a.PK_id)

  FROM [ECWP-eReleveData].[dbo].[T_AnimalLocation] a
  JOIN Individual i ON 'eReleve_'+CONVERT(Varchar,a.FK_ind) = i.Original_ID
  JOIN Sensor s ON a.FK_obj = s.UnicIdentifier

  */

  INSERT INTO [Individual_Location]
           ([LAT]
           ,[LON]
           ,[Date]
     ,creator
     ,CreationDate
           ,[FK_Sensor]
           ,[FK_Individual]
     ,type_
     ,OriginalData_ID)
  SELECT [lat]
      ,[lon]
   ,[date_]
   ,a.[FK_creator]
      ,a.[creation_date]
   ,s.ID
      ,i.ID
   ,'RFID'
   ,'eReleve_TAnimalLocation_'+CONVERT(VARCHAR,a.PK_id)
   --,a.
  FROM [ECWP-eReleveData].[dbo].[T_AnimalLocation] a
  JOIN Individual i ON 'eReleve_'+CONVERT(Varchar,a.FK_ind) = i.Original_ID
  JOIN [ECWP-eReleveData].[dbo].[T_Object] o on o.PK_id = a.FK_obj 
  JOIN Sensor s ON o.PK_id = replace(replace(s.Original_ID,'RFID_',''),'VHF_','')