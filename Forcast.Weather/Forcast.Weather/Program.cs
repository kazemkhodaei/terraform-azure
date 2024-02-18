using Azure.Identity;
using Forcast.Weather.Infra.DB;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.SqlServer;
using System.Diagnostics.Metrics;
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
var connectionString = builder.Configuration.GetConnectionString("SqlDatabase")!;


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


string GetConnectionString(WebApplicationBuilder builder)
{
    var connectionString = builder.Configuration.GetConnectionString("SqlDatabase")!;
    //if (builder.Environment.IsDevelopment())
    //    return builder.Configuration.GetConnectionString("SqlDatabase")!;
    builder.Services.AddTransient(a =>
    {
        var sqlconnection = new SqlConnection(connectionString);
        var credential = new DefaultAzureCredential();
        var token = credential.GetToken(new Azure.Core.TokenRequestContext(new[] { "https://databases.window.net/.default" }));
        sqlconnection.AccessToken = token.Token;
        Console.WriteLine(sqlconnection.AccessToken);
        return sqlconnection;
    });


    return connectionString;
}