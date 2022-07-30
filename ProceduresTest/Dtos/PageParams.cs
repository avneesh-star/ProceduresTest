namespace ProceduresTest.Dtos
{
    public class PageParams
    {
        public int pageNum { get; set; } = 1;
        public int pageSize { get; set; } = 20;
        public string search { get; set; } = string.Empty;
    }
}
