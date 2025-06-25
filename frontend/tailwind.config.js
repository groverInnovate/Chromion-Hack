/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",],
  theme: {
    extend: {
      animation: {
        slideInLeft: "slideInLeft 4s ease-out forwards",
        slideInRight: "slideInRight 4s ease-out forwards",
        slideInTop: "slideInTop 4s ease-out forwards",
        slideInBottom: "slideInBottom 4s ease-out forwards"
      },
      keyframes: {
        slideInLeft: {
          "0%": { opacity: "0", transform: "translateX(-50px)" },
          "100%": { opacity: "1", transform: "translateX(0)" }
        },
        slideInRight: {
          "0%": { opacity: "0", transform: "translateX(50px)" },
          "100%": { opacity: "1", transform: "translateX(0)" }
        },
        slideInTop: {
          "0%": { opacity: "0", transform: "translateY(-50px)" },
          "100%": { opacity: "1", transform: "translateY(0)" }
        },
        slideInBottom: {
          "0%": { opacity: "0", transform: "translateY(50px)" },
          "100%": { opacity: "1", transform: "translateY(0)" }
        }
      }
    },
  },
  plugins: [],
}

