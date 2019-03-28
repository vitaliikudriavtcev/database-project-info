using FluentMigrator;

namespace MySolution.Database.Migrations
{
    [Migration(7)]
    public class AddStatusTo_sp_SelectUsers : Migration
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
