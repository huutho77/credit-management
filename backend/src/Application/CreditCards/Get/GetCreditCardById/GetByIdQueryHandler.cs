using CreditService.Application.Interfaces;
using CreditService.Domain.Entities;

using MediatR;

namespace CreditService.Application.CreditCards.Get;

public class GetByIdQueryHandler(ICreditRepository creditRepository) : IRequestHandler<GetByIdQuery, CreditCard>
{
    public async Task<CreditCard> Handle(GetByIdQuery request, CancellationToken cancellationToken)
    {
        return await creditRepository.GetCreditCardByIdAsync(request.Id);
    }
}