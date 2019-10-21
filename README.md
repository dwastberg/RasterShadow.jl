# RasterShadow

[![Build Status](https://travis-ci.com/dwastberg/RasterShadow.jl.svg?branch=master)](https://travis-ci.com/dwastberg/RasterShadow.jl)

Function to calculate the shadows that fall on a Digital Elevation Model (DEM) or Digital Surface Model (DSM). Shadowing algorithm is taken from UMEP (https://umep-docs.readthedocs.io)

## Quick Start
For reading and writing GIS raster data I recommend ArchGDAL.jl

```julia
using RasterShadow
using ArchGDAL

azimuth = 120
altitude = 30

ArchGDAL.registerdrivers() do
    ArchGDAL.read("/path/to/dem.tif") do dataset
        band = ArchGDAL.getband(dataset, 1)
        scale = ArchGDAL.getscale(band)
        dem = ArchGDAL.read(band)
        sh = shadowing(dem,azimuth,altitude,scale)
        # do stuff with the shadow raster
    end
end
```