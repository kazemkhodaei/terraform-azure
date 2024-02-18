using Azure.Core;
using Azure.Identity;
using Forcast.Weather.Config;
using Forcast.Weather.Infra.DB;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.SqlServer;
using Microsoft.Extensions.Configuration;
using System.Configuration;
using System.Diagnostics.Metrics;
using System.Threading;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.Configure<AzureAd>(builder.Configuration.GetSection("AzureAd"));
var connectionString = await GetConnectionStringAsync(builder)!;


builder.Services.AddDbContext<WeatherDbContext>(option =>
{
    option.UseSqlServer(connectionString);
});
builder.Services.AddApplicationInsightsTelemetry();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

using (var serviceScope = app.Services.GetRequiredService<IServiceScopeFactory>().CreateScope())
{
    var context = serviceScope.ServiceProvider.GetRequiredService<WeatherDbContext>();
    context!.Database.Migrate();
}

app.UseAuthorization();

app.MapControllers();

app.Run();


async Task<SqlConnection> GetConnectionStringAsync(WebApplicationBuilder builder)
{
    var connectionString = builder.Configuration.GetConnectionString("SqlDatabase")!;
    var sqlconnection = new SqlConnection(connectionString);

    var clientId = builder.Configuration.GetSection("AzureAd:UserAssigendClientId").Value;
    var credential = new DefaultAzureCredential(new DefaultAzureCredentialOptions { ManagedIdentityClientId = clientId });
    var tokenRequestContext = new TokenRequestContext(["https://database.windows.net/.default"]);
    var token = await credential.GetTokenAsync(tokenRequestContext);
    sqlconnection.AccessToken = token.Token;
    return sqlconnection;

}