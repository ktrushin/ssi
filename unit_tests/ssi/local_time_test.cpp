#include "ssi/local_time.hpp"

#include <gtest/gtest.h>

TEST(local_time_test, non_empty) {
  EXPECT_FALSE(boost::posix_time::to_simple_string(ssi::local_time()).empty());
}
