// ============================================================
// CCoE Landing Zone — Cost Governance (subscription scope)
//
// - Subscription budget with threshold alerts + email recipients
// - Per-environment budgets are created by the FinOps analyst
//   once workloads land (see Delivery Action Plan, Phase 1.12)
//
// Tag enforcement lives in policies/bicep/ — do not duplicate it here.
// ============================================================

targetScope = 'subscription'

param prefix string = 'ccoe'
@description('Monthly budget ceiling for the subscription (USD)')
param monthlyBudgetUsd int = 50000
@description('Email recipients for threshold alerts')
param alertRecipients array = [ 'ccoe-alerts@example.com' ]
@description('Threshold percentages that trigger an alert')
param thresholds array = [ 80, 95, 100 ]

resource subscriptionBudget 'Microsoft.Consumption/budgets@2023-04-01' = {
  name: '${prefix}-subscription-monthly'
  scope: subscription()
  properties: {
    category: 'ActualCost'
    timeGrain: 'Monthly'
    amount: monthlyBudgetUsd
    currencyCode: 'USD'
    notificationMode: 'Standard'
    notifications: {
      recipients: alertRecipients
      thresholdNotifications: [ for t in thresholds: {
        thresholdPercentage: float(t)
        thresholdType: 'Actual'
      } ]
    }
  }
}

// ------------------------------------------------------------
// Outputs
// ------------------------------------------------------------
output budgetResourceId string = subscriptionBudget.id
