if exists (select table_name from INFORMATION_SCHEMA.tables where TABLE_NAME='Payments')
	drop table dbo.payments

create table dbo.Payments
	([DateTimePaid] [datetime] NULL,
	[ClubID] [int] NULL,
	[FineID] [int],
	[PaymentMethod] [varchar](255) NULL,
	[PaymentReason] [varchar](255) NULL,
	[AmountPaid] [decimal](9, 2) NULL CONSTRAINT [DF__Payments__Amount__3A5795F5]  DEFAULT ((0)),
	[PaymentFee] [decimal](9, 2) NULL,
	[PaymentID] [int] NOT NULL CONSTRAINT [DF__Payments__PayPal__3B4BBA2E]  DEFAULT ((0)),
	[Note] [varchar](255) NULL CONSTRAINT [DF__Payments__Paypal__3C3FDE67]  DEFAULT (''),
	[TransactionID] [varchar](32) NULL CONSTRAINT [DF__Payments__PayPal__3D3402A0]  DEFAULT (''),
	[PaidBy] [varchar](1000) NULL,
	)
GO
ALTER TABLE Payments
	ADD  CONSTRAINT PK_Payments PRIMARY KEY CLUSTERED 
		(PaymentID)
GO

if exists (select table_name from INFORMATION_SCHEMA.tables where TABLE_NAME='PaymentsHistory')
	drop table dbo.PaymentsHistory

create table dbo.PaymentsHistory
	([DateTimePaid] [datetime] NULL,
	[ClubID] [int] NULL,
	[FineID] [int],
	[PaymentMethod] [varchar](255) NULL,
	[PaymentReason] [varchar](255) NULL,
	[AmountPaid] [decimal](9, 2) NULL,
	[PaymentFee] [decimal](9, 2) NULL,
	[PaymentID] [int] NOT NULL,
	[Note] [varchar](255) NULL,
	[TransactionID] [varchar](32) NULL,
	[PaidBy] [varchar](1000) NULL,
	)
GO
ALTER TABLE PaymentsHistory
	ADD  CONSTRAINT PK_PaymentsHistory PRIMARY KEY CLUSTERED 
		(PaymentID)
GO

    


