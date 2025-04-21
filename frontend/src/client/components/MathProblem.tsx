import { useState } from 'react';
import './MathProblem.css';
import { checkMathProblem } from '@/api/smile/check-math-problem';
import { Customer } from '@/api/smile';
type Operator = 'div' | 'mult' | 'add' | 'sub';

interface MathChallenge {
  left: number;
  operator: Operator;
  right: number;
}

interface MathProblemProps {
  customer: Customer;
}

const generateRandomNumber = () => {
  return Math.floor(Math.random() * 201) - 100; // Random number between -100 and 100
};

const generateOperator = (): Operator => {
  const operators: Operator[] = ['div', 'mult', 'add', 'sub'];
  return operators[Math.floor(Math.random() * operators.length)];
};

const generateChallenge = (): MathChallenge => {
  let left = generateRandomNumber();
  let right = generateRandomNumber();
  let operator = generateOperator();

  // Ensure we don't divide by zero
  if (operator === 'div' && right === 0) {
    return generateChallenge();
  }

  return { left, operator, right };
};

const getOperatorSymbol = (operator: Operator): string => {
  switch (operator) {
    case 'div': return '÷';
    case 'mult': return 'x';
    case 'add': return '+';
    case 'sub': return '-';
  }
};

const MathProblem: React.FC<MathProblemProps> = ({ customer }: MathProblemProps) => {
  const [challenge, setChallenge] = useState<MathChallenge>(generateChallenge());
  const [userAnswer, setUserAnswer] = useState<string>('');
  const [isCorrect, setIsCorrect] = useState<boolean | null>(null);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const userNumericAnswer = parseFloat(userAnswer);
    checkMathProblem(customer.id, challenge.left, challenge.operator, challenge.right, userNumericAnswer).then((result) => {
      setIsCorrect(result.correct);
    });
  };

  const handleNewProblem = () => {
    setChallenge(generateChallenge());
    setUserAnswer('');
  };

  return (
    <div className="math-problem">
      <h3>Math Challenge</h3>
      <p>Solve a challenge to win points!</p>
      <div className="problem-display">
        {challenge.left} {getOperatorSymbol(challenge.operator)} {challenge.right} 
      </div>
      <form onSubmit={handleSubmit}>
        <input
          type="number"
          step="any"
          value={userAnswer}
          onChange={(e) => setUserAnswer(e.target.value)}
          placeholder="Enter your answer"
        />
        <button type="submit">Check Answer</button>
      </form>
      {isCorrect !== null && (
        <div className={`result ${isCorrect ? 'correct' : 'incorrect'}`}>
          {isCorrect ? 'Correct!' : 'Try again!'}
        </div>
      )}
      <button onClick={handleNewProblem}>New Problem</button>
    </div>
  );
};

export default MathProblem;
