using ProceduresTest.Data;
using ProceduresTest.Dtos;
using ProceduresTest.Enums;

namespace ProceduresTest.Services
{
    public class CompanyService: ICompanyService
    {
        private readonly AppDbContext _context;

        public CompanyService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<Response> Create(CompanyDto dto)
        {
            var result = new OutputParameter<string>();
            var id = new OutputParameter<string>();

            var _ = await _context.Procedures.Usp_Company_UpdateAsync((int)SqlAction.insert, dto.Name, dto.State, dto.City, dto.Address, result, id);

            if (result.Value == "success")
            {
                dto.Id = id.Value;
                return new Response(dto);
            }
            else
            {
                return new Response(false, result.Value);
            }

        }

        public async Task<Response> Update(CompanyDto dto)
        {
            var result = new OutputParameter<string>();
            var id = new OutputParameter<string>();
            id.SetValue(dto.Id);

            var _ = await _context.Procedures.Usp_Company_UpdateAsync((int)SqlAction.update, dto.Name, dto.State, dto.City, dto.Address, result, id);

            if (result.Value == "success")
            {
                dto.Id = id.Value;
                return new Response(dto);
            }
            else
            {
                return new Response(false, result.Value);
            }

        }

        public async Task<Response> Delete(string companyId)
        {
            var result = new OutputParameter<string>();
            var id = new OutputParameter<string>();
            id.SetValue(companyId);

            var _ = await _context.Procedures.Usp_Company_UpdateAsync((int)SqlAction.delete, string.Empty, string.Empty, string.Empty, string.Empty, result, id);

            if (result.Value == "success")
            {
                return new Response(true,"company deleted successfully.");
            }
            else
            {
                return new Response(false, result.Value);
            }

        }

        public async Task<Response> GetCompany(string companyId)
        {
          
            var company = await _context.Procedures.Usp_Company_detailsAsync(companyId,String.Empty,0,0);

            if (company != null)
            {
                return new Response(company.FirstOrDefault());
            }
            else
            {
                return new Response(true, "No record found.",new { });
            }

        }

        public async Task<Response> GetAllCompany(PageParams page)
        {
            var outPut = new OutputParameter<int>();

            var company = await _context.Procedures.Usp_Company_detailsAsync(string.Empty,page.search, page.pageNum,page.pageSize, outPut);

            if (company != null)
            {
                var data = new Dictionary<string, object>();
                data.Add("values", company);
                data.Add("pages", new Pagination(page.pageSize,outPut.Value));
                return new Response(data);
            }
            else
            {
                return new Response(true, "No record found.", company);
            }

        }

    }
}
