using FluentMigrator;

namespace MySolution.Database.Migrations
{
    [Migration(4)]
    public class ExtractStatusTable : Migration
    {
        public override void Up()
        {
            Create.Table("UserStatus")
                .WithColumn("UserStatusID").AsInt64().NotNullable().PrimaryKey()
                .WithColumn("Name").AsString(50).NotNullable();

            Execute.Sql(@"
                INSERT dbo.UserStatus (UserStatusID, Name) VALUES (1, 'Regular')
                INSERT dbo.UserStatus (UserStatusID, Name) VALUES (2, 'Preferred')
                INSERT dbo.UserStatus (UserStatusID, Name) VALUES (3, 'Gold')");

            Create.Column("StatusID").OnTable("User").InSchema("dbo").AsInt64().Nullable()
                .ForeignKey("FK_User_StatusID", "UserStatus", "UserStatusID");

            Execute.Sql(@"
                UPDATE dbo.[User]
                SET StatusID = 
                    CASE WHEN [Status] = 'Preferred' THEN 2
                    WHEN [Status] = 'Gold' THEN 3
                    ELSE 1 END");

            Delete.Column("Status").FromTable("User").InSchema("dbo");
            Alter.Column("StatusID").OnTable("User").InSchema("dbo").AsInt64().NotNullable();
        }

        public override void Down()
        {
            Create.Column("Status").OnTable("User").InSchema("dbo").AsString(50).Nullable();

            Execute.Sql(@"
                UPDATE dbo.[User]
                SET [Status] = CASE WHEN StatusID = 2 THEN 'Preferred'
                    WHEN StatusID = 3 THEN 'Gold'
                    ELSE 'Regular' END");

            Delete.ForeignKey("FK_User_StatusID").OnTable("User").InSchema("dbo");
            Delete.Column("StatusID").FromTable("User").InSchema("dbo");
            Delete.Table("UserStatus").InSchema("dbo");
        }
    }
}
