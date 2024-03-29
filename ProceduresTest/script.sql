/****** Object:  Database [MyTestDb]    Script Date: 31-07-2022 01:24:47 ******/
CREATE DATABASE [MyTestDb]

/*
SELECT dbo.fn_GetCount()
*/
CREATE FUNCTION [dbo].[fn_GetCount]()
RETURNS INT
AS
BEGIN
	RETURN 10
END
GO
/****** Object:  Table [dbo].[tblCompany]    Script Date: 31-07-2022 01:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompany](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [varchar](200) NULL,
	[State] [varchar](200) NULL,
	[City] [varchar](200) NULL,
	[Address] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[tblCompany] ADD  DEFAULT (lower(newid())) FOR [Id]
GO
/****** Object:  StoredProcedure [dbo].[Usp_Company_details]    Script Date: 31-07-2022 01:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
EXEC Usp_Company_details '8b71e9c0-7291-414c-9e5e-60994e97387a','a30'
*/

CREATE PROCEDURE [dbo].[Usp_Company_details]
(
@Id varchar(128) = '',
@search varchar(100) = '',
@PageNum int = 1,
@PageSize int = 20
)
AS
BEGIN
	SET @id = ISNULL(@Id, '')

	IF(@id = '')
	BEGIN
		DECLARE  @icount  int

		SELECT @icount = count(Id)
		FROM tblcompany
		WHERE @search = ''
			OR
			(
				[Name] LIKE '%'+@search+'%' 
				OR  [State] LIKE '%'+@search+'%'
				OR  City LIKE '%'+@search+'%'
				OR  [Address] LIKE '%'+@search+'%' 
			)

		SELECT Id, [Name],[State],City,[Address]
		FROM tblcompany
		WHERE @search = ''
			OR
			(
				[Name] LIKE '%'+@search+'%' 
				OR  [State] LIKE '%'+@search+'%'
				OR  City LIKE '%'+@search+'%'
				OR  [Address] LIKE '%'+@search+'%' 
			)
		ORDER BY id DESC
		OFFSET (@PageNum-1)*@PageSize ROWS
		FETCH NEXT @PageSize ROWS ONLY
		RETURN @icount

	END
	ELSE
	BEGIN
		SELECT Id, [Name],[State],City,[Address]
		FROM tblcompany
		WHERE id = @id
	END
END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Company_Update]    Script Date: 31-07-2022 01:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
tblCompany
DECLARE 
@Action int = 1,
@Name varchar(200)= 'ABC TRANSFORMERS',
@State varchar(200)= 'UP',
@City varchar(200)= 'NOIDA',
@Address varchar(1000)= 'A30, SECTOR-50',
@Result varchar(200),
@Id varchar(200)

EXEC Usp_Company_Update @Action, @Name, @State, @City, @Address, @Result OUT,@Id OUT
*/

CREATE PROCEDURE [dbo].[Usp_Company_Update]
(
@Action int,
--@CompanyId nvarchar(128) = '',
@Name varchar(200)= '',
@State varchar(200)= '',
@City varchar(200)= '',
@Address varchar(1000)= '',
@Result varchar(200) OUT,
@Id varchar(200) out
)
AS
BEGIN
	declare @CompanyId nvarchar(128) 
	PRINT '@ID=>'+ @Id
	SET @CompanyId = @Id
	SET @CompanyId = ISNULL(@CompanyId,'')
	IF(@Action = 1)
	BEGIN
		IF EXISTS
		(
			SELECT ID
			FROM tblcompany
			where [name] = @Name
		)
		BEGIN
			SET @Result = 'company already exists!'
			RETURN
		END
		ELSE
		BEGIN
			SET @Id = LOWER(NEWID())

			INSERT INTO tblcompany(id, [name], [state], city, [address])
			VALUES(@Id, @Name, @State, @City, @Address)
			IF(@@ERROR <> 0)
			BEGIN
				SET @Result = 'server error!'
				RETURN
			END
			SET @Result = 'success'
		END
	END

	IF(@Action = 2)
	BEGIN
		IF EXISTS
		(
			SELECT ID
			FROM tblcompany
			where [name] = @Name AND id <> @CompanyId
		)
		BEGIN
			SET @Result = 'company already exists!'
			RETURN
		END
		ELSE
		BEGIN
			UPDATE tblcompany 
			SET [name] = CASE WHEN LEN(@Name)>0 THEN @Name ELSE [name] END,
			[State] = CASE WHEN LEN(@Name)>0 THEN @State ELSE [State] END,
			[City] = CASE WHEN LEN(@Name)>0 THEN @City ELSE [City] END,
			[Address] = CASE WHEN LEN(@Name)>0 THEN @Address ELSE [Address] END
			WHERE id = @CompanyId
			IF(@@ERROR <> 0)
			BEGIN
				SET @Result = 'server error!'
				RETURN
			END
			SET @Result = 'success'
		END
	END
	IF(@Action = 3)
	BEGIN
		DELETE FROM  tblcompany 
		WHERE id = @CompanyId
		IF(@@ERROR <> 0)
		BEGIN
			SET @Result = 'server error!'
			RETURN
		END
		SET @Result = 'success'
	END
END
GO
ALTER DATABASE [MyTestDb] SET  READ_WRITE 
GO
