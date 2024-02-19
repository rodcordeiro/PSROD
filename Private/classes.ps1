
Add-Type -Language CSharp -TypeDefinition @"
    public class PDAEnvironmentConfig
    {
    public string env { get; set; }
    public string path { get; set; }
    public string type { get; set; }
    public string iisSite { get; set; }
    public string scheduledTask { get; set; }
    public string winsowsService { get; set; }

    }
    public class PDAConfig {
        public string name {get;set;}
        public string files {get;set;}
        public string exclude {get;set;}
        public PDAEnvironmentConfig env {get;set;}
    }

    public class Repository {
        public string repo {get;set;}
        public string alias {get;set;}
        public string[] branches {get;set;}
    }

    public class Repositories {
        public string parent {get;set;}
        public Repository[] repos {get;set;}
    }
"@
