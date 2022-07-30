namespace ProceduresTest.Dtos
{
    public class Response
    {
       
        public Response(bool success, string message, object result)
        {
            this.success = success;
            this.message = message;
            this.result = result;
        }
        public Response(bool success, string message)
        {
            this.success = success;
            this.message = message;
            this.result = new { };
        }

        public Response(object result)
        {
            this.success = true;
            this.message = "Request success";
            this.result = result;
        }

        public bool success { get; set; }
        public string message { get; set; }
        public object result { get; set; }
    }
}
