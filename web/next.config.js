/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  webpack: (config, { isServer }) => {
    // Use memory cache to avoid path-based validation issues
    config.cache = {
      type: 'memory',
    };
    
    // Disable the problematic cache directory validation
    if (config.infrastructureLogging) {
      config.infrastructureLogging.debug = [];
    }
    
    return config;
  },
  onDemandEntries: {
    maxInactiveAge: 60 * 1000,
    pagesBufferLength: 5,
  },
};

module.exports = nextConfig;
