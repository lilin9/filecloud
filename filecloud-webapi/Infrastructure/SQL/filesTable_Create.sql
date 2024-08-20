USE [db_filecloud]
GO

/****** Object:  Table [dbo].[Files]    Script Date: 2024/8/14 9:05:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Files](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FileId] [uniqueidentifier] NOT NULL,
	[UserInfoId] [uniqueidentifier] NULL,
	[ParentId] [uniqueidentifier] NULL,
	[FileName] [nvarchar](1024) NOT NULL,
	[CreateTime] [datetime2](7) NOT NULL,
	[UpdateTime] [datetime2](7) NOT NULL,
	[FileSize_Value] [float] NOT NULL,
	[FileSize_Unit] [nvarchar](20) NOT NULL,
	[FileMimeType] [nvarchar](128) NULL,
	[FileOnlyTag] [nvarchar](128) NULL,
	[IsDisable] [bit] NOT NULL,
	[IsFolder] [bit] NOT NULL,
 CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'数据库自增Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Files', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'唯一标识' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Files', @level2type=N'COLUMN',@level2name=N'FileId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'用户信息Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Files', @level2type=N'COLUMN',@level2name=N'UserInfoId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'父级Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Files', @level2type=N'COLUMN',@level2name=N'ParentId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'文件名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Files', @level2type=N'COLUMN',@level2name=N'FileName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Files', @level2type=N'COLUMN',@level2name=N'UpdateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'文件的mime类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Files', @level2type=N'COLUMN',@level2name=N'FileMimeType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'文件的唯一标识，表示给用户看的' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Files', @level2type=N'COLUMN',@level2name=N'FileOnlyTag'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'当前文件是否被禁止被访问' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Files', @level2type=N'COLUMN',@level2name=N'IsDisable'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否为文件夹' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Files', @level2type=N'COLUMN',@level2name=N'IsFolder'
GO


