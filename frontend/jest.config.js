module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'jest-environment-jsdom',
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/client/$1',
  },
  setupFilesAfterEnv: ['<rootDir>/src/client/tests/setupTests.ts'],
  testMatch: ['**/*.test.tsx', '**/*.test.ts'],
  transform: {
    '^.+\\.(ts|tsx)$': ['ts-jest', {
      tsconfig: 'tsconfig.json',
    }],
  },
}; 