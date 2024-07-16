USE [UNIVER]
GO

--for task 02
/****** Object:  StoredProcedure [dbo].[PSUBJECT]    Script Date: 27.04.2024 10:21:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[PSUBJECT] @p varchar(20) = null, @c int output
as 
begin
	set @c = (select COUNT(*) from [SUBJECT] where [SUBJECT].PULPIT like @p);
	select * from [SUBJECT] where [SUBJECT].PULPIT like @p
	return @c
end;
GO


--for task 03
/****** Object:  StoredProcedure [dbo].[PSUBJECT]    Script Date: 27.04.2024 10:21:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[PSUBJECT] @p varchar(20) = null
as 
begin
	select * from [SUBJECT] where [SUBJECT].PULPIT like @p
end;
GO

