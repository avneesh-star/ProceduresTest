namespace ProceduresTest.Dtos
{
    public class Pagination
    {
        public Pagination(int PageSize, int totalCount)
        {
            this.PageSize = PageSize;
            this.totalCount = totalCount;
            this.totalPages = GetTotalpages(PageSize, totalCount);
        }

        public int PageSize { get; set; }
        public int totalCount { get; set; } 
        public int totalPages { get; set; }

        private int GetTotalpages(int PageSize, int totalCount)
        {
            var p = Convert.ToDecimal(totalCount) / PageSize;
            return Convert.ToInt32(Math.Ceiling(p));
        }
    }
}
