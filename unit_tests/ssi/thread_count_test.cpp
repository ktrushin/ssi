#include "ssi/thread_count.hpp"

#include <gtest/gtest.h>

TEST(thread_count_test, positive) {
  EXPECT_GT(ssi::thread_count(), 0u);
}
