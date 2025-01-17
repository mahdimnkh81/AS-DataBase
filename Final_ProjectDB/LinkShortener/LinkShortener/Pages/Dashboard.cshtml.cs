using LinkShortener.Dto;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace LinkShortener.Pages
{
    public class DashboardModel : PageModel
    {
        private readonly LinkRepository _linkRepository;

        public DashboardModel(LinkRepository linkRepository)
        {
            _linkRepository = linkRepository;
        }

        [BindProperty]
        public string OriginalUrl { get; set; }

        [BindProperty]
        public string ShortUrl { get; set; } 

        public string RetrievedOriginalUrl { get; set; } 

        public List<TopLinkDto> TopLinks { get; set; } = new();
        public List<DashboardViewModel> Links { get; set; } = new();

        public int RegisteredLinksToday { get; set; }
        public int ReferredLinksToday { get; set; }

        public async Task OnGetAsync()
        {
            RegisteredLinksToday = await _linkRepository.GetRegisteredLinksTodayAsync();
            ReferredLinksToday = await _linkRepository.GetReferredLinksTodayAsync();

            TopLinks = await _linkRepository.GetTopLinksAsync();

            var allLinks = await _linkRepository.GetAllLinksAsync();
            Links = new List<DashboardViewModel>();

            foreach (var link in allLinks)
            {
                Links.Add(new DashboardViewModel
                {
                    ShortURL = link.ShortURL,
                    OriginalURL = link.OriginalURL,
                    TotalAccesses = link.TotalAccesses,
                    RemainingExpiration = link.RemainingExpiration
                });
            }
        }

        public async Task<IActionResult> OnPostCreateShortUrlAsync()
        {
            if (string.IsNullOrWhiteSpace(OriginalUrl))
            {
                ModelState.AddModelError(string.Empty, "Please provide a valid URL.");
                return Page();
            }

            var shortUrl = await _linkRepository.SaveLinkAsync(OriginalUrl);
            TempData["Message"] = $"Short URL created: {shortUrl}";

            return RedirectToPage();
        }

        public async Task<IActionResult> OnPostRetrieveOriginalUrlAsync()
        {
            if (string.IsNullOrWhiteSpace(ShortUrl))
            {
                ModelState.AddModelError(string.Empty, "Please provide a valid Short URL.");
                return Page();
            }

            try
            {
                RetrievedOriginalUrl = await _linkRepository.GetOriginalUrlAsync(ShortUrl);
                TempData["Message"] = $"Original URL: {RetrievedOriginalUrl}";
            }
            catch (Exception ex)
            {
                TempData["Error"] = $"Error retrieving original URL: {ex.Message}";
            }

            return RedirectToPage();
        }
    }
}
