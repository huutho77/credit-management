using CreditService.Domain.Entities;

using Microsoft.EntityFrameworkCore;

namespace CreditService.Infrastructure.Persistence.DbContext;

public class CreditServiceDbContext(DbContextOptions<CreditServiceDbContext> options) : Microsoft.EntityFrameworkCore.DbContext(options)
{
    DbSet<CreditCard> CreditCards { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
    }
}