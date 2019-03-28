using FluentMigrator;

namespace MySolution.Database.Migrations
{
    [Migration(1)]
    public class Initial : Migration
    {
        public override void Up()
        {
            Create.Table("User")
                .WithColumn("UserID").AsInt64().NotNullable().PrimaryKey()
                .WithColumn("Name").AsString(200).NotNullable()
                .WithColumn("PrimaryEmail").AsString(256).NotNullable()
                .WithColumn("Status").AsString(50).NotNullable();

            Execute.Sql(@"
                CREATE PROCEDURE [dbo].[sp_SelectUsers]
                AS
                BEGIN
	                SET NOCOUNT ON;

                    SELECT u.UserID, u.Name
	                FROM dbo.[User] u
                END");
        }

        public override void Down()
        {
            Delete.Table("User");
            Execute.Sql("DROP PROCEDURE [dbo].[sp_SelectUsers]");
        }
    }
}
