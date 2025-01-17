using Dapper;
using System.Data.Entity.Infrastructure;
using System.Data;
using LinkShortener.Dto;

namespace LinkShortener
{
    public class LinkRepository
    {
        private readonly IDbConnectionFactory _connectionFactory;

        private const string connectionString =
            "Server=.;Database=LinkShorteningSystem;Trusted_Connection=True; User id=ma; Password=mahdi20667;";
        public LinkRepository(IDbConnectionFactory connectionFactory)
        {
            _connectionFactory = connectionFactory;
        }

        public async Task<string> SaveLinkAsync(string originalUrl)
        {
            using var connection = _connectionFactory.CreateConnection(connectionString);
            var parameters = new DynamicParameters();
            parameters.Add("@OriginalUrl", originalUrl);
            parameters.Add("@ShortUrl", dbType: DbType.String, direction: ParameterDirection.Output, size: 50);

            await connection.ExecuteAsync("sp_SaveLink", parameters, commandType: CommandType.StoredProcedure);
            return parameters.Get<string>("@ShortUrl");
        }

        public async Task<string> GetOriginalUrlAsync(string shortUrl)
        {
            using var connection = _connectionFactory.CreateConnection(connectionString);
            var parameters = new DynamicParameters();
            parameters.Add("@ShortURL", shortUrl);
            parameters.Add("@OriginalURL", dbType: DbType.String, size: 4000, direction: ParameterDirection.Output); // افزودن مقدار size

            await connection.ExecuteAsync("sp_GetOriginalURL", parameters, commandType: CommandType.StoredProcedure);
            var originalUrl = parameters.Get<string>("@OriginalURL");

            if (string.IsNullOrEmpty(originalUrl))
                throw new Exception("Original URL not found or link is expired.");

            return originalUrl;
        }

        public async Task<List<TopLinkDto>> GetTopLinksAsync()
        {
            using var connection = _connectionFactory.CreateConnection(connectionString);
            var result = await connection.QueryAsync<TopLinkDto>(
                "sp_GetTop3Links",
                commandType: CommandType.StoredProcedure);
            return result.ToList();
        }

        public async Task<List<DashboardViewModel>> GetAllLinksAsync()
        {
            using var connection = _connectionFactory.CreateConnection(connectionString);
            var links = await connection.QueryAsync<DashboardViewModel>(
                "EXEC sp_DetailsOfLinks",
                commandType: CommandType.Text
            );
            return links.ToList();
        }
        public async Task<int> GetRegisteredLinksTodayAsync()
        {
            using var connection = _connectionFactory.CreateConnection(connectionString);
            var count = await connection.ExecuteScalarAsync<int>("SELECT dbo.f_CountRegisterdLinkToday()");
            return count;
        }

        public async Task<int> GetReferredLinksTodayAsync()
        {
            using var connection = _connectionFactory.CreateConnection(connectionString);
            var count = await connection.ExecuteScalarAsync<int>("SELECT dbo.f_CountReferToshortenedlinksToday()");
            return count;
        }
    }


}
