namespace LinkShortener.Dto
{
    public class TopLinkDto
    {
        public string ShortURL { get; set; }       
        public string OriginalURL { get; set; }  
        public int TotalAccesses { get; set; }    
    }
    public class DashboardViewModel
    {
        public string ShortURL { get; set; }
        public string OriginalURL { get; set; }
        public int TotalAccesses { get; set; }
        public int RemainingExpiration { get; set; }
    }
}
