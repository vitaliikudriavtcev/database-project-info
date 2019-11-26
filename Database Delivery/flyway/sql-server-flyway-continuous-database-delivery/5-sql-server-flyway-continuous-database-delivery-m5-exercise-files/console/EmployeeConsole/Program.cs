namespace EmployeeConsole
{
	using System;
	using System.Data.Entity;

	public static class Program
	{
		public static void Main()
		{
			Flyway.CheckDatabase();
			PrintEmployees();
		}

		private static void PrintEmployees()
		{
			var employees = new PayrollContext().Employees;

			foreach (var employee in employees)
			{
				Console.WriteLine(employee.Id + " - " + employee.Name + " pay: " + employee.Salary);
			}

			Console.ReadLine();
		}
	}

	public class PayrollContext : DbContext
	{
		public PayrollContext() : base("payroll")
		{
		}

		public DbSet<Employee> Employees { get; set; }
	}

	public class Employee
	{
		public int Id { get; set; }

		public string Name { get; set; }

		public string Salary { get; set; }
	}
}