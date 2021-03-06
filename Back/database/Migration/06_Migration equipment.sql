

/* 78255*/


-------------- INSERT Individual Deploy equipment -------------------------------------------------------------------
INSERT INTO [Equipment]
           ([FK_Sensor]
           ,[FK_Individual]
           ,[StartDate]
           ,[Deploy])
SELECT
s.ID,
i.ID,
cv.[begin_date],
1
  FROM [ECWP-eReleveData].[dbo].[TObj_Objects] o 
  JOIN [ECWP-eReleveData].[dbo].[TObj_Obj_CaracList] cl ON o.Id_object_type = cl.fk_Object_type 
  JOIN [ECWP-eReleveData].[dbo].[TObj_Carac_type] ct ON cl.fk_Carac_type = ct.Carac_type_Pk
  JOIN [ECWP-eReleveData].[dbo].[TObj_Carac_value] cv ON o.[Object_Pk] = cv.[fk_object] and ct.Carac_type_Pk = cv.Fk_carac
  JOIN [Individual] i ON 'eReleve_'+CONVERT(VARCHAR,o.Object_Pk) = i.Original_ID 
  JOIN [Sensor] s ON cv.value = s.UnicIdentifier
  where Id_object_type = 1 and cv.Fk_carac = 19

Go

-------------- INSERT Individual Remove equipment -------------------------------------------------------------------
INSERT INTO [Equipment]
           ([FK_Sensor]
           ,[FK_Individual]
           ,[StartDate]
           ,[Deploy])
SELECT 
s.ID,
i.ID,
cv.[end_date],
0
  FROM [ECWP-eReleveData].[dbo].[TObj_Objects] o 
  JOIN [ECWP-eReleveData].[dbo].[TObj_Obj_CaracList] cl ON o.Id_object_type = cl.fk_Object_type 
  JOIN [ECWP-eReleveData].[dbo].[TObj_Carac_type] ct ON cl.fk_Carac_type = ct.Carac_type_Pk
  JOIN [ECWP-eReleveData].[dbo].[TObj_Carac_value] cv ON o.[Object_Pk] = cv.[fk_object] and ct.Carac_type_Pk = cv.Fk_carac
  JOIN [Individual] i ON 'eReleve_'+CONVERT(VARCHAR,o.Object_Pk) = i.Original_ID 
  JOIN [Sensor] s ON cv.value = s.UnicIdentifier
  where Id_object_type = 1 and cv.Fk_carac = 19 and cv.end_date is not NULL


  -------------- INSERT Individual Deploy equipment -------------------------------------------------------------------
INSERT INTO [Equipment]
           ([FK_Sensor]
           ,[FK_MonitoredSite]
           ,[StartDate]
           ,[Deploy])
SELECT  s.ID, m.ID, oldE.begin_date,1
FROM [ECWP-eReleveData].[dbo].[T_MonitoredSiteEquipment] oldE 
JOIN [Sensor] s ON oldE.PK_id = replace(s.Original_ID,'VHF_','')
JOIN MonitoredSite m ON oldE.FK_site = m.Original_ID

GO

-------------- INSERT RFID Deploy equipment -------------------------------------------------------------------

INSERT INTO [Equipment]
           ([FK_Sensor]
           ,[FK_MonitoredSite]
           ,[StartDate]
           ,[Deploy])
select S.id,MS.id,ME.begin_date,1
from [ECWP-eReleveData].[dbo].[T_Object] o JOIN [ECWP-eReleveData].[dbo].[T_MonitoredSiteEquipment] ME on ME.FK_obj = o.PK_id
JOIN [Sensor] s ON o.PK_id = replace(s.Original_ID,'VHF_','')
JOIN MonitoredSite MS on MS.Original_ID = ME.FK_site
where o.type_='rfid'

GO

-------------- INSERT RFID Remove equipment -------------------------------------------------------------------

INSERT INTO [Equipment]
           ([FK_Sensor]
           ,[FK_MonitoredSite]
           ,[StartDate]
           ,[Deploy])
select S.id,MS.id,ME.end_date,0
from [ECWP-eReleveData].[dbo].[T_Object] o JOIN [ECWP-eReleveData].[dbo].[T_MonitoredSiteEquipment] ME on ME.FK_obj = o.PK_id
JOIN [Sensor] s ON o.PK_id = replace(s.Original_ID,'VHF_','')
JOIN MonitoredSite MS on MS.Original_ID = ME.FK_site
where o.type_='rfid'
go


-------------- INSERT VHF deploy equipment -------------------------------------------------------------------


INSERT INTO [Equipment]
           ([FK_Sensor]
           ,[FK_Individual]
           ,[StartDate]
           ,[Deploy])
SELECT
s.ID,
i.ID,
cv.[begin_date],
1
  FROM [ECWP-eReleveData].[dbo].[TObj_Carac_value] cv 
	 --frequency
  left JOIN [ECWP-eReleveData].[dbo].[TObj_Carac_value] cv2 ON cv.[fk_object] = cv2.[fk_object] 
		and CONVERT(DATE,cv.begin_date) = CONVERT(DATE,cv2.begin_date)
		and cv2.Fk_carac =6  --serialnumber
  JOIN [Individual] i ON 'eReleve_'+CONVERT(VARCHAR,cv.[fk_object]) = i.Original_ID 
  JOIN [Sensor] s ON CONVERT(VARCHAR,cv.value)+'_'+ CONVERT(VARCHAR,cv2.value) = s.UnicIdentifier
  where cv.[object_type] = 'Individual' and cv.Fk_carac = 5

Go


-------------- INSERT VHF remove equipment -------------------------------------------------------------------

INSERT INTO [Equipment]
           ([FK_Sensor]
           ,[FK_Individual]
           ,[StartDate]
           ,[Deploy])
SELECT
s.ID,
i.ID,
cv.end_date,
0
  FROM [ECWP-eReleveData].[dbo].[TObj_Carac_value] cv 
	 --frequency
  left JOIN [ECWP-eReleveData].[dbo].[TObj_Carac_value] cv2 ON cv.[fk_object] = cv2.[fk_object] 
		and CONVERT(DATE,cv.begin_date) = CONVERT(DATE,cv2.begin_date)
		and cv2.Fk_carac =6  --serialnumber
  JOIN [Individual] i ON 'eReleve_'+CONVERT(VARCHAR,cv.[fk_object]) = i.Original_ID 
  JOIN [Sensor] s ON CONVERT(VARCHAR,cv.value)+'_'+ CONVERT(VARCHAR,cv2.value) = s.UnicIdentifier
  where cv.[object_type] = 'Individual' and cv.Fk_carac = 5 and cv.end_date is not null 

Go