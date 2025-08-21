#!/bin/bash

# Comprehensive Script Testing Suite
echo "🚀 PostgreSQL Automation Scripts Test Suite"
echo "==========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0

# Function to print test results
print_result() {
    local test_name="$1"
    local result="$2"
    local details="$3"
    
    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}✅ PASS${NC} - $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    elif [ "$result" = "SKIP" ]; then
        echo -e "${YELLOW}⏭️  SKIP${NC} - $test_name - $details"
    else
        echo -e "${RED}❌ FAIL${NC} - $test_name - $details"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Test all scripts
echo -e "\n${BLUE}Testing Script Syntax and Permissions${NC}"
for script in *.sh; do
    if [ "$script" != "test-all-scripts.sh" ]; then
        echo -e "\n${YELLOW}Testing: $script${NC}"
        
        # Test executable permissions
        if [ -x "$script" ]; then
            print_result "$script executable" "PASS"
        else
            print_result "$script executable" "FAIL" "Not executable"
        fi
        
        # Test syntax
        if bash -n "$script" 2>/dev/null; then
            print_result "$script syntax" "PASS"
        else
            print_result "$script syntax" "FAIL" "Syntax errors"
        fi
    fi
done

echo -e "\n${BLUE}Summary:${NC}"
echo "Passed: $TESTS_PASSED"
echo "Failed: $TESTS_FAILED"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All basic tests passed!${NC}"
else
    echo -e "\n${RED}⚠️  Some tests failed.${NC}"
fi
