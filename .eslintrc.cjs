module.exports = {
  root: true,
  extends: ['plugin:@typescript-eslint/recommended', 'plugin:prettier/recommended'],
  env: {
    browser: true,
    es2020: true,
  },
  parserOptions: {
    sourceType: 'module',
  },
  rules: {
    'import/extensions': 'off',
    'no-console': 'off',
    '@typescript-eslint/dot-notation': 0,
    '@typescript-eslint/no-implied-eval': 0,
    '@typescript-eslint/no-throw-literal': 0,
    '@typescript-eslint/return-await': 0,
    '@typescript-eslint/lines-between-class-members': 'off',
  },
  overrides: [
    {
      files: ['**/*.mjs'],
      env: {
        node: true,
      },
      rules: {
        'no-console': 'off',
      },
    },
    {
      files: ['**/*.cjs'],
      env: {
        node: true,
        commonjs: true,
      },
      rules: {
        'no-console': 'off',
        'import/extensions': 'off',
      },
    },
    {
      files: ['**/*.spec.ts'],
      rules: {
        '@typescript-eslint/no-unused-vars': 'off',
        '@typescript-eslint/no-explicit-any': 'off',
        '@typescript-eslint/no-unused-expressions': 'off',
      },
    },
  ],
};
