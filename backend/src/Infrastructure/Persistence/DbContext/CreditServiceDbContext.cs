using CreditService.Domain.Entities;

using Microsoft.EntityFrameworkCore;

namespace CreditService.Infrastructure.Persistence.DbContext;

public class CreditServiceDbContext(DbContextOptions<CreditServiceDbContext> options) : Microsoft.EntityFrameworkCore.DbContext(options)
{
    public DbSet<CreditCard> CreditCards { get; set; }
    public DbSet<CreditTransaction> CreditTransactions { get; set; }
    public DbSet<Account> Accounts { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
    }
}