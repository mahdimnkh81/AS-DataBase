use LinkShorteningSystem

CREATE TABLE tblLinks (
    LinkID INT IDENTITY(1,1) PRIMARY KEY,
    OriginalURL NVARCHAR(MAX) NOT NULL,
    ShortURL NVARCHAR(50) UNIQUE NOT NULL,
    CreationDate DATETIME DEFAULT GETDATE(),
    ExpirationDate DATETIME NOT NULL,
    IsExpired BIT DEFAULT 0,
	IsDeleted bit Default 0
);


CREATE TABLE tblStatistics (
    StatID INT IDENTITY(1,1) PRIMARY KEY,
    ShortURL NVARCHAR(50) NOT NULL FOREIGN KEY REFERENCES tblLinks(ShortURL),
    AccessDate DATETIME DEFAULT GETDATE()
);

Alter procedure sp_SaveLink
	@OriginalUrl Nvarchar(max),
	@ShortUrl Nvarchar(50) output
As
Begin 
	SET NOCOUNT ON;

	IF EXists(select 1 from tblLinks where OriginalURL = @OriginalUrl)
	Begin
		select @ShortUrl = ShortUrl From tblLinks where OriginalUrl = @OriginalUrl;
		return 0;
	END

	DECLARE @Chars NVARCHAR(62) = 'abcdefghijklmnopqrstuvwxyz0123456789';
	DECLARE @RandomString NVARCHAR(6);
	DECLARE @i INT = 1;

	SET @RandomString = '';

	WHILE @i <= 6
	BEGIN
		SET @RandomString = @RandomString + SUBSTRING(@Chars, ABS(CHECKSUM(NEWID())) % LEN(@Chars) + 1, 1);
		SET @i = @i + 1;
	END


	INSERT INTO tblLinks (OriginalURL, ShortURL, ExpirationDate)
    VALUES (@OriginalURL, @RandomString, DATEADD(DAY, 7, GETDATE()));
	
	set @ShortUrl = @RandomString
	return 0;
End

Alter PROCEDURE sp_GetOriginalURL
    @ShortURL NVARCHAR(50),
    @OriginalURL NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM tblLinks WHERE ShortURL = @ShortURL)
    BEGIN

        IF EXISTS (
            SELECT 1 
            FROM tblLinks 
            WHERE ShortURL = @ShortURL 
              AND ExpirationDate > GETDATE() 
              AND IsExpired = 0
        )
        BEGIN

            SELECT @OriginalURL = OriginalURL 
            FROM tblLinks 
            WHERE ShortURL = @ShortURL;
      
            INSERT INTO tblStatistics (ShortURL)
            VALUES (@ShortURL);
			-- trigger call here 
        END
        ELSE
        BEGIN
            
            ROLLBACK TRANSACTION;
            RAISERROR ('The link is expired...', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('The link does not exist...', 16, 1);
        RETURN;
    END

    COMMIT TRANSACTION;
END;

/* After insert data to tblStatistics check expire time for link */
CREATE TRIGGER trg_LogAccessAndExpire
ON tblStatistics
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE tblLinks
    SET IsExpired = 1
    WHERE ExpirationDate <= GETDATE() 
      
END;







Create Function f_CountRegisterdLinkToday()
RETURNS int
AS
BEGIN
    DECLARE @numberOfRegisterdLinkToday int;
    SELECT @numberOfRegisterdLinkToday = Count(LinkID)
    FROM dbo.tblLinks t
    WHERE CAST(t.CreationDate AS DATE) = CAST(GETDATE() AS DATE) and t.IsDeleted = 0;
    RETURN @numberOfRegisterdLinkToday;
END;

SELECT dbo.f_CountRegisterdLinkToday();

Create Function f_CountReferToshortenedlinksToday()
RETURNS int
AS
BEGIN
    DECLARE @numberOfReferToshortenedlinksToday int;
    SELECT @numberOfReferToshortenedlinksToday = Count(StatID)
    FROM dbo.tblStatistics t
    WHERE CAST(t.AccessDate AS DATE) = CAST(GETDATE() AS DATE);
    RETURN @numberOfReferToshortenedlinksToday;
END;

SELECT dbo.f_CountReferToshortenedlinksToday();

CREATE PROCEDURE sp_GetTop3Links
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 3 
        l.ShortURL,
        l.OriginalURL,
        COUNT(s.StatID) AS TotalAccesses
    FROM tblStatistics s
    INNER JOIN tblLinks l ON s.ShortURL = l.ShortURL
    GROUP BY l.ShortURL, l.OriginalURL
    ORDER BY TotalAccesses DESC;
END;

EXEC sp_GetTop3Links;

Alter PROCEDURE sp_DetailsOfLinks
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        l.ShortURL,
        l.OriginalURL,
        ISNULL(COUNT(s.StatID), 0) AS TotalAccesses,
        DATEDIFF(DAY, GETDATE(), l.ExpirationDate) AS RemainingExpiration
    FROM tblLinks l
    LEFT JOIN tblStatistics s ON l.ShortURL = s.ShortURL where l.IsDeleted = 0
    GROUP BY l.ShortURL, l.OriginalURL, l.ExpirationDate
    ORDER BY TotalAccesses DESC;
END;

EXEC sp_DetailsOfLinks;
