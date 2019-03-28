using FluentMigrator;

namespace MySolution.Database.Migrations
{
    [Migration(5)]
    public class ChangeUserStatuses : Migration
    {
        public override void Up()
        {
            Execute.Sql(@"
                UPDATE dbo.UserStatus SET Name = 'Bronze' WHERE UserStatusID = 1
                UPDATE dbo.UserStatus SET Name = 'Silver' WHERE UserStatusID = 2");
        }

        public override void Down()
        {
            Execute.Sql(@"
                UPDATE dbo.UserStatus SET Name = 'Regular' WHERE UserStatusID = 1
                UPDATE dbo.UserStatus SET Name = 'Preferred' WHERE UserStatusID = 2");
        }
    }
}
