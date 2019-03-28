using FluentMigrator;

namespace MySolution.Database.Migrations
{
    [Migration(2)]
    public class PrimaryEmailColumnRename : Migration
    {
        public override void Up()
        {
            Rename.Column("PrimaryEmail").OnTable("User").InSchema("dbo").To("Email");
        }

        public override void Down()
        {
            Rename.Column("Email").OnTable("User").InSchema("dbo").To("PrimaryEmail");
        }
    }
}
