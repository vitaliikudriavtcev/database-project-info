using FluentMigrator;

namespace MySolution.Database.Migrations
{
    [Migration(6)]
    public class AddEmailTo_sp_SelectUsers : Migration
    {
        public override void Up()
        {
            Execute.Script(@"StoredProcedures\sp_SelectUsers.sql");
        }

        public override void Down()
        {
        }
    }
}
