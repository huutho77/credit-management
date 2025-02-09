namespace CreditService.Domain.Entities;

public class Account
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public Guid? CreditCardId { get; set; }

    public required string AccountType { get; set; }

    public required string Name { get; set; }

    /// <summary>
    /// The current balance of the account
    /// </summary>
    public decimal AvailableBalance { get; set; }

    public DateTimeOffset CreatedAt { get; set; }

    public DateTimeOffset LastModifieddAt { get; set; }

    public void UpdateBalance(decimal amount)
    {
        AvailableBalance += amount;
    }
}