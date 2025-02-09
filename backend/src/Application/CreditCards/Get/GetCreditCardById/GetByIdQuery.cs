using CreditService.Domain.Entities;

using MediatR;

namespace CreditService.Application.CreditCards.Get.GetCreditCardById;

public record GetByIdQuery(Guid Id) : IRequest<CreditCard>;