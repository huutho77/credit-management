using CreditService.Domain.Entities;

using MediatR;

namespace CreditService.Application.CreditCards.Get;

public record GetByIdQuery(Guid Id) : IRequest<CreditCard>;