#ifndef SSI_THREAD_COUNT_HPP
#define SSI_THREAD_COUNT_HPP

namespace ssi {
/// Returns the number of parallel
/// threads of execution.
///
/// @returns number of parallel threads
///
/// @exception_guarantee noexcept
/// @side_effects none
[[gnu::visibility("default")]] unsigned int thread_count() noexcept;
}  // namespace ssi

#endif  // SSI_THREAD_COUNT_HPP
