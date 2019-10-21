module RasterShadow

export shadowing
function shadowing(dem::Array{<:AbstractFloat,2}, azimuth::Real, altitude::Real, pixel_scale::Real=1.0)
    if azimuth == 0
        azimuth = 0.1
    end
    pixel_scale = 1/pixel_scale
    azimuth = deg2rad(azimuth)
    altitude = deg2rad(altitude)

    sizex, sizey  = size(dem)

    dx::Int = 0
    dy::Int = 0
    dz::Float64 = 0
    dem_max = maximum(dem)

    sinazimuth = sin(azimuth)
    cosazimuth = cos(azimuth)
    tanazimuth = tan(azimuth)

    signsinazimuth = trunc(Int, sign(sinazimuth))
    signcosazimuth = trunc(Int, sign(cosazimuth))
    dssin = abs((1 / sinazimuth))
    dscos = abs((1 / cosazimuth))
    tanaltitudebyscale = tan(altitude) / pixel_scale

    demcopy = copy(dem)
    index::Int = 1
    while dz < dem_max && abs(dx) < sizex && abs(dy) < sizey
        if ( (π / 4 <= azimuth && azimuth < 3 * π / 4) || (5 * π / 4 <= azimuth && azimuth < 7 * π / 4) )
            dy = signsinazimuth * index
            dx = -1 * signcosazimuth * abs(round(Int, index / tanazimuth))
            ds = dssin
        else
            dy = signsinazimuth * abs(round(Int, index * tanazimuth))
            dx = -1 * signcosazimuth * index
            ds = dscos
        end
        dz = ds * index * tanaltitudebyscale

        absdx = abs(dx)
   	    absdy = abs(dy)

        xc1 = ((dx + absdx) ÷ 2) + 1
        yc1 = ((dy + absdy) ÷ 2) + 1

        xp1 = -((dx - absdx) ÷ 2) + 1
        xp2 = (sizex - (dx + absdx) ÷ 2)

        yp1 = -((dy - absdy) ÷ 2) + 1
        yp2 = (sizey - (dy + absdy) ÷ 2)

        xc_offset = xc1 - xp1
        yc_offset = yc1 - yp1
        for j in yp1:yp2
            for i in xp1:xp2
                demcopy[i,j] = max(demcopy[i,j], dem[i + xc_offset,j + yc_offset] - dz)
            end
        end
        index += 1

    end
    for i in eachindex(demcopy)
        if demcopy[i] == dem[i]
            demcopy[i] = 1
        else
            demcopy[i] = 0
        end
    end
    return demcopy
end

end # module
