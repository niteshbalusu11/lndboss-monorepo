/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  publicRuntimeConfig: {
    apiUrl: `${process.env.BASE_PATH || ''}/api`,
    basePath: process.env.BASE_PATH || '',
  },
};

module.exports = nextConfig;
