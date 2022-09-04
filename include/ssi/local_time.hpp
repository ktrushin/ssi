#ifndef SSI_LOCAL_TIME_HPP
#define SSI_LOCAL_TIME_HPP

#include "boost/date_time/posix_time/posix_time.hpp"

/// Namespece of the `ssi` library
namespace ssi {
/// Returns local time (in the machine's timezone) with one-second
/// resolution.
///
/// The sole purpose of using `boost::posix_time::ptime` as a return type
/// is to demonstrate the public dependency of ssi library on
/// boost datetime library. Please see the `lib/ssi/meson.build` file.
///
/// @returns the local time
///
/// @throws x where `x` is what (and when)
/// `boost::posix_time::second_clock::local_time` may throw
/// @exception_guarantee that of `boost::posix_time::second_clock::local_time`
///   function
/// @side_effects those of `boost::posix_time::second_clock::local_time`
///   function
[[gnu::visibility("default")]] boost::posix_time::ptime local_time();
}  // namespace ssi
#endif  // SSI_LOCAL_TIME_HPP
