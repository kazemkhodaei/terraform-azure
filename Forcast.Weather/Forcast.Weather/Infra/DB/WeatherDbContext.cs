using Forcast.Weather.Domains;
using Microsoft.EntityFrameworkCore;

namespace Forcast.Weather.Infra.DB
{
    public class WeatherDbContext : DbContext
    {
        public DbSet<City> Cities { get; set; }


        public WeatherDbContext(DbContextOptions<WeatherDbContext> options)
    : base(options)
        { }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);
        }
    }
}
