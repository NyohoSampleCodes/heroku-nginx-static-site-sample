const withSass = require('@zeit/next-sass');
const withCSS = require('@zeit/next-css')
module.exports = withCSS(withSass({
  assetPrefix: './',

  webpack: config => {
    config.devtool = 'source-map';
    config.module.rules.push({
      test: /\.(png|jpe?g|gif|woff|woff2|eot|ttf|svg)$/,
      use: {
        loader: 'file-loader',
        options: {},
      }
    });
    for (const r of config.module.rules) {
      if (r.loader === 'babel-loader') {
        r.options.sourceMaps = true
      }
    }
    return config
  },

  exportPathMap: async function(
    defaultPathMap,
    { dev, dir, outDir, distDir, buildId }
  ) {
    return {
      '/': { page: '/' },
      '/about.html': { page: '/about' },
    }
  },
}))
