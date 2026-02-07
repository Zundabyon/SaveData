/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['DotGothic16', 'monospace'],
        pixel: ['Press Start 2P', 'monospace'],
      },
    },
  },
  plugins: [],
}