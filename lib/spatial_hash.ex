defmodule SpatialHash do
  @moduledoc """
  Documentation for SpatialHash.
  """
  @type point :: list(number)
  @type point_range :: list(%Range{})
  @type grid_dim :: {number, number, number}
  @type grid :: list(grid_dim)
  @type geometry :: {number, number}
                  | %{type: String.t, coordinates: list}
                  | %Geo.Point{}
                  | %Geo.MultiPoint{}
                  | %Geo.LineString{}
                  | %Geo.MultiLineString{}
                  | %Geo.Polygon{}
                  | %Geo.MultiPolygon{}

  @eps 0.000001

  @doc """
  Returns an array containing the hash elements for the given point for each dimension.

  ## Examples

      iex> SpatialHash.hash([-0.2, -1.3], [{-180, 180, 0.05}, {-90, 90, 0.2}])
      [3596, 443]
      iex> SpatialHash.hash([0.2, -80.2], [{-180, 180, 0.05}, {-90, 90, 0.1}])
      [3604, 98]
      iex> SpatialHash.hash([0.2, -80.2])
      [180200, 9800]

  """
  @spec hash(point, grid) :: point
  def hash(point), do: hash(point, world_grid())
  def hash([], []), do: []
  def hash([a | rest_a], [dim | rest_dim]) do
    [do_hash(a, dim) | hash(rest_a, rest_dim)]
  end

  @spec do_hash(number, grid_dim) :: number
  defp do_hash(a, {min, _, step}) do
    hash = (a - min) / step
    err = Float.ceil(hash) - hash

    if err < @eps && err > 0 do
      round(Float.floor(hash)) + 1
    else
      round(Float.floor(hash))
    end
  end

  @doc """
  Returns array of hash ranges for a given axis-aligned envelope

  ## Examples

      iex> SpatialHash.hash_range(%Envelope{
      ...>   min_x: -90.082756,
      ...>   min_y: 29.949766,
      ...>   max_x: -90.079484,
      ...>   max_y: 29.952280
      ...> }, [{-180, 180, 0.01}, {-90, 90, 0.01}])
      [8991..8992, 11994..11995]

      iex> SpatialHash.hash_range(
      ...>  %{type: "LineString", coordinates: [
      ...>    { -90.082746, 29.950955},
      ...>    {-90.081453, 29.952280},
      ...>    {-90.079489, 29.949770}
      ...>  ]})
      [89917..89920, 119949..119952]

      iex> SpatialHash.hash_range(
      ...>  %{type: "Point",
      ...>    coordinates: { -90.082746, 29.950955}})
      [89917..89917, 119950..119950]
  """
  @spec hash_range(%Envelope{} | geometry, grid) :: point_range
  def hash_range(shape), do: hash_range(shape, world_grid())
  def hash_range(%Envelope{} = env, [dim_x, dim_y]) do
    min_x_hash = do_hash(env.min_x, dim_x)
    max_x_hash = do_hash(env.max_x, dim_x)
    min_y_hash = do_hash(env.min_y, dim_y)
    max_y_hash = do_hash(env.max_y, dim_y)

    [min_x_hash .. max_x_hash, min_y_hash .. max_y_hash]
  end
  def hash_range(%{coordinates: coords}, dims), do: hash_range(Envelope.from_geo(coords), dims)

  @doc """
  Convenience function for creating a grid for use with longitude/latitude grids.
  You can specify a grid spacing, or it will default to `0.001`.

  ## Examples

      iex> SpatialHash.world_grid()
      [{-180, 180, 0.001}, {-90, 90, 0.001}]

      iex> SpatialHash.world_grid(0.03)
      [{-180, 180, 0.03}, {-90, 90, 0.03}]
  """
  @spec world_grid(number) :: grid
  def world_grid(step \\ 0.001) do
    [{-180, 180, step}, {-90, 90, step}]
  end
end
