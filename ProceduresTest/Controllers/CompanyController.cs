using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ProceduresTest.Dtos;
using ProceduresTest.Services;

namespace ProceduresTest.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CompanyController : ControllerBase
    {
        private readonly ICompanyService _company;

        public CompanyController(ICompanyService company)
        {
            _company = company;
        }

        [HttpPost]
        public async  Task<IActionResult> Create(CompanyDto dto)
        {
            var response = await _company.Create(dto);
            return Ok(response);
        }

        [HttpPut]
        public async Task<IActionResult> Update(CompanyDto dto)
        {
            var response = await _company.Update(dto);
            return Ok(response);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] string id)
        {
            var response = await _company.Delete(id);
            return Ok(response);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Get([FromRoute] string id)
        {
            var response = await _company.GetCompany(id);
            return Ok(response);
        }

        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery]PageParams page)
        {
            var response = await _company.GetAllCompany(page);
            return Ok(response);
        }
    }
}
