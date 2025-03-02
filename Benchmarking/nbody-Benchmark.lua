-- The Computer Language Benchmarks Game
-- https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
-- contributed by Mike Pall
-- modified by Geoff Leyland
-- modified by Mario Pernici
-- modified by altoidlol

-- You can adjust these variables if you'd like
local iterations = 1000

local sqrt = math.sqrt

local PI = math.pi
local SOLAR_MASS = 4 * PI * PI
local DAYS_PER_YEAR = 365.24

-- Improved for readability
local sun = { }
sun.x = 0.0
sun.y = 0.0
sun.z = 0.0
sun.vx = 0.0
sun.vy = 0.0
sun.vz = 0.0
sun.mass = SOLAR_MASS

local jupiter = { }
jupiter.x = 4.84143144246472090e+00
jupiter.y = -1.16032004402742839e+00
jupiter.z = -1.03622044471123109e-01
jupiter.vx = 1.66007664274403694e-03 * DAYS_PER_YEAR
jupiter.vy = 7.69901118419740425e-03 * DAYS_PER_YEAR
jupiter.vz = -6.90460016972063023e-05 * DAYS_PER_YEAR
jupiter.mass = 9.54791938424326609e-04 * SOLAR_MASS

local saturn = { }
saturn.x = 8.34336671824457987e+00
saturn.y = 4.12479856412430479e+00
saturn.z = -4.03523417114321381e-01
saturn.vx = -2.76742510726862411e-03 * DAYS_PER_YEAR
saturn.vy = 4.99852801234917238e-03 * DAYS_PER_YEAR
saturn.vz = 2.30417297573763929e-05 * DAYS_PER_YEAR
saturn.mass = 2.85885980666130812e-04 * SOLAR_MASS

local uranus = { }
uranus.x = 1.28943695621391310e+01
uranus.y = -1.51111514016986312e+01
uranus.z = -2.23307578892655734e-01
uranus.vx = 2.96460137564761618e-03 * DAYS_PER_YEAR
uranus.vy = 2.37847173959480950e-03 * DAYS_PER_YEAR
uranus.vz = -2.96589568540237556e-05 * DAYS_PER_YEAR
uranus.mass = 4.36624404335156298e-05 * SOLAR_MASS

local neptune = { }
neptune.x = 1.53796971148509165e+01
neptune.y = -2.59193146099879641e+01
neptune.z = 1.79258772950371181e-01
neptune.vx = 2.68067772490389322e-03 * DAYS_PER_YEAR
neptune.vy = 1.62824170038242295e-03 * DAYS_PER_YEAR
neptune.vz = -9.51592254519715870e-05 * DAYS_PER_YEAR
neptune.mass = 5.15138902046611451e-05 * SOLAR_MASS

local bodies = {sun, jupiter, saturn, uranus, neptune}

--[[ Functions ]]

local function advance(bodies, num_bodies, dt)
    for i = 1, num_bodies do
        local body_i = bodies[i]
        local x_i, y_i, z_i = body_i.x, body_i.y, body_i.z
        local vx_i, vy_i, vz_i = body_i.vx, body_i.vy, body_i.vz
        local mass_i = body_i.mass

        for j = i + 1, num_bodies do
            local body_j = bodies[j]
            local dx, dy, dz = x_i - body_j.x, y_i - body_j.y, z_i - body_j.z
            local dist_squared = dx * dx + dy * dy + dz * dz
            local dist = sqrt(dist_squared)
            local mag = dt / (dist * dist_squared)

            local mass_j_mag = body_j.mass * mag
            vx_i = vx_i - (dx * mass_j_mag)
            vy_i = vy_i - (dy * mass_j_mag)
            vz_i = vz_i - (dz * mass_j_mag)

            local mass_i_mag = mass_i * mag
            body_j.vx = body_j.vx + (dx * mass_i_mag)
            body_j.vy = body_j.vy + (dy * mass_i_mag)
            body_j.vz = body_j.vz + (dz * mass_i_mag)
        end

        body_i.vx = vx_i
        body_i.vy = vy_i
        body_i.vz = vz_i
        body_i.x = x_i + dt * vx_i
        body_i.y = y_i + dt * vy_i
        body_i.z = z_i + dt * vz_i
    end
end

local function energy(bodies, num_bodies)
    local total_energy = 0

    for i = 1, num_bodies do
        local body_i = bodies[i]
        local vx_i, vy_i, vz_i = body_i.vx, body_i.vy, body_i.vz
        local mass_i = body_i.mass

        total_energy = total_energy + (0.5 * mass_i * (vx_i * vx_i + vy_i * vy_i + vz_i * vz_i))

        for j = i + 1, num_bodies do
            local body_j = bodies[j]
            local dx, dy, dz = body_i.x - body_j.x, body_i.y - body_j.y, body_i.z - body_j.z
            local distance = sqrt(dx * dx + dy * dy + dz * dz)
            total_energy = total_energy - ((mass_i * body_j.mass) / distance)
        end
    end

    return total_energy
end

local function offset_momentum(bodies, nbody)
    local total_momentum_x, total_momentum_y, total_momentum_z = 0, 0, 0

    for i = 1, nbody do
        local body = bodies[i]
        local mass = body.mass
        total_momentum_x = total_momentum_x + (body.vx * mass)
        total_momentum_y = total_momentum_y + (body.vy * mass)
        total_momentum_z = total_momentum_z + (body.vz * mass)
    end

    local sun = bodies[1]
    local inv_solar_mass = 1 / SOLAR_MASS
    sun.vx = -total_momentum_x * inv_solar_mass
    sun.vy = -total_momentum_y * inv_solar_mass
    sun.vz = -total_momentum_z * inv_solar_mass
end

local function benchmark_nbody()
  local num_bodies = #bodies

  local start_time = os.clock()
  offset_momentum(bodies, num_bodies)
  print("--------------------------------------------")
  print("Energy results for the start of simulation:")
  print(string.format("%0.9f", energy(bodies, num_bodies)))
  print("--------------------------------------------")
  
  for i = 1, iterations do
      advance(bodies, num_bodies, 0.01)
  end

  local end_time = os.clock()
  print("Energy results for the end of simulation:")
  print(string.format("%0.9f", energy(bodies, num_bodies)))
  print("--------------------------------------------")

  return (end_time - start_time)
end

--[[ Testing ]]

print("Starting nbody simulation...")
local difference = benchmark_nbody()
print(string.format("Execution time: %.9f seconds", difference))
