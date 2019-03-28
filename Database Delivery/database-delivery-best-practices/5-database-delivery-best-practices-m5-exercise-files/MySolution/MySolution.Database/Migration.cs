using System.IO;
using System.Linq;


namespace MySolution.Database
{
    internal class Migration
    {
        public string Name { get; }
        public string FilePath { get; }
        public int Version { get; }


        public Migration(FileInfo fileInfo)
        {
            string version = fileInfo.Name.Split('_').First();
            Version = int.Parse(version);
            Name = fileInfo.Name;
            FilePath = fileInfo.FullName;
        }


        public string GetContent()
        {
            return File.ReadAllText(FilePath);
        }
    }
}
