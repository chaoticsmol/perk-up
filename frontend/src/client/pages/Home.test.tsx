import { render, screen } from '@testing-library/react';
import Home from './Home';

describe('Home component', () => {
  it('renders welcome message', () => {
    render(<Home />);
    const headingElement = screen.getByText(/Welcome to Perk Up!/i);
    expect(headingElement).toBeInTheDocument();
  });
}); 
