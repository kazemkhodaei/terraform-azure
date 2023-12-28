using FluentAssertions;
using Forcast.Weather.Controllers;
using Microsoft.Extensions.Logging;
using Moq;

namespace Forcast.Weather.Tests.Controllers
{
    public class WeatherForecastControllerTests
    {
        private readonly WeatherForecastController _controller;
        private readonly Mock<ILogger<WeatherForecastController>> _mockLogger;

        public WeatherForecastControllerTests()
        {
            _mockLogger = new Mock<ILogger<WeatherForecastController>>();
            _controller = new WeatherForecastController(_mockLogger.Object);
        }

        [Fact]
        public void Get_ReturnsEnumerableOfWeatherForecast()
        {
            var result = _controller.Get();

            result.Should().BeAssignableTo<IEnumerable<WeatherForecast>>();
        }

        [Fact]
        public void Get_ReturnsFiveItems()
        {
            var result = _controller.Get();

            result.Should().HaveCount(5);
        }

        [Fact]
        public void Get_ReturnsCorrectDateSequences()
        {
            var result = _controller.Get().ToList();

            for (int i = 0; i < result.Count; i++)
            {
                var expectedDate = DateOnly.FromDateTime(DateTime.Now.AddDays(i + 1));
                result[i].Date.Should().Be(expectedDate);
            }
        }

        [Fact]
        public void Get_ReturnsTemperatureWithinRange()
        {
            var result = _controller.Get();

            result.Select(f => f.TemperatureC).Should().OnlyContain(temp => temp >= -20 && temp <= 55);
        }

        [Fact]
        public void Get_ReturnsValidSummaries()
        {
            var summaries = new[]
            {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

            var result = _controller.Get();

            result.Select(f => f.Summary).Should().OnlyContain(summary => summaries.Contains(summary));
        }
    }
}