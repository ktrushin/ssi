#include "ssi/local_time.hpp"

namespace ssi {
boost::posix_time::ptime local_time() {
  return boost::posix_time::second_clock::local_time();
}
}  // namespace ssi
