export interface Customer {
  id: string;
  firstName: string | null;
  lastName: string | null;
  email: string | null;
  dateOfBirth: string | null;
  pointsBalance: number | null;
  referralUrl: string | null;
  state: string | null;
  vipTierId: string | null;
  createdAt: string | null;
  updatedAt: string | null;
}

export interface Reward {
  id: string;
  name: string;
  description: string | null;
  imageUrl: string | null;
  code: string | null;
  actionText: string | null;
  actionUrl: string | null;
  usageInstructions: string | null;
  termsAndConditions: string | null;
  expiresAt: string | null;
  usedAt: string | null;
  createdAt: string | null;
  updatedAt: string | null;
}

export interface PointsProduct {
  id: string;
  exchangeType: string;
  exchangeDescription: string;
  pointsPrice: number;
  variablePointsStep: number;
  variablePointsStepRewardValue: number;
  variablePointsMax: number;
  variablePointsMin: number;
  reward: Reward;
}