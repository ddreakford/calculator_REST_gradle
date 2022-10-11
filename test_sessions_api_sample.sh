#!/bin/sh
export DOMAIN=#####
export SEALIGHTS_AGENT_TOKEN=(cat sealights/sltoken-dev-cs.txt)
export TEST_STAGE="API Tests"
export LAB_ID=(cat buildSessionId.txt)
export BS_ID=(cat buildSessionId.txt)


# Create Test Session
curl -X POST "https://$DOMAIN/sl-api/v1/test-sessions" \
  -H "Authorization: Bearer $SEALIGHTS_AGENT_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"labId\":\"$LAB_ID\",\"testStage\":\"$TEST_STAGE\",\"bsid\":\"$BS_ID\",\"sessionTimeout\":10000}"

# Get List of Excluded Tests

# Run Tests

# Upload Test Results
# (This is an alternative to sending test events during test execution)

# Close/Delete Test Session
curl -X DELETE "https://$DOMAIN/sl-api/v1/test-sessions/$TEST_SESSION_ID" \
  -H "Authorization: Bearer $SEALIGHTS_AGENT_TOKEN" \
  -H "Content-Type: application/json" 
