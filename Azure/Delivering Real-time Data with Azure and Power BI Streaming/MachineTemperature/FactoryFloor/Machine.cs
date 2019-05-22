using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace FactoryFloor
{
    public enum Metric
    {
        Celsius,Fahrenheit
    }

    public enum TemperatureDirection
    {
        Increasing, Decreasing, Stable, Bouncing
    }

    public class Machine
    {
        [JsonProperty]
        private float temperature;

        [JsonConverter(typeof(StringEnumConverter))]
        public Metric currentMetric;

        [JsonConverter(typeof(StringEnumConverter))]
        public TemperatureDirection currentDirection;

        [JsonProperty(PropertyName = "id")]
        public string temperatureReadId;

        public string machineName;
        private int minimumTemperature = 0;
        private int maximumTemperature = 80;

        private Random rnd;

        [JsonProperty]
        private DateTime temperatureReadTimestamp;
        public Machine(float startingTemperature, string machineName)
        {
            this.currentMetric = Metric.Celsius;
            this.currentDirection = TemperatureDirection.Stable;
            this.temperature = startingTemperature;
            rnd = new Random();
            this.machineName = machineName;
        }

        public Machine(string machineName)
        {
            this.currentMetric = Metric.Celsius;
            this.currentDirection = TemperatureDirection.Stable;
            rnd = new Random();
            this.temperature = rnd.Next(minimumTemperature,maximumTemperature);
            this.machineName = machineName;
        }

        public string ReadAsJSON()
        {
            this.ReadTemperature();
            return JsonConvert.SerializeObject(this);
        }

        public override string ToString()
        {
            return this.ReadAsJSON();
        }

        public float ReadTemperature()
        {
            float delta = (float)rnd.NextDouble();
            float sign = 1;

            if((this.temperature <= minimumTemperature) && 
                ((this.currentDirection==TemperatureDirection.Decreasing) || (this.currentDirection == TemperatureDirection.Bouncing))
                ||
                    ((this.temperature >= maximumTemperature) &&
                ((this.currentDirection == TemperatureDirection.Increasing) || (this.currentDirection == TemperatureDirection.Bouncing))))
                this.currentDirection = TemperatureDirection.Stable;

            switch (this.currentDirection)
            {
                case TemperatureDirection.Bouncing:
                    sign = (rnd.Next(2) == 0) ? 1 : -1;                    
                    break;
                case TemperatureDirection.Increasing:
                    delta = (float)rnd.NextDouble();
                    sign = 1;
                    break;
                case TemperatureDirection.Decreasing:
                    sign = -1;
                    break;
                case TemperatureDirection.Stable:
                    delta = 0;
                    break;
            }
            this.temperature = temperature + (delta*sign);
            this.temperatureReadTimestamp = DateTime.Now;
            this.temperatureReadId = this.machineName + "_" + this.temperatureReadTimestamp.ToString("yyyyMMddHH:mm:ss.ffff");
            if (currentMetric == Metric.Celsius)
                return this.temperature;
            else
                return this.temperature;
        }
    }
}
