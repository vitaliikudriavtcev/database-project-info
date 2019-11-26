namespace EmployeeConsole
{
	using System;
	using System.Diagnostics;
	using System.IO;

	public static class Flyway
	{
		public static void CheckDatabase()
		{
			var info = RunFlyway("info");

			var anyPendingMigrations = info.Contains("| Pending |\n");
			if (anyPendingMigrations)
			{
				Console.WriteLine(info);
				throw new ApplicationException("There are pending migrations, run flyway migrate to update your database.");
			}

			var validate = RunFlyway("validate");
			var anyModifiedMigrations = validate.Contains("ERROR: Validate failed.");
			if (anyModifiedMigrations)
			{
				Console.WriteLine(validate);
				throw new ApplicationException("There are modified migrations, you'll need to manually repair your database.");
			}
		}

		private static string RunFlyway(string arguments)
		{
			var repositoryRoot = Path.Combine(Environment.CurrentDirectory, "..\\..\\..\\..\\");

			var startInfo = new ProcessStartInfo
			{
				FileName = Path.Combine(repositoryRoot, "flyway.cmd"),
				Arguments = arguments,
				RedirectStandardOutput = true,
				RedirectStandardError = true,
				UseShellExecute = false,
				CreateNoWindow = true
			};

			using (var process = new Process())
			{
				process.StartInfo = startInfo;
				process.Start();
				var output = process.StandardOutput.ReadToEnd();
				process.WaitForExit();
				return output;
			}
		}
	}
}