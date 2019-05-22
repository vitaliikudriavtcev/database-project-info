using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using Microsoft.ServiceBus.Messaging;

namespace EventHubDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Event Hub Demo");
            Console.WriteLine("Enter amount of machines:");
            string serverLine = Console.ReadLine();
            int machineCount = Int32.Parse(serverLine);

            Dictionary<string, FactoryFloor.Machine> machineRegistry = new Dictionary<string, FactoryFloor.Machine>(machineCount);
            
            for(int i = 1; i<= machineCount;i++)
            {
                string machineName = "m" + i.ToString();
                FactoryFloor.Machine currentMachine = new FactoryFloor.Machine(machineName);
                machineRegistry[machineName] = currentMachine;
            }
                       
            EHClient hub = new EHClient();

            Task background = hub.ObjectCollectionInfiniteWriteWithDelay(machineRegistry.Values.AsEnumerable(),Properties.Settings.Default.EventDelayMs);

            bool stop = false;

            while(!stop)
            {
                Console.WriteLine("Enter command:");
                serverLine = Console.ReadLine();
                if (serverLine == "stop")
                {
                    hub.stop = true;
                    background.Wait();
                    stop = true;
                }
                if(serverLine=="status")
                {
                    foreach(FactoryFloor.Machine machine in machineRegistry.Values)
                    {
                        Console.WriteLine("Machine: " + machine.machineName + " Temperature Reading: " + machine.ReadTemperature().ToString() + " Direction: " + machine.currentDirection.ToString());
                    }
                }
                else if(serverLine=="help")
                {
                    Console.WriteLine("Commands:");
                    Console.WriteLine("help");
                    Console.WriteLine("status");
                    Console.WriteLine("stop");
                    Console.WriteLine("m* stable|bounce|increase|decrease");
                }
                else
                {
                    string[] split = serverLine.Split(new Char[] { ' ' });

                    try
                    {
                        FactoryFloor.Machine machineToCommand = machineRegistry[split[0]];
                        switch (split[1])
                        {
                            case "stable":
                                machineToCommand.currentDirection=FactoryFloor.TemperatureDirection.Stable;
                                break;
                            case "increase":
                                machineToCommand.currentDirection = FactoryFloor.TemperatureDirection.Increasing;
                                break;
                            case "decrease":
                                machineToCommand.currentDirection = FactoryFloor.TemperatureDirection.Decreasing;
                                break;
                            case "bounce":
                                machineToCommand.currentDirection = FactoryFloor.TemperatureDirection.Bouncing;
                                break;
                            default:
                                throw new Exception();
                        }
                    }
                    catch (Exception)
                    {
                        Console.WriteLine("Command does not parse");
                    }
                }
            }
        }
    }

    class EHClient
    {
        private string connectionString;
        private EventHubClient client;
        public bool stop = false;

        public EHClient()
        {
            connectionString = Properties.Settings.Default.EventHubConnectionString;
            this.client = EventHubClient.CreateFromConnectionString(connectionString);
        }

        public async Task ObjectCollectionInfiniteWriteWithDelay(IEnumerable<Object> collection, int delayMs)
        {
            while(!stop)
            {
                await WriteEventFromObjectCollection(collection);
                await Task.Delay(delayMs);
            }
        }

        public async Task WriteEventFromObjectCollection(IEnumerable<Object> collection)
        {
            var writeEventTasks = new List<Task>();

            foreach (var item in collection)
            {
                writeEventTasks.Add(WriteEventFromObject(item));
            }

            await Task.WhenAll(writeEventTasks);
        }

        public async Task WriteEventFromObject(Object obj)
        {
            await client.SendAsync(new EventData(Encoding.UTF8.GetBytes(obj.ToString())));
        }

        
    }
}
