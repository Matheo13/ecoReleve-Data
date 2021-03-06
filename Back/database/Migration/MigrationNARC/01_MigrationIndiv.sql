-----------------------------------INSERT Static Prop Values -------------------------------------------------------------
SET IDENTITY_INSERT  Individual ON

INSERT INTO Individual (
ID,
[creationDate],
Age,
Species,
Birth_date,
Death_date,
Original_ID,
fk_individualType
)
SELECT 
		I.Individual_Obj_PK
		,o.[Creation_date]
      ,[id2@Thes_Age_Precision]
	  ,[id34@TCaracThes_Species_Precision]
      ,[id35@Birth_date]
      ,[id36@Death_date]
	  ,'eReleve_'+CONVERT(VARCHAR,Individual_Obj_PK)
	  , IT.ID
FROM [NARC_eReleveData].[dbo].[TViewIndividual] I
JOIN [NARC_eReleveData].[dbo].TObj_Objects o on I.Individual_Obj_PK = o.Object_Pk
JOIN IndividualType IT ON  IT.name ='Standard'
GO


SET IDENTITY_INSERT  Individual OFF

-----------------------------------INSERT Sex in Dynamic Prop Values -------------------------------------------------------------
INSERT INTO IndividualDynPropValue(
		[StartDate]
      ,[ValueString]
      ,[FK_IndividualDynProp]
      ,[FK_Individual]
) 
SELECT I.[creationDate],
		IV.[id30@TCaracThes_Sex_Precision],
		(SELECT ID FROM IndividualDynProp WHERE Name = 'Sex'),
		IV.Individual_Obj_PK
FROM [NARC_eReleveData].[dbo].[TViewIndividual] IV 
JOIN Individual I ON IV.Individual_Obj_PK = I.ID
GO



WITH toto as (
SELECT 
	cv.begin_date as StartDate,
	dp.TypeProp,
	s.ID as IndivID,
	dp.Name as dynPropName,
	dp.ID as dynPopID,
	typ.name, 
	CASE WHEN cv.value_precision IS not null THEN cv.value_precision 
	ELSE cv.value END as Value,
	s.Original_ID 

  FROM [NARC_eReleveData].[dbo].[TObj_Carac_value] cv
  JOIN [NARC_eReleveData].[dbo].[TObj_Carac_type] typ 
		ON cv.Fk_carac = typ.Carac_type_Pk 
  JOIN dbo.IndividualDynProp dp 
		ON 'TCaracThes_'+dp.Name = typ.name 
		or 'TCarac_'+dp.Name = typ.name 
		or dp.Name = typ.name 
		or 'Thes_'+dp.Name = typ.name 
		or 'Thes_txt_'+dp.Name = typ.name
		or 'TCaracThes_txt_'+dp.Name = typ.name
  JOIN dbo.Individual s on cv.fk_object = s.ID
  where [object_type] = 'Individual'
  )


INSERT INTO [dbo].[IndividualDynPropValue]
	([StartDate]
      ,[ValueInt]
      ,[ValueString]
      ,[ValueDate]
      ,[ValueFloat]
      ,[FK_IndividualDynProp]
      ,[FK_Individual]
)
SELECT 
	toto.StartDate,
	CASE WHEN toto.TypeProp = 'Integer' THEN toto.value else NULL end as ValueInt,
	CASE WHEN toto.TypeProp = 'String' THEN toto.value else NULL end as ValueString,
	CASE WHEN toto.TypeProp = 'Date' THEN toto.value else NULL end as ValueDate,
	CASE WHEN toto.TypeProp = 'Float' THEN toto.value else NULL end as ValueFloat,
	toto.dynPopID,
	toto.IndivID
FROM toto;

--GO

/****** Script for SelectTopNRows command from SSMS  ******/
--INSERT LAST END DATE 
WITH TOTO as (SELECT 
val.end_date as StartDate,
NULL as ValueInt,
NULL as ValueString,
NULL as ValueDate,
NULL as ValueFloat,
dp.ID as FK_IndividualDynProp,
I_I.ID as FK_Individual
FROM [NARC_eReleveData].[dbo].[TObj_Carac_value] val 
JOIN [NARC_eReleveData].[dbo].[TObj_Carac_type] typ on typ.Carac_type_Pk = val.Fk_carac
JOIN IndividualDynProp dp ON 'TCaracThes_'+dp.Name = typ.name or 'TCarac_'+dp.Name = typ.name or  'Thes_'+dp.Name = typ.name
JOIN Individual I_I ON  val.fk_object = I_I.ID
where end_date is not null )


INSERT INTO IndividualDynPropValue(
		[StartDate]
      ,[ValueInt]
      ,[ValueString]
      ,[ValueDate]
      ,[ValueFloat]
      ,[FK_IndividualDynProp]
      ,[FK_Individual]
)
SELECT  toto.*
  FROM [EcoReleve_NARC].[dbo].[IndividualDynPropValuesNow] v 
  JOIN toto ON v.FK_Individual = TOTO.FK_Individual and v.FK_IndividualDynProp = toto.FK_IndividualDynProp and v.StartDate < toto.StartDate
 -- where toto.FK_IndividualDynProp = 17

--with tutu as (
--select Distinct cv.value,cv.value_precision
--from [NARC_eReleveData].dbo.TObj_Carac_value cv 
--JOIN [NARC_eReleveData].dbo.TObj_Carac_type ct ON cv.Fk_carac = ct.Carac_type_Pk
--Where cv.value_precision is not null 
--)

/*

Update v set ValueString = th.TTop_FullPath
	FROM IndividualDynPropValue v
  JOIN dbo.IndividualDynProp dp ON v.FK_IndividualDynProp = dp.ID
  JOIN dbo.Individual i on v.FK_Individual = I.ID
  JOIN tutu ON tutu.value_precision = v.ValueString
  LEFT join THESAURUS.dbo.TTopic th 
		ON th.TTop_PK_ID> 204082
		and th.TTop_NameEn = v.ValueString 
		and tutu.value+204081 = th.TTop_PK_ID
  where  dp.name not in 
  ('Chip_Code','Comments','Individual_Status','Release_Ring_Code','Breeding_Ring_Code','Mark_code_1','Mark_code_2' )
  
  
  	 
  */