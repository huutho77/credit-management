namespace CreditService.Domain.Entities;

public class CreditCard
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public Guid AccountId { get; set; }

    public required string CardHolderName { get; set; }

    public required string CardNumber { get; set; }

    public decimal CreditLimit { get; set; }

    public DateTimeOffset ExpirationDate { get; set; }

    public bool IsActive { get; set; }

    public DateTimeOffset CreatedAt { get; set; }

    public DateTimeOffset LastModifiedAt { get; set; }
}