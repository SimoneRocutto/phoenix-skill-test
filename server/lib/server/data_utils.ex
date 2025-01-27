defmodule Server.DataUtils do
  import Ecto.Query, warn: false
  alias Server.Repo

  @default_limit 10
  @default_offset 0

  @doc """
  Formats query parameters that are used with index functions (
  e.g. when calling an api to get a list of users) so they can be
  used with `DataUtils.list_query/5`.
  """
  def format_index_query_params(schema, params) do
    with {:ok, formatted_filter} <-
           Map.get(params, "filter")
           |> Utils.coalesce(%{})
           |> format_filter_query_param(schema),
         {:ok, formatted_sort} <-
           Map.get(params, "sort")
           |> Utils.coalesce("")
           |> format_sort_query_param(schema) do
      {
        :ok,
        %{
          limit: get_in(params, ["page", "limit"]),
          offset: get_in(params, ["page", "offset"]),
          sort: formatted_sort,
          filter: formatted_filter
        }
      }
    end
  end

  def format_index_response(%{data: data, pagination: pagination}, data_formatter) do
    %{
      data: for(item <- data, do: data_formatter.(item)),
      pagination: pagination
    }
  end

  @spec list_query(
          any(),
          %{
            optional(:limit) => integer(),
            optional(:offset) => integer(),
            optional(:sort) => any(),
            optional(:filter) => any()
          }
        ) ::
          %{
            data: [...],
            pagination: %{
              total_count: integer(),
              limit: integer(),
              offset: integer()
            }
          }
  def list_query(schema, formatted_params) do
    default = %{
      limit: @default_limit,
      offset: @default_offset,
      sort: [],
      filter: []
    }

    %{limit: limit, offset: offset, sort: sort, filter: filter} =
      Map.merge(default, formatted_params)

    query =
      from(
        m in schema,
        where: ^where_clause_from_keyword(filter),
        limit: ^limit,
        offset: ^offset,
        order_by: ^sort
      )

    res = Repo.all(query)

    total_count = from(m in schema) |> Repo.aggregate(:count)

    %{
      data: res,
      pagination: %{
        total_count: total_count,
        limit: limit,
        offset: offset
      }
    }
  end

  defp where_clause_from_keyword(filter) do
    filter
    |> Enum.map(fn {field, value} ->
      match_string = "%#{value}%"
      dynamic([m], like(field(m, ^field), ^match_string))
    end)
    |> Enum.reduce(true, fn query, acc -> dynamic([m], ^acc and ^query) end)
  end

  @doc """
  Formats a filter map to a keyword list, eventually detecting non-existing
  fields.
  Second parameter should be the Ecto Schema used as a data model.

  ## Examples
    iex> ClientController.format_filter_query_param(%{"first_name" => "a", "last_name" => "b"}, Server.Clients.Client)
    {:ok, [first_name: "a", last_name: "b"]}
  """
  @spec format_filter_query_param(map(), any()) ::
          {:ok, keyword()} | {:error, :non_existing_field, String.t()}
  def format_filter_query_param(filter_params, schema) do
    filter_params
    |> Enum.reduce_while(
      [],
      fn {field, value}, acc ->
        case field_to_atom(field, schema) do
          {:error, error_type, error_info} ->
            {:halt, {:error, error_type, error_info}}

          {:ok, atom} ->
            {:cont, acc ++ [{atom, value}]}
        end
      end
    )
    |> case do
      {:error, error_type, error_info} -> {:error, error_type, error_info}
      filter_data -> {:ok, filter_data}
    end
  end

  @doc """
  Formats a sort string to a keyword list ready to be used in Ecto queries
  `order_by` clauses.
  Second parameter should be the Ecto Schema used as a data model.

  ## Examples
    iex> ServerWeb.ClientController.format_sort_query_param("first_name,-last_name", Server.Clients.Client)
    {:ok, [asc: :first_name, desc: :last_name]}
  """
  @spec format_sort_query_param(String.t(), any()) ::
          {:ok, Keyword.t()} | {:error, :non_existing_field, String.t()}
  def format_sort_query_param(sort_param, schema) do
    sort_param
    |> String.split(",", trim: true)
    |> Enum.reduce_while(
      [],
      fn el, acc ->
        case format_sort_item(el, schema) do
          {:error, error_type, error_info} ->
            {:halt, {:error, error_type, error_info}}

          {:ok, sort_data} ->
            {:cont, acc ++ sort_data}
        end
      end
    )
    |> case do
      {:error, error_type, error_info} -> {:error, error_type, error_info}
      sort_data -> {:ok, sort_data}
    end
  end

  @spec format_sort_item(any(), any()) ::
          {:ok, any()} | {:error, :non_existing_field, String.t()}
  defp format_sort_item(sort_item, schema) do
    clean_item = String.trim_leading(sort_item, "-")

    case field_to_atom(clean_item, schema) do
      {:error, error_type, error_message} ->
        {:error, error_type, error_message}

      {:ok, atom} ->
        if String.starts_with?(sort_item, "-") do
          [desc: atom]
        else
          [asc: atom]
        end
        |> then(&{:ok, &1})
    end
  end

  defp field_to_atom(field, schema) do
    if field_exists?(field, schema) do
      {:ok, String.to_atom(field)}
    else
      {:error, :non_existing_field, field}
    end
  end

  # """
  # Checks if a given string is a valid field of an Ecto schema.
  # Second argument should be the Ecto Schema used as a data model.
  # """
  @spec field_exists?(String.t(), any()) :: boolean()
  defp field_exists?(field, schema) do
    Enum.find(
      schema.__schema__(:fields),
      nil,
      &(Atom.to_string(&1) === field)
    )
  end
end
