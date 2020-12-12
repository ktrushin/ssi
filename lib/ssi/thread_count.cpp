#include "ssi/thread_count.hpp"

#include <boost/thread/thread.hpp>

namespace ssi {
unsigned int thread_count() noexcept {
  // Note. The sole purpose of using `boost::thread` (rather than `std::thread`)
  // is to demonstrate private dependency of ssi library on
  // booost thread library.
  return boost::thread::hardware_concurrency();
}
}  // namespace ssi
