# Perk Up!

A modern productivity application built with TypeScript, React, and Express.

## Technologies Used

- React 18
- TypeScript
- React Router v6
- Express
- Vite
- Jest for testing

## Project Structure

```
├── src/
│   ├── client/         # React client code
│   │   ├── components/ # Reusable components
│   │   ├── pages/      # Page components
│   │   ├── layouts/    # Layout components
│   │   ├── hooks/      # Custom React hooks
│   │   ├── utils/      # Utility functions
│   │   ├── tests/      # Test setup
│   │   ├── App.tsx     # Main App component
│   │   ├── main.tsx    # Client entry point
│   │   └── index.css   # Global styles
│   └── server/         # Express server code
│       └── index.ts    # Server entry point
├── public/             # Static assets
├── index.html          # HTML template
├── vite.config.ts      # Vite configuration
├── tsconfig.json       # TypeScript configuration
├── jest.config.js      # Jest configuration
└── package.json        # Project dependencies
```

## Getting Started

### Prerequisites

- Node.js 16.x or higher
- npm 7.x or higher

### Installation

```bash
npm install
```

### Development

To run the application in development mode:

```bash
npm run dev
```

This will start both the Vite development server and the Express server concurrently.

- Vite server: http://localhost:5173
- Express API: http://localhost:3001

### Testing

Run tests with Jest:

```bash
npm test
```

Run tests in watch mode:

```bash
npm run test:watch
```

### Building for Production

```bash
npm run build
```

### Running in Production

```bash
npm start
```

## API Endpoints

- `/api/health` - Health check endpoint

## Frontend Routes

- `/` - Home page 