using CreditService.Domain.Entities;

namespace CreditService.Application.Interfaces;

public interface ICreditRepository
{
    Task<CreditCard> GetCreditCardByIdAsync(Guid id);

    Task<CreditCard> GetCreditCardByUserIdAsync(Guid userId);

    Task<CreditCard> CreateCreditCardAsync(CreditCard creditCard);

    Task UpdateCreditCardAsync(CreditCard creditCard);

    Task DeleteCreditCardAsync(Guid id);

    Task<IEnumerable<CreditCard>> GetAllCreditCardsAsync();
}