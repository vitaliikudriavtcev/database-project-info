using FluentMigrator;

namespace MySolution.Database.Migrations
{
    [Migration(3)]
    public class SplitNameColumn : Migration
    {
        public override void Up()
        {
            Create.Column("FirstName").OnTable("User").InSchema("dbo").AsString(100).Nullable();
            Create.Column("LastName").OnTable("User").InSchema("dbo").AsString(100).Nullable();

            Execute.Sql(@"
                UPDATE dbo.[User]
                SET FirstName = LEFT(Name, CHARINDEX(' ', Name) - 1),
                    LastName = RIGHT(Name, LEN(Name) - CHARINDEX(' ', Name))");

            Delete.Column("Name").FromTable("User").InSchema("dbo");
            Alter.Column("FirstName").OnTable("User").InSchema("dbo").AsString(100).NotNullable();
            Alter.Column("LastName").OnTable("User").InSchema("dbo").AsString(100).NotNullable();

            Execute.Sql(@"
                ALTER PROCEDURE [dbo].[sp_SelectUsers]
                AS
                BEGIN
	                SET NOCOUNT ON;

                    SELECT u.UserID, u.FirstName, u.LastName
	                FROM dbo.[User] u
                END");
        }

        public override void Down()
        {
            Create.Column("Name").OnTable("User").InSchema("dbo").AsString(200).Nullable();

            Execute.Sql(@"
                UPDATE dbo.[User]
                SET Name = FirstName + ' ' + LastName");

            Delete.Column("FirstName").FromTable("User").InSchema("dbo");
            Delete.Column("LastName").FromTable("User").InSchema("dbo");
            Alter.Column("Name").OnTable("User").InSchema("dbo").AsString(200).NotNullable();

            Execute.Sql(@"
                ALTER PROCEDURE [dbo].[sp_SelectUsers]
                AS
                BEGIN
	                SET NOCOUNT ON;

                    SELECT u.UserID, u.Name
	                FROM dbo.[User] u
                END");
        }
    }
}
