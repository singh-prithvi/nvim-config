return {
    {
        "sphamba/smear-cursor.nvim",
        opts = function()
            -- 🔁 CHANGE THIS NUMBER (1–5)
            local style = 5

            local styles = {
                -- 1️⃣ Smooth (default)
                [1] = {
                    stiffness = 0.6,
                    trailing_stiffness = 0.45,
                    damping = 0.85,
                },

                -- 2️⃣ Fast / Snappy
                [2] = {
                    stiffness = 0.9,
                    trailing_stiffness = 0.7,
                    damping = 0.95,
                },

                -- 3️⃣ Elastic / Bouncy
                [3] = {
                    stiffness = 0.5,
                    trailing_stiffness = 0.3,
                    damping = 0.65,
                },

                -- 4️⃣ Minimal
                [4] = {
                    trailing_stiffness = 0.5,
                    matrix_pixel_threshold = 0.5,
                },

                -- 5️⃣ Fire 🔥
                [5] = {
                    -- 🔥 Motion physics (slightly soft for flame feel)
                    stiffness = 0.55,
                    trailing_stiffness = 0.25,
                    damping = 0.7,

                    -- ⚡ Smoothness tuned for 180Hz
                    time_interval = 5, -- ~200 FPS cap (perfect for 180Hz)

                    -- 🎨 Fire colors
                    cursor_color = "#ff5a00",

                    -- 💥 Particles (dense but stable)
                    particles_enabled = true,
                    particles_per_second = 280, -- slightly above refresh rate
                    particle_spread = 1, -- wide flame spread
                    particle_lifetime = 140, -- longer = flame trail

                    -- 🔥 Flame shaping
                    trailing_exponent = 1.2,
                    gamma = 1.3,

                    -- ✨ Extra feel
                    distance_stop_animating = 0.3,
                },

                -- 6️⃣ FLASH ⚡ (super speed / teleport feel)
                -- 6️⃣ FLASH ⚡ (180Hz optimized + more particles)
                [6] = {
                    stiffness = 1,
                    trailing_stiffness = 0.95,
                    damping = 1,

                    -- 🔥 Smoothness (180Hz tuning)
                    time_interval = 5, -- ~200 FPS cap (good for 180Hz)

                    -- ⚡ Motion feel
                    distance_stop_animating = 0.5,
                    trailing_exponent = 2.5,

                    -- 🎨 Color (electric blue flash vibe)
                    cursor_color = "#00f7ff",

                    -- 💥 PARTICLES (enhanced but controlled)
                    particles_enabled = true,
                    particles_per_second = 180, -- matches your refresh rate 🔥
                    particle_spread = 0.4,
                    particle_lifetime = 80, -- short = fast streak effect

                    -- optional: tighter look
                    gamma = 1,
                },
            }

            -- base config
            local base = {
                cursor_color = "#89b4fa",
                smear_between_buffers = true,
                smear_between_neighbor_lines = true,
                smear_insert_mode = true,
            }

            -- merge base + selected style
            return vim.tbl_deep_extend("force", base, styles[style])
        end,
    },
}
