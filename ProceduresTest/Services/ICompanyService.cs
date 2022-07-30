using ProceduresTest.Dtos;

namespace ProceduresTest.Services
{
    public interface ICompanyService
    {
        Task<Response> Create(CompanyDto dto);
        Task<Response> Update(CompanyDto dto);
        Task<Response> Delete(string companyId);
        Task<Response> GetCompany(string companyId);
        Task<Response> GetAllCompany(PageParams page);
    }
}
