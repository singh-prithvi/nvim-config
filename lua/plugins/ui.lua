return {
    {
        "sphamba/smear-cursor.nvim",
        event = "VeryLazy",
        opts = function()
            -- 🔁 CHANGE THIS NUMBER (1–6) to switch cursor style
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
                    stiffness = 0.55,
                    trailing_stiffness = 0.25,
                    damping = 0.7,

                    time_interval = 8, -- ~200 FPS cap (good for 180Hz)

                    cursor_color = "#ff5a00",

                    particles_enabled = true,
                    particles_per_second = 120,
                    particle_spread = 1,
                    particle_lifetime = 140,

                    trailing_exponent = 1.2,
                    gamma = 1.3,

                    distance_stop_animating = 0.3,
                },

                -- 6️⃣ Flash ⚡ (180Hz optimized, electric blue streak)
                [6] = {
                    stiffness = 1,
                    trailing_stiffness = 0.95,
                    damping = 1,

                    time_interval = 8, -- ~200 FPS cap (good for 180Hz)

                    distance_stop_animating = 0.5,
                    trailing_exponent = 2.5,

                    cursor_color = "#00f7ff",

                    particles_enabled = true,
                    particles_per_second = 120, -- matches 180Hz refresh rate
                    particle_spread = 0.4,
                    particle_lifetime = 80, -- short = fast streak effect

                    gamma = 1,
                },
            }

            local base = {
                cursor_color = "#89b4fa",
                smear_between_buffers = true,
                smear_between_neighbor_lines = true,
                smear_insert_mode = true,
            }

            return vim.tbl_deep_extend("force", base, styles[style])
        end,
    },
}
