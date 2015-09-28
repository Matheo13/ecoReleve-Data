--/****** Script de la commande SelectTopNRows à partir de SSMS  ******/
--DECLARE @data_toInsert table (fk_sensor int, fk_ind int, beginDate datetime, endDate datetime, unicName varchar(150));
--DECLARE @output table (id_sta int , name_sta varchar(150), date_ datetime);

--INSERT INTO @data_toInsert (fk_sensor , fk_ind , beginDate , endDate , unicName )
--SELECT 
--s.ID,
--i.ID,
--cv.[begin_date],
--cv.[end_date],
--'equipment_'+s.ID+'_Indiv_'+I.ID+'_'+CONVERT(VARCHAR(24),cv.[begin_date],112)

--  FROM [ECWP_ecoReleveData].[dbo].[TObj_Objects] o 
--  JOIN [ECWP_ecoReleveData].[dbo].[TObj_Obj_CaracList] cl ON o.Id_object_type = cl.fk_Object_type 
--  JOIN [ECWP_ecoReleveData].[dbo].[TObj_Carac_type] ct ON cl.fk_Carac_type = ct.Carac_type_Pk
--  JOIN [ECWP_ecoReleveData].[dbo].[TObj_Carac_value] cv ON o.[Object_Pk] = cv.[fk_object] and ct.Carac_type_Pk = cv.Fk_carac
--  JOIN [NewModelERD].[dbo].[Individual] i ON o.Object_Pk = i.Old_ID 
--  JOIN [NewModelERD].[dbo].[Sensor] s ON cv.value = s.UnicName
--  where Id_object_type = 1 and cv.Fk_carac = 19


--INSERT INTO [NewModelERD].[dbo].[Station]
--           ([StationDate]
--           ,[Name]
--           ,[creator]
--           ,[creationDate]
--           ,[FK_StationType]
--           )

--output inserted.ID,inserted.StationDate into @output
--SELECT 
--cv.[begin_date],
--'equipment_'+s.ID+'_Indiv_'+I.ID,
--1,
--cv.creation_date,
--3
--  FROM [ECWP_ecoReleveData].[dbo].[TObj_Objects] o 
--  JOIN [ECWP_ecoReleveData].[dbo].[TObj_Obj_CaracList] cl ON o.Id_object_type = cl.fk_Object_type 
--  JOIN [ECWP_ecoReleveData].[dbo].[TObj_Carac_type] ct ON cl.fk_Carac_type = ct.Carac_type_Pk
--  JOIN [ECWP_ecoReleveData].[dbo].[TObj_Carac_value] cv ON o.[Object_Pk] = cv.[fk_object] and ct.Carac_type_Pk = cv.Fk_carac
--  JOIN [NewModelERD].[dbo].[Individual] i ON o.Object_Pk = i.Old_ID 
--  JOIN [NewModelERD].[dbo].[Sensor] s ON cv.value = s.UnicName
--  where Id_object_type = 1 and cv.Fk_carac = 19

--INSERT INTO [NewModelERD].[dbo].[Observation]
--           ([FK_ProtocoleType]
--           ,[FK_Station]
--           ,[creationDate])
--SELECT 186, o.id_sta, o.date_
--FROM @data_toInsert d 
--JOIN @output o ON d.unicName = o.name_sta+'_'+CONVERT(VARCHAR(24),o.date_,112)




INSERT INTO [NewModelERD].[dbo].[Equipment]
           ([FK_Sensor]
           ,[FK_Individual]
           ,[StartDate]
           ,[Deploy])


SELECT
s.ID,
i.ID,
cv.[begin_date],
1

  FROM [ECWP_ecoReleveData].[dbo].[TObj_Objects] o 
  JOIN [ECWP_ecoReleveData].[dbo].[TObj_Obj_CaracList] cl ON o.Id_object_type = cl.fk_Object_type 
  JOIN [ECWP_ecoReleveData].[dbo].[TObj_Carac_type] ct ON cl.fk_Carac_type = ct.Carac_type_Pk
  JOIN [ECWP_ecoReleveData].[dbo].[TObj_Carac_value] cv ON o.[Object_Pk] = cv.[fk_object] and ct.Carac_type_Pk = cv.Fk_carac
  JOIN [NewModelERD].[dbo].[Individual] i ON o.Object_Pk = i.Old_ID 
  JOIN [NewModelERD].[dbo].[Sensor] s ON cv.value = s.UnicName
  where Id_object_type = 1 and cv.Fk_carac = 19


INSERT INTO [NewModelERD].[dbo].[Equipment]
           ([FK_Sensor]
           ,[FK_Individual]
           ,[StartDate]
           ,[Deploy])


SELECT 
s.ID,
i.ID,
cv.[end_date],
0

  FROM [ECWP_ecoReleveData].[dbo].[TObj_Objects] o 
  JOIN [ECWP_ecoReleveData].[dbo].[TObj_Obj_CaracList] cl ON o.Id_object_type = cl.fk_Object_type 
  JOIN [ECWP_ecoReleveData].[dbo].[TObj_Carac_type] ct ON cl.fk_Carac_type = ct.Carac_type_Pk
  JOIN [ECWP_ecoReleveData].[dbo].[TObj_Carac_value] cv ON o.[Object_Pk] = cv.[fk_object] and ct.Carac_type_Pk = cv.Fk_carac
  JOIN [NewModelERD].[dbo].[Individual] i ON o.Object_Pk = i.Old_ID 
  JOIN [NewModelERD].[dbo].[Sensor] s ON cv.value = s.UnicName
  where Id_object_type = 1 and cv.Fk_carac = 19 and cv.end_date is not NULL
