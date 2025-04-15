import React from 'react';

interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'accent';
  onClick?: () => void;
  type?: 'button' | 'submit' | 'reset';
  disabled?: boolean;
}

const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  onClick,
  type = 'button',
  disabled = false
}) => {
  const baseClasses = 'px-4 py-2 rounded font-medium transition-colors';
  const variantClasses = {
    primary: 'bg-indigo-600 text-white hover:bg-indigo-700',
    secondary: 'bg-emerald-500 text-white hover:bg-emerald-600',
    accent: 'bg-orange-500 text-white hover:bg-orange-600'
  };

  return (
    <button
      type={type}
      className={`${baseClasses} ${variantClasses[variant]}`}
      onClick={onClick}
      disabled={disabled}
    >
      {children}
    </button>
  );
};

export default Button; 