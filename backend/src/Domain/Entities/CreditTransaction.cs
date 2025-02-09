namespace CreditService.Domain.Entities;

public class CreditTransaction
{
    public Guid Id { get; set; }

    public Guid CreditCardId { get; set; }

    public decimal Amount { get; set; }

    public TransactionType Type { get; set; }

    public TransactionStatus Status { get; set; } = TransactionStatus.Pending;

    public string? Description { get; set; }

    public DateTimeOffset CreatedAt { get; set; }

    public DateTimeOffset LastModifiedAt { get; set; }
}

public enum TransactionType
{
    Credit,
    Debit,
    Payment,
    Refund
}

public enum TransactionStatus
{
    Pending,
    Completed,
    Cancelled,
    Refunded
}