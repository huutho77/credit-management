using CreditService.Application.Interfaces;
using CreditService.Domain.Entities;
using CreditService.Infrastructure.Persistence.DbContext;

using Microsoft.EntityFrameworkCore;

namespace CreditService.Infrastructure.Persistence.Repositories;

public class CreditRepository(CreditServiceDbContext dbContext) : ICreditRepository
{
    public async Task<CreditCard> GetCreditCardByIdAsync(Guid id)
    {
        CreditCard? card = await dbContext.CreditCards
            .FirstOrDefaultAsync(a => a.Id == id);

        return card ?? throw new ArgumentNullException(nameof(card));
    }

    public async Task<CreditCard> GetCreditCardByUserIdAsync(Guid userId)
    {
        CreditCard? card = await dbContext.CreditCards.AsNoTracking()
                                                    .FirstOrDefaultAsync(a => a.UserId == userId);

        return card ?? throw new ArgumentNullException(nameof(card));
    }

    public async Task<CreditCard> CreateCreditCardAsync(CreditCard creditCard)
    {
        creditCard.CreatedAt = DateTimeOffset.UtcNow;
        creditCard.LastModifiedAt = DateTimeOffset.UtcNow;

        dbContext.CreditCards.Add(creditCard);
        await dbContext.SaveChangesAsync();

        return creditCard;
    }

    public async Task UpdateCreditCardAsync(CreditCard creditCard)
    {
        creditCard.LastModifiedAt = DateTimeOffset.UtcNow;

        dbContext.CreditCards.Update(creditCard);
        await dbContext.SaveChangesAsync();
    }

    public async Task DeleteCreditCardAsync(Guid id)
    {
        var creditCard = await dbContext.CreditCards.FindAsync(id);

        if (creditCard is null)
        {
            throw new ArgumentNullException(nameof(creditCard));
        }

        dbContext.CreditCards.Remove(creditCard);
        await dbContext.SaveChangesAsync();
    }

    public async Task<IEnumerable<CreditCard>> GetAllCreditCardsAsync()
    {
        return await dbContext.CreditCards
            .AsNoTracking()
            .ToListAsync();
    }
}