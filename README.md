# SpatialHash

[![Build Status](https://travis-ci.org/pkinney/spatial_hash_ex.svg?branch=master)](https://travis-ci.org/pkinney/spatial_hash_ex)
[![Hex.pm](https://img.shields.io/hexpm/v/spatial_hash.svg)](https://hex.pm/packages/spatial_hash)

A library for calculating spatial hashes for points and geometries.
This is most useful for building spatial databases with very fast indexing.

## Installation

```elixir
defp deps do
  [{:spatial_hash, "~> 0.1.0"}]
end
```

## Usage

**[Full Documentation](https://hexdocs.pm/spatial_hash/SpatialHash.html)**

The `Envelope` module provides a `hash` function that takes a single point on any dimension
as an array of coordinates and an array of gridding properties for each dimension.  Grid
properties are specified as a tuple of coordinate min and max as well as a step value for
the grid spacing.  Convenience function of `SpatialHash.world_grid()` is provided that
returns a grid of the entire world in degress with step value roughly equivalent to 10 meters.

A `hash_range` function is also provided that takes an Envelope or Geometry and returns
the range covered in each dimension.

```elixir
SpatialHash.hash_range(
  %Envelope{
    min_x: -90.082756,
    min_y: 29.949766,
    max_x: -90.079484,
    max_y: 29.952280
  }, [{-180, 180, 0.01}, {-90, 90, 0.01}]) // -> [8991..8992, 11994..11995]

SpatialHash.hash_range(
  %{type: "LineString", coordinates: [
    { -90.082746, 29.950955},
    {-90.081453, 29.952280},
    {-90.079489, 29.949770}
  ]}, SpatialHash.world_grid) // -> [89917..89920, 119949..119952]
```