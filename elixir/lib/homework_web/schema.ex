defmodule HomeworkWeb.Schema do
  @moduledoc """
  Defines the graphql schema for this project.
  """
  use Absinthe.Schema

  alias HomeworkWeb.Resolvers.MerchantsResolver
  alias HomeworkWeb.Resolvers.TransactionsResolver
  alias HomeworkWeb.Resolvers.UsersResolver
  import_types(HomeworkWeb.Schemas.Types)

  input_object :pagination do
    field :skip, non_null(:integer)
    field :limit, non_null(:integer)
  end

  # If I got the total_rows working, I'd have added it here, along
  # with the skip/limit parameters as well.  If we did tracing/telemetry/requestID
  # through gql, this would also be the spot for that, so the moment
  # I start adding anything `meta`, I start with a child object to keep things
  # clean and universal
  object :meta do
    field :total_rows, non_null(:integer)
    field :skip, non_null(:integer)
    field :limit, non_null(:integer)
  end


  query do
    @desc "Get all Transactions"
    field(:transactions, list_of(:transaction)) do
      arg(:pagination, :pagination)

      resolve(&TransactionsResolver.transactions/3)
    end

    @desc "Get all Users"
    field(:users, list_of(:user)) do
      resolve(&UsersResolver.users/3)
    end

    @desc "Get all Merchants"
    field(:merchants, list_of(:merchant)) do
      resolve(&MerchantsResolver.merchants/3)
    end
  end

  mutation do
    import_fields(:transaction_mutations)
    import_fields(:user_mutations)
    import_fields(:merchant_mutations)
  end
end
