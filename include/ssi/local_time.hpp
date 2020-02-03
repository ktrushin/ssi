#ifndef SSI_LOCAL_TIME_HPP
#define SSI_LOCAL_TIME_HPP

#include "boost/date_time/posix_time/posix_time.hpp"

namespace ssi {
// Return in the machine's timezone with second level resolution.
//
// Note. The sole purpose of using `boost::posix_time::ptime` as a return type
// is to demonstrate the public dependency of ssi library on
// boost datetime library.
__attribute__((__visibility__("default"))) boost::posix_time::ptime
local_time();
}  // namespace ssi
#endif  // SSI_LOCAL_TIME_HPP
