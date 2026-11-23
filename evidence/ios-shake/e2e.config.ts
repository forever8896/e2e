import type { E2EConfig } from 'e2e';
import { mobile } from '@e2e-dev/mobile';

export default {
  projectId: 'dev.shakecount',
  tests: 'tests/**/*.e2e.ts',
  timeout: 900_000,
  actionTimeout: 300_000,
  targets: [
    {
      name: 'ios-simulator',
      engine: mobile({ platform: 'ios', device: process.env.UDID! }),
      app: { bundleId: 'dev.shakecount' },
    },
  ],
  reporters: ['list'],
} satisfies E2EConfig;
