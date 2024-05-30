import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';
import path from 'path';

export default defineConfig({
  plugins: [svelte()],
  base: './',
  build: {
    outDir: 'build',
  },
  resolve: {
    alias: {
      $styles: path.resolve('./src/styles'),
      $types: path.resolve('./src/types'),
    },
  },
});