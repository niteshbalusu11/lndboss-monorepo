/* eslint-disable @typescript-eslint/no-var-requires */
const path = require('path');
const dotenv = require('dotenv');
const { homedir } = require('os');

dotenv.config({ path: path.resolve(process.cwd(), '.env') });
dotenv.config({ path: path.join(homedir(), '.bosgui', '.env') });
dotenv.config({ path: path.resolve(process.cwd(), '../', '../', '.env') });

module.exports = {
  publicRuntimeConfig: {
    apiUrl: `${process.env.NEXT_PUBLIC_BASE_PATH || ''}/api`,
    basePath: process.env.NEXT_PUBLIC_BASE_PATH || '',
  },
};
