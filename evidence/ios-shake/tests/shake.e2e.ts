import { execFileSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { expect, test } from 'e2e';

/** The app's own count of UIKit shake events, read from its data container. */
function shakes(): number {
  const container = execFileSync('xcrun', ['simctl', 'get_app_container', process.env.UDID!, 'dev.shakecount', 'data'], { encoding: 'utf8' }).trim();
  return Number(readFileSync(`${container}/Documents/shakes.txt`, 'utf8'));
}

test.beforeEach(async ({ app }) => {
  await app.restart();
});

test('each device.shake() is one shake event in the app', async ({ device }) => {
  await expect.poll(shakes).toBe(0);
  await device.shake();
  await expect.poll(shakes).toBe(1);
  await device.shake();
  await device.shake();
  await expect.poll(shakes).toBe(3);
});

test('the screen shows the shake', async ({ device, screen }) => {
  await expect(screen.getByText('Shakes: 0')).toBeVisible();
  await device.shake();
  await expect(screen.getByText('Shakes: 1')).toBeVisible();
});
